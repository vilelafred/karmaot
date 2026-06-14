local presentbox = Action()
local presents = {
    [6840] = { -- item id of the item that will give u random items
        {2268, 25}, {2687, 10}, {2687, 10}, {6147, 10}, {6146, 10}, {2789, 100}, {2304, 25}, {2273, 25}, 2114 --Setup the rewards here
    }
}

function presentbox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local targetItem = presents[item.itemid]
    if not targetItem then
        return true
    end
    
    local count = 1
    local gift = targetItem[math.random(#targetItem)]
    if type(gift) == "table" then
        count = gift[2]
        gift = gift[1]
    end
    
    player:addItem(gift, count)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got a ".. ItemType(gift):getName() ..".")
    
    item:remove(1)
    fromPosition:sendMagicEffect(45)
    return true
end

presentbox:id(6840)
presentbox:register()