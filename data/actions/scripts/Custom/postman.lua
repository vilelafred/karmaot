function onUse(player, item, fromPosition, target, toPosition)
    if player:getStorageValue(STORAGE_POSTMAN_DOOR) ~= 5 then
        player:setStorageValue(STORAGE_POSTMAN_DOOR, 5) -- word djanni'hah
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are allowed to make use of certain mailboxes in dangerous areas and talk with Rashid.")
        item:remove()
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You've already this access.")
        return false
    end
end