local COOLDOWN = 600 -- seconds
local STORAGE = 25005
local EFFECT = 37
local REQUIRED_LEVEL = 200
local RING_ID = 5807

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Level check
    if player:getLevel() < REQUIRED_LEVEL then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You need to be at least level " .. REQUIRED_LEVEL .. " to use this ring.")
        return true
    end

    -- Protection Zone check
    if player:getTile() and player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You cannot use this ring in a protection zone.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- Cooldown check
    local now = os.time()
    local lastUsed = player:getStorageValue(STORAGE)
    if lastUsed > 0 and (now - lastUsed) < COOLDOWN then
        local remaining = COOLDOWN - (now - lastUsed)
        local minutes = math.floor(remaining / 60)
        local seconds = remaining % 60
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You must wait " .. minutes .. "m " .. seconds .. "s before using this ring again.")
        return true
    end

    -- Effect and healing
    player:addHealth(3000)
    player:addMana(3000)
    player:getPosition():sendMagicEffect(EFFECT)
    player:say("The power of blessed has restored your energy!", TALKTYPE_MONSTER_SAY)
    player:setStorageValue(STORAGE, now)
    return true
end
