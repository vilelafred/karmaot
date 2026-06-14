function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rewardStorage = 5002
    local requiredItem = 5804    -- Original Quiver
    local rewardItem = 5803     -- karma ring +2

    -- Check if player already received the upgrade
    if getPlayerStorageValue(cid, rewardStorage) >= 1 then
        doPlayerSendCancel(cid, "This chest is empty.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
        return true
    end

    -- Check if player has the original quiver
    if getPlayerItemCount(cid, requiredItem) < 1 then
        doPlayerSendCancel(cid, "You need the original Karma Ring to receive this upgrade.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        return true
    end

    -- Remove original and give upgraded version
    if doPlayerRemoveItem(cid, requiredItem, 1) then
        if doPlayerAddItem(cid, rewardItem, 1) then
            setPlayerStorageValue(cid, rewardStorage, 1)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your Karma Ring has been successfully upgraded to +2!")
            doSendMagicEffect(getThingPos(cid), CONST_ME_FIREWORK_RED)
        else
            doPlayerSendCancel(cid, "You don't have enough space or capacity.")
            doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        end
    else
        doPlayerSendCancel(cid, "Failed to remove the original Karma Ring.")
    end

    return true
end
