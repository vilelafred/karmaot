function onStepIn(cid, item, pos)
	if getPlayerStorageValue(cid,227) == 1 then
		setPlayerStorageValue(cid,227,5)
		doSendMagicEffect(getPlayerPosition(cid),CONST_ME_MAGIC_GREEN)
	else
		doPlayerSendCancel(cid,"")
	end
	
	return true
end
