function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local questStorage = 9900 -- qualquer valor único para controlar se já pegou

    if player:getStorageValue(questStorage) >= 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
        return true
    end

    -- Item com raridade
    local itemId = 2400 -- Bright Sword como exemplo
    local rewardItem = rollRarity(itemId)

    player:addItemEx(rewardItem)
    player:setStorageValue(questStorage, 1)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found a mysterious item!")

    return true
end
