local stonePosition = Position(32941, 30345, 9)
local stoneId = 5072
local leverIds = {on = 1945, off = 1946} -- 1945 = lever up, 1946 = lever down
local resetTime = 6000 * 1000 -- 30 seconds in milliseconds

-- Simple anti-spam exhausted (in seconds)
local EXHAUST_STORAGE = 600898
local EXHAUST_SECONDS = 15

-- Function to reset stone to original state
local function resetStone()
    local tile = Tile(stonePosition)
    if not tile then
        return
    end

    local stone = tile:getItemById(stoneId)
    local lever = tile:getItemById(leverIds.off)
    
    if not stone then
        -- Stone was removed, place it back
        Game.createItem(stoneId, 1, stonePosition)
    end
    
    for x = -5, 5 do
        for y = -5, 5 do
            local checkPos = Position(stonePosition.x + x, stonePosition.y + y, stonePosition.z)
            local checkTile = Tile(checkPos)
            if checkTile then
                local leverOff = checkTile:getItemById(leverIds.off)
                if leverOff then
                    leverOff:transform(leverIds.on)
                    break
                end
            end
        end
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Exhaustion: block rapid repeated clicks
    local now = os.time()
    local untilTime = player:getStorageValue(EXHAUST_STORAGE)
    if untilTime ~= -1 and untilTime > now then
        player:sendCancelMessage("You must wait " .. (untilTime - now) .. " seconds before using this lever again.")
        return true
    end
    local tile = Tile(stonePosition)
    if not tile then
        return false
    end

    local stone = tile:getItemById(stoneId)

    if stone then
        -- Stone is present, remove it and switch lever
        stone:remove()
        item:transform(leverIds.off)
        player:say("You removed the eletric fence! It will return in 1 hour. RUNNNN!!", TALKTYPE_MONSTER_SAY)
        
        addEvent(resetStone, resetTime)
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    else   
        -- Stone is not present, create it and switch lever
        Game.createItem(stoneId, 1, stonePosition)
        item:transform(leverIds.on)
        player:say("You placed the eletric fence back!", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    end
    return true
end
