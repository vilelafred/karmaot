-- Script for the teleport at position {x = 31893, y = 32713, z = 10}

local config = {
    teleportPosition = {x = 31893, y = 32713, z = 10},
    maxLevel = 999,
    cooldownStorage = 47333, -- Stores the time of the last entry
    cooldownTime = 1 * 60 * 60, -- Cooldown time in seconds (24 hours)
}

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds)
end

function onStepIn(cid, item, position, fromPosition)
    local player = Player(cid)
    
    -- Check if the player is premium
    if not player:isPremium() then
        player:sendCancelMessage("Only premium players are allowed to enter this teleport.")
        player:teleportTo(fromPosition)
        return true
    end
    
    -- Check if the player is below the maximum level allowed
    if player:getLevel() > config.maxLevel then
        player:sendCancelMessage("You are too high level to enter this teleport.")
        player:teleportTo(fromPosition)
        return true
    end
    
    -- Check the cooldown
    local lastEntryTime = player:getStorageValue(config.cooldownStorage)
    local elapsedTime = os.time() - lastEntryTime
    
    if elapsedTime < config.cooldownTime then
        local remainingTime = config.cooldownTime - elapsedTime
        local formattedTime = formatTime(remainingTime)
        player:sendCancelMessage("You must wait " .. formattedTime .. " before entering again.")
        player:teleportTo(fromPosition)
        return true
    end
    
    -- Teleport the player to the new specified position
    player:teleportTo(config.teleportPosition)
    
    -- Update the time of the last entry
    player:setStorageValue(config.cooldownStorage, os.time())
    
    return true
end
