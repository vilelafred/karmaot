function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rewardStorage = 5055
    local requiredItem = 8239     -- Karma Boots +2
    local rewardItem = 8240      -- Karma Boots +3

    -- Verifica se já recebeu
    if getPlayerStorageValue(cid, rewardStorage) >= 1 then
        doPlayerSendCancel(cid, "This chest is empty.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
        return true
    end

    -- Verifica se o player tem a Karma Boots +2
    if getPlayerItemCount(cid, requiredItem) < 1 then
        doPlayerSendCancel(cid, "You need the Karma Boots +2 to receive this upgrade.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        return true
    end

    -- Remove a original e dá a +3
    if doPlayerRemoveItem(cid, requiredItem, 1) then
        if doPlayerAddItem(cid, rewardItem, 1) then
            setPlayerStorageValue(cid, rewardStorage, 1)
            doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your Karma Boots have been successfully upgraded to +3!")
            doSendMagicEffect(getThingPos(cid), CONST_ME_FIREWORK_RED)
        else
            doPlayerSendCancel(cid, "You don't have enough space or capacity.")
            doSendMagicEffect(getThingPos(cid), CONST_ME_BLOCKHIT)
        end
    else
        doPlayerSendCancel(cid, "Failed to remove the Karma Boots +2.")
    end

    return true
end
