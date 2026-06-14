function onStepIn(cid, item, pos)
	BOOK_ID = 6066
	ACTION_ID = 45555 -- Actionid of the tile that teleport you if you have the Secret Ankh
	if (item.actionid == ACTION_ID) then
		if (getPlayerItemCount(cid, BOOK_ID) ~= 1) then
			doTeleportThing(cid, {x=32664, y=32141, z=12})
			doSendMagicEffect(getPlayerPosition(cid),10)
			doPlayerSendTextMessage(cid,22,"you are not worthy!")
		else
			doTeleportThing(cid, {x=32617, y=32104, z=12})
			doSendMagicEffect(getPlayerPosition(cid),10)
			doPlayerSendTextMessage(cid,22,"you found a secret area")
		end
	end
	return true
end