function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 2330 and itemEx.actionid == 50015 and itemEx.itemid == 2334) then
		if(getPlayerStorageValue(cid, 244) == 1) then
			setPlayerStorageValue(cid, 244, 2)
			doPlayerAddItem(cid,1993,1)
			doSendMagicEffect(toPosition, CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end