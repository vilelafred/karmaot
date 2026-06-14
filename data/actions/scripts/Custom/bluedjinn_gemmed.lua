function onUse(player, item, fromPosition, target, toPosition)
    -- Verifica se o player possui a gemmed lamp (item ID 2344)
    if player:getItemCount(2344) < 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You need a Gemmed Lamp to use this lamp.")
        return false
    end

    -- Verifica se o player já tem acesso aos Green Djinns
    if player:getStorageValue(1020) == 12 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot use this lamp while having access to the Green Djinns.")
        return false

    -- Verifica se o player ainda não tem acesso aos Blue Djinns
    elseif player:getStorageValue(1030) == -1 then
        player:setStorageValue(1030, 11) -- word djanni'hah
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You may now enter the Blue Djinn fortress.")
        return true

    -- Caso ele já tenha o acesso
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already have this access.")
        return false
    end
end
