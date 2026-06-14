function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 2416 and itemEx.actionid == 50018 and itemEx.itemid == 2593) then
		if(getPlayerStorageValue(cid, 228) == 1) then
			setPlayerStorageValue(cid, 228, 2)
			doSendMagicEffect(toPosition, CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end