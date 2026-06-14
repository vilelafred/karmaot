local config = {
    teleportPosition = Position(33325, 32055, 8),
    maxLevel = 999,
    cooldownStorage = 47444,
    cooldownTime = 1 * 60 * 60 -- 24 horas
}

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return true
    end

    local player = creature

    -- Checar premium
    if not player:isPremium() then
        player:sendCancelMessage("Only premium players are allowed to enter this teleport.")
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    -- Checar level máximo
    if player:getLevel() > config.maxLevel then
        player:sendCancelMessage("You are too high level to enter this teleport.")
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    -- Checar cooldown
    local lastTime = player:getStorageValue(config.cooldownStorage)
    local now = os.time()

    if lastTime ~= -1 and now - lastTime < config.cooldownTime then
        local remaining = config.cooldownTime - (now - lastTime)
        player:sendCancelMessage("You must wait " .. formatTime(remaining) .. " before entering again.")
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    -- Teleportar e aplicar novo cooldown
    player:setStorageValue(config.cooldownStorage, now)
    player:teleportTo(config.teleportPosition)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    return true
end
