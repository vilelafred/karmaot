-- data/actions/scripts/daily_magic_sulphur.lua
-- Multi-chest shared cooldown & count (TFS 1.5 / Nekiro)
-- Each chest gives 1x item 6846. Teleport triggers only on the last chest of the cycle.

local config = {
    -- player storages
    countStorage     = 46333,         -- how many chests collected in the current cycle
    cooldownStorage  = 41333,         -- os.time() when the cycle ends
    usedBaseStorage  = 700000,        -- base + stable chest key (AID/pos)

    cooldownSeconds  = 20 * 60 * 60,  -- 24h cycle (use 12*60*60 for 12h)
    maxPerCycle      = 4,             -- number of chests per cycle

    reward           = { id = 6846, count = 1 }, -- magic sulphur

    -- Teleport only on the LAST chest:
    teleportOnLast   = true,
    destination      = { x = 32353, y = 31694, z = 12 },

    -- optional: anti double-click spam (1 second)
    clickExhaustStorage = 41556,
    clickExhaustSeconds = 1,
}

local function formatTimeLeft(seconds)
    if seconds < 0 then seconds = 0 end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- 🔒 Chave estável por baú: AID > posição (NUNCA UID)
local function getStableChestKey(item, toPosition)
    if item.actionid and item.actionid > 0 then
        return item.actionid
    end
    -- fallback: posição
    return (toPosition.x + toPosition.y * 1000 + toPosition.z * 1000000)
end

function onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
    local player = Player(cid)
    if not player then
        return true
    end

    local now = os.time()

    -- anti double-click (opcional)
    local nextClick = player:getStorageValue(config.clickExhaustStorage)
    if nextClick ~= -1 and nextClick > now then
        return true
    end
    player:setStorageValue(config.clickExhaustStorage, now + config.clickExhaustSeconds)

    -- inicia/renova ciclo se expirou
    local cycleEnds = player:getStorageValue(config.cooldownStorage)
    if cycleEnds == -1 or cycleEnds < now then
        cycleEnds = now + config.cooldownSeconds
        player:setStorageValue(config.cooldownStorage, cycleEnds)
        player:setStorageValue(config.countStorage, 0)
    end

    -- chave única ESTÁVEL do baú
    local chestKey = getStableChestKey(item, toPosition)
    local usedKey = config.usedBaseStorage + chestKey

    -- já usou ESTE baú neste ciclo?
    local chestUsedUntil = player:getStorageValue(usedKey)
    if chestUsedUntil ~= -1 and chestUsedUntil >= now then
        player:sendCancelMessage("This chest is already empty for you in this cycle. Find another chest.")
        return true
    end

    -- limite por ciclo?
    local taken = player:getStorageValue(config.countStorage)
    if taken < 0 then taken = 0 end
    if taken >= config.maxPerCycle then
        player:sendCancelMessage("You have collected all chests for this cycle. Wait: " .. formatTimeLeft(cycleEnds - now) .. ".")
        return true
    end

    -- recompensa
    local rewardItem = Game.createItem(config.reward.id, config.reward.count)
    if player:addItemEx(rewardItem) ~= RETURNVALUE_NOERROR then
        if rewardItem and rewardItem.remove then rewardItem:remove() end
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("Not enough capacity or free slots.")
        return true
    end

    -- marcar ESTE baú como usado até o fim do ciclo
    player:setStorageValue(usedKey, cycleEnds)

    -- incrementa contagem
    local newCount = taken + 1
    player:setStorageValue(config.countStorage, newCount)

    -- feedback
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You received 1x magic sulphur. (" .. newCount .. "/" .. config.maxPerCycle .. ")")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

    -- teleporta se foi o último do ciclo
    if config.teleportOnLast and newCount >= config.maxPerCycle then
        player:teleportTo(config.destination)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end

    return true
end
