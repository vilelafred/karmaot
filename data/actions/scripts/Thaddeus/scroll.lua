function onUse(player, item, fromPosition, target, toPosition)
    if player:getStorageValue(STORAGE_THADDEUS_DOOR) ~= 5 then
        player:setStorageValue(STORAGE_THADDEUS_DOOR, 5) -- word djanni'hah
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Now you are allowed to enter in Thaddeu's room.")
        item:remove()
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You've already this access.")
        return false
    end
end