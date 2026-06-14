-- ===== AJUSTE GLOBAL DE FACILIDADE =====
local DROP_MULT = 4.0  -- 1.0 = normal | 1.5 = +50% | 2.0 = dobro

-- Normaliza getStorageValue (-1 => 0)
local function getPoints(player, storageKey)
    local v = player:getStorageValue(storageKey)
    return (type(v) == "number" and v > 0) and v or 0
end

local function addRewardLoot(uid, bossName, rewardTable, rankIndex, playerPoints, topPoints)
    local money = math.random(10, 40)
    local player = Player(uid)
    local chest = Game.createItem(REWARDCHEST.rewardBagId)

    if not player or not chest then return end

    chest:setAttribute("description", "Reward System has kill the boss " .. bossName .. ".")

    -- Soma itens iguais para formatar mensagem e evitar duplicados
    local itemCounts = {}
    local function addToCounts(itemId, count)
        if itemId and count and count > 0 then
            itemCounts[itemId] = (itemCounts[itemId] or 0) + count
            chest:addItem(itemId, count)
        end
    end

    for _, reward in ipairs(rewardTable) do
        local id, max, baseChance, floorChance, tier
        if reward.id then
            id = reward.id; max = reward.max or 1; baseChance = reward.chance or 0; floorChance = reward.floor or 0; tier = reward.tier
        else
            id = reward[1]; max = reward[2] or 1; baseChance = reward[3] or 0; floorChance = 0; tier = reward.tier
        end
        local eff
        if tier == "veryRare" then
            -- Para veryRare, usa somente a chance do floor (tier), ignorando a chance base do item
            eff = math.max(0, math.min(100, floorChance or 0))
        else
            -- Demais tiers mantêm a lógica original (mínimo pelo floor, multiplicador global)
            eff = math.max(floorChance or 0, math.min(100, math.floor(baseChance * DROP_MULT)))
        end
        if eff >= 100 or math.random(100) <= eff then
            local count = math.random(1, max)
            addToCounts(id, count)
        end
    end

    -- Dinheiro (crystal coins)
    addToCounts(2160, money)

    -- Entrega
    local townId = (player:getTown() and player:getTown():getId()) or REWARDCHEST.town_id
    local depotChest = player:getDepotChest(townId, true)
    local addedOk = false
    if depotChest then
        addedOk = (depotChest:addItemEx(chest) == RETURNVALUE_NOERROR)
    end
    if not addedOk then
        local inbox = player.getInbox and player:getInbox() or nil
        if inbox then
            inbox:addItemEx(chest)
        else
            player:addItemEx(chest, false)
        end
    end

    -- Formata mensagem amigável
    local parts = {}
    for id, count in pairs(itemCounts) do
        local it = ItemType(id)
        local name = it:getName()
        if count == 1 then
            table.insert(parts, name)
        else
            local plural = (it.getPluralName and it:getPluralName()) or (name:match("s$") and name or (name .. "s"))
            table.insert(parts, tostring(count) .. " " .. plural)
        end
    end
    table.sort(parts)

    local msg
    if #parts == 0 then
        msg = "Your reward chest is empty."
    elseif #parts == 1 then
        msg = "The following items are available in your reward chest: " .. parts[1] .. "."
    else
        msg = "The following items are available in your reward chest: " .. table.concat(parts, ", ", 1, #parts - 1) .. " and " .. parts[#parts] .. "."
    end
    player:sendTextMessage(MESSAGE_INFO_DESCR, msg)

    if REWARDCHEST.debugPrint then
        local summary = table.concat(parts, ", ")
        print(string.format("[RewardBoss] boss=%s | player=%s | rank=%d | points=%d/%d | loot=[%s]",
            bossName, player:getName(), rankIndex or -1, playerPoints or 0, topPoints or 0, summary))
    end

    local boss = REWARDCHEST.bosses[bossName]
    player:setStorageValue(boss.storage, 0)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
end

local function addLoot(lootTable, rewardTable, allLoot, floorChance, tierName)
    if not lootTable or #lootTable == 0 then return end
    local function wrap(entry)
        if type(entry) == "table" and (entry.id or entry[1]) then
            local id = entry.id or entry[1]
            local max = entry.max or entry[2]
            local chance = entry.chance or entry[3]
            return { id = id, max = max, chance = chance, floor = floorChance, tier = tierName }
        end
        return entry
    end
    if allLoot then
        for _, loot in ipairs(lootTable) do
            table.insert(rewardTable, wrap(loot))
        end
    else
        table.insert(rewardTable, wrap(lootTable[math.random(#lootTable)]))
    end
end

local function rewardChestSystem(bossName)
    local players = {}
    local boss = REWARDCHEST.bosses[bossName]
    if not boss then return end

    for _, player in ipairs(Game.getPlayers()) do
        local points = getPoints(player, boss.storage)
        if points > 0 then
            table.insert(players, {player = player, points = points})
        end
    end

    table.sort(players, function(a, b) return a.points > b.points end)
    local topPoints = players[1] and players[1].points or 0
    if #players == 0 or topPoints <= 0 then return end

    local function getTierAndFloors(rankIndex, points, topPoints)
        if rankIndex == 1 then
            return {
                common = 90,
                semiRare = 60,
                rare = 25,
                veryRare = 6,
            }
        end
        if points >= math.ceil(topPoints * 0.8) then
            return { common = 80, semiRare = 50, rare = 20, veryRare = 4 }
        elseif points >= math.ceil(topPoints * 0.6) then
            return { common = 70, semiRare = 40, rare = 15, veryRare = 0 }
        elseif points >= math.ceil(topPoints * 0.4) then
            return { common = 60, semiRare = 30, rare = 0, veryRare = 0 }
        elseif points >= math.ceil(topPoints * 0.2) then
            return { common = 50, semiRare = 0, rare = 0, veryRare = 0 }
        end
        return nil
    end

    for i, playerData in ipairs(players) do
        local player = playerData.player
        local points = playerData.points
        local rewardTable = {}

        local floors = getTierAndFloors(i, points, topPoints)
        if floors then
            if boss.common then addLoot(boss.common, rewardTable, false, floors.common, "common") end
            if boss.semiRare then addLoot(boss.semiRare, rewardTable, false, floors.semiRare, "semiRare") end
            if boss.rare then addLoot(boss.rare, rewardTable, false, floors.rare, "rare") end
            if boss.veryRare and (floors.veryRare or 0) > 0 then
                local gateChance = (i == 1) and (REWARDCHEST.top1VeryRareGate or 30) or (REWARDCHEST.nonTopVeryRareGate or 20)
                if math.random(100) <= gateChance then
                    addLoot(boss.veryRare, rewardTable, false, floors.veryRare, "veryRare")
                end
            end
        end

        addLoot(boss.always,   rewardTable, true, 100, "always")
        addRewardLoot(player:getId(), bossName, rewardTable, i, points, topPoints)
    end
end

local RewardChestDeath = CreatureEvent("RewardChestDeath")
function RewardChestDeath.onDeath(creature, corpse, killer)
    local boss = REWARDCHEST.bosses[creature:getName():lower()]
    if boss then
        addEvent(rewardChestSystem, 1000, creature:getName():lower())
    end
    return true
end
RewardChestDeath:register()

local RewardChestMonster = CreatureEvent("RewardChestMonster")
function RewardChestMonster.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:isMonster() and attacker and attacker:isPlayer() then
        local boss = REWARDCHEST.bosses[creature:getName():lower()]
        if boss then
            local currentPoints = getPoints(attacker, boss.storage)
            local dealt = math.abs(primaryDamage)
            local newPoints = currentPoints + math.ceil(dealt / REWARDCHEST.formula.hit)
            attacker:setStorageValue(boss.storage, newPoints)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
RewardChestMonster:register()

local LoginPlayer = CreatureEvent("LoginPlayer")
function LoginPlayer.onLogin(player)
    for _, value in pairs(REWARDCHEST.bosses) do
        if player:getStorageValue(value.storage) > 0 then
            player:setStorageValue(value.storage, 0)
        end
    end
    player:registerEvent("RewardChestStats")
    return true
end
LoginPlayer:register()

local RewardChestStats = CreatureEvent("RewardChestStats")
function RewardChestStats.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if attacker and attacker:isMonster() then
        local boss = REWARDCHEST.bosses[attacker:getName():lower()]
        if boss then
            local currentPoints = getPoints(creature, boss.storage)
            local newPoints = currentPoints + math.ceil(math.abs(primaryDamage) / REWARDCHEST.formula.block)
            creature:setStorageValue(boss.storage, newPoints)
            creature:setStorageValue(REWARDCHEST.storageExhaust, os.time() + 5)
        end
    elseif attacker and attacker:isPlayer() and (primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING)
        and (creature:getHealth() < creature:getMaxHealth())
        and (creature:getStorageValue(REWARDCHEST.storageExhaust) >= os.time()) then

        for _, valor in pairs(REWARDCHEST.bosses) do
            if getPoints(creature, valor.storage) > 0 then
                local add = math.min(math.abs(primaryDamage), creature:getMaxHealth() - creature:getHealth())
                local currentPoints = getPoints(attacker, valor.storage)
                local newPoints = currentPoints + math.ceil(add / REWARDCHEST.formula.support)
                attacker:setStorageValue(valor.storage, newPoints)
            end
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
RewardChestStats:register()
