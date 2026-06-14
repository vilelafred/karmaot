function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rewardStorage = 5001
    local requiredItem = 2640     -- Karma Boots original
    local rewardItem = 8239       -- Karma Boots +2

    -- Verifica se já recebeu
    if getPlayerStorageValue(cid, rewardStorage) >= 1 then
        doPlayerSendCancel(cid, "This chest is empty.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
        return true
    end

    -- Verifica se o player tem a Karma Boots original
    if getPlayerItemCount(cid, requiredItem) < 1 then
        doPlayerSendCancel(cid, "You need the original Karma Boots to receive this upgrade.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        return true
    end

    -- Remove a original e dá a +2
    if doPlayerRemoveItem(cid, requiredItem, 1) then
        if doPlayerAddItem(cid, rewardItem, 1) then
            setPlayerStorageValue(cid, rewardStorage, 1)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your Karma Boots have been successfully upgraded to +2!")
            doSendMagicEffect(getThingPos(cid), CONST_ME_FIREWORK_RED)
        else
            doPlayerSendCancel(cid, "You don't have enough space or capacity.")
            doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        end
    else
        doPlayerSendCancel(cid, "Failed to remove the original Karma Boots.")
    end

    return true
end
