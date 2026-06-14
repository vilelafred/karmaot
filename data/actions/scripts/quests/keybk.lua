function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local storage = 20094 -- ID único para bloquear múltiplos usos
    if player:getStorageValue(storage) > 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "The dead tree is empty.")
        return true
    end

    local key = Game.createItem(2088, 1)
    key:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This mysterious key was hidden in a dead tree.")
    key:setActionId(5010)

    if player:addItemEx(key) ~= RETURNVALUE_NOERROR then
        local weight = key:getWeight()
        if player:getFreeCapacity() < weight then
            player:sendCancelMessage(string.format("You found a key weighing %.2f oz. You don't have capacity.", weight / 100))
        else
            player:sendCancelMessage("You found a key, but have no room to take it.")
        end
        return true
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found a mysterious key.")
    player:setStorageValue(storage, 1)
    return true
end
