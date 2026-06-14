function onUse(cid, item, fromPosition, itemEx, toPosition)
    if item.itemid == 6222 and (getPlayerStorageValue(cid, 8002) == EMPTY_STORAGE) then
        doPlayerAddOutfitId(cid, 504, 3)
        setPlayerStorageValue(cid, 8002, 1)
        doSendMagicEffect(getCreaturePosition(cid), CONST_ME_HOLYDAMAGE)
        doPlayerSendTextMessage(cid,22,"Parabéns, você recebeu a Outfit!")
        doRemoveItem(item.uid, 1)
    else
        doPlayerSendCancel(cid,"Você já recebeu essa roupa!")
    end
end
