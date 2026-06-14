local stonePosition = Position(32716, 32057, 15)
local stoneId = 6012
local leverIds = {on = 1945, off = 1946} -- 1945 = lever up, 1946 = lever down

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tile = Tile(stonePosition)
    if not tile then
        return false
    end

    local stone = tile:getItemById(stoneId)

    if stone then
        -- Stone is present, remove it and switch lever
        stone:remove()
        item:transform(leverIds.off)
        player:say("You removed the stone!", TALKTYPE_MONSTER_SAY)
    else
        -- Stone is not present, create it and switch lever
        Game.createItem(stoneId, 1, stonePosition)
        item:transform(leverIds.on)
        player:say("You placed the stone back!", TALKTYPE_MONSTER_SAY)
    end
    return true
end
