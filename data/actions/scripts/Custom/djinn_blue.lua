function onUse(player, item, fromPosition, target, toPosition)
    if player:getStorageValue(1020) == 12 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot use this scroll while having access to the Green Djinns.")
        return false
    elseif player:getStorageValue(1030) == -1 then
        player:setStorageValue(1030, 11) -- word djanni'hah
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You may now enter the Blue Djinn fortress.")
        item:remove()
        return true
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already have this access.")
        return false
    end
end