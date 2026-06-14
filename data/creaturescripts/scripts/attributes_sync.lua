-- Sends aggregated item attributes/resistances to client via extended opcode

local ATTRIBUTES_OPCODE = 214

-- Slots to inspect
local CHECK_SLOTS = {
    CONST_SLOT_LEFT,
    CONST_SLOT_RIGHT,
    CONST_SLOT_HEAD,
    CONST_SLOT_NECKLACE,
    CONST_SLOT_ARMOR,
    CONST_SLOT_LEGS,
    CONST_SLOT_FEET,
    CONST_SLOT_RING,
    CONST_SLOT_AMMO
}

-- Cache to avoid resending unchanged data
local playerAttrCache = {}

local function getElementAbsorbFromDesc(itemDesc, combatType)
    local elementNames = {
        [COMBAT_PHYSICALDAMAGE] = "physical",
        [COMBAT_FIREDAMAGE] = "fire",
        [COMBAT_ICEDAMAGE] = "ice",
        [COMBAT_ENERGYDAMAGE] = "energy",
        [COMBAT_EARTHDAMAGE] = "earth",
        [COMBAT_DEATHDAMAGE] = "death",
        [COMBAT_HOLYDAMAGE] = "holy"
    }

    local absorb = 0

    local allProtection = itemDesc:match("protection all %+(%d+)%%")
    if allProtection then
        absorb = absorb + tonumber(allProtection)
    end

    local elementName = elementNames[combatType]
    if elementName then
        local elementProtection = itemDesc:match(elementName .. " ([+-]%d+)%%")
        if elementProtection then
            absorb = absorb + tonumber(elementProtection)
        end
    end

    return absorb
end

local function buildEquipmentSignature(player)
    local parts = {}
    for i = 1, #CHECK_SLOTS do
        local item = player:getSlotItem(CHECK_SLOTS[i])
        if item then
            table.insert(parts, tostring(item:getId()))
            local desc = item:getDescription() or ""
            table.insert(parts, desc)
        else
            table.insert(parts, "0")
        end
    end
    return table.concat(parts, "|")
end

local function computePlayerAttributes(player)
    local totals = {
        critChance = 0,
        spellDamage = 0,
        manaLeech = 0,
        lifeLeech = 0,
        stunChance = 0,
        multiShot = 0,
        manaShield = 0,
        resistances = {
            physical = 0,
            fire = 0,
            ice = 0,
            energy = 0,
            earth = 0,
            death = 0,
            holy = 0
        }
    }

    -- Helper for custom and native resistances from description
    local function accumulateResistsFromDesc(desc)
        local names = {
            {key = "physical", label = "Physical", type = COMBAT_PHYSICALDAMAGE},
            {key = "fire",     label = "Fire",     type = COMBAT_FIREDAMAGE},
            {key = "ice",      label = "Ice",      type = COMBAT_ICEDAMAGE},
            {key = "energy",   label = "Energy",   type = COMBAT_ENERGYDAMAGE},
            {key = "earth",    label = "Poison",   type = COMBAT_EARTHDAMAGE}, -- item descriptions often use 'poison'
            {key = "death",    label = "Death",    type = COMBAT_DEATHDAMAGE},
            {key = "holy",     label = "Holy",     type = COMBAT_HOLYDAMAGE}
        }

        for _, n in ipairs(names) do
            local custom = desc:match("%[" .. n.label .. " Resistance: %+(%d+)%%%]")
            if custom then
                totals.resistances[n.key] = totals.resistances[n.key] + tonumber(custom)
            end

            -- native form: "fire +X%" or "fire -X%"
            local lname = n.label:lower()
            if lname == "poison" then lname = "earth" end -- normalize
            local nat = desc:match(lname .. " ([+-]%d+)%%")
            if nat then
                totals.resistances[n.key] = totals.resistances[n.key] + tonumber(nat)
            end

            -- base absorbPercent and protection all
            totals.resistances[n.key] = totals.resistances[n.key] + getElementAbsorbFromDesc(desc, n.type)
        end
    end

    for i = 1, #CHECK_SLOTS do
        local item = player:getSlotItem(CHECK_SLOTS[i])
        if item then
            local desc = item:getDescription() or ""

            local crit = desc:match("Crit Chance: %+?(%d+)%%")
            if crit then totals.critChance = totals.critChance + tonumber(crit) end

            local spell = desc:match("Spell Damage: [+-](%d+)%%")
            if spell then totals.spellDamage = totals.spellDamage + tonumber(spell) end

            local ml = desc:match("%[Mana Leech: %+(%d+)%%%]")
            if ml then totals.manaLeech = totals.manaLeech + tonumber(ml) end

            local ll = desc:match("%[Life Leech: %+(%d+)%%%]")
            if ll then totals.lifeLeech = totals.lifeLeech + tonumber(ll) end

            local st = desc:match("%[Stun Chance: %+(%d+)%%%]")
            if st then totals.stunChance = totals.stunChance + tonumber(st) end

            local ms = desc:match("%[Multi Shot: %+(%d+)%]")
            if ms then
                -- multi-shot stacks poorly; present the highest found
                totals.multiShot = math.max(totals.multiShot, tonumber(ms))
            end

            local mshield = desc:match("%[Mana Shield: %+(%d+)%%%]")
            if mshield then totals.manaShield = totals.manaShield + tonumber(mshield) end

            accumulateResistsFromDesc(desc)
        end
    end

    return totals
end

local function sendPlayerAttributes(player, force)
    if not player or not player:isPlayer() or not player:isUsingOtClient() then
        return
    end

    local pid = player:getGuid()
    local signature = buildEquipmentSignature(player)
    local cache = playerAttrCache[pid]
    if cache and cache.signature == signature and not force then
        return
    end

    local totals = computePlayerAttributes(player)
    player:sendExtendedJSONOpcode(ATTRIBUTES_OPCODE, totals)

    playerAttrCache[pid] = {
        signature = signature,
        lastSend = os.time()
    }
end

local function attributesSyncTick(playerId)
    local player = Player(playerId)
    if not player then
        playerAttrCache[playerId] = nil
        return
    end
    sendPlayerAttributes(player, false)
    addEvent(attributesSyncTick, 1000, playerId)
end

function onLogin(player)
    sendPlayerAttributes(player, true)
    addEvent(attributesSyncTick, 1000, player:getGuid())
    return true
end

function onLogout(player)
    playerAttrCache[player:getGuid()] = nil
    return true
end


