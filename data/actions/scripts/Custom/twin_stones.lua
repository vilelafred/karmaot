local config = {
    [6077] = { -- Lever 1 controls Stone 1
        stonePosition = Position(32848, 32071, 15)
    },
    [6078] = { -- Lever 2 controls Stone 2
        stonePosition = Position(32848, 32072, 15)
    }
}

local stoneId = 6012
local leverIds = {on = 1945, off = 1946} -- Lever up/down
local RESPAWN_MS = 90 * 1000               -- 90 seconds

-- Simple anti-spam exhausted (in seconds)
local EXHAUST_STORAGE = 900800
local EXHAUST_SECONDS = 15

local function respawnStone(posTable)
    local pos = Position(posTable.x, posTable.y, posTable.z)
    local tile = Tile(pos)
    if not tile then
        return
    end
    if not tile:getItemById(stoneId) then
        Game.createItem(stoneId, 1, pos)
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
    local actionId = item.actionid
    local setting = config[actionId]
    if not setting then
        player:sendCancelMessage("This lever is not configured.")
        return true
    end

    local tile = Tile(setting.stonePosition)
    if not tile then
        player:sendCancelMessage("Could not locate the tile.")
        return true
    end

    local stone = tile:getItemById(stoneId)

    if stone then
        stone:remove()
        item:transform(leverIds.off)
        player:say("You removed the stone!", TALKTYPE_MONSTER_SAY)
        addEvent(respawnStone, RESPAWN_MS, { x = setting.stonePosition.x, y = setting.stonePosition.y, z = setting.stonePosition.z })
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    else
        Game.createItem(stoneId, 1, setting.stonePosition)
        item:transform(leverIds.on)
        player:say("You placed the stone back!", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    end

    return true
end
