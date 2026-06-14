function onStepIn(cid, item, pos)
	BOOK_ID = 1970
	ACTION_ID = 40995 -- Actionid of the tile that teleport you if you have the Holy Tible
	if (item.actionid == ACTION_ID) then
		if (getPlayerItemCount(cid, BOOK_ID) ~= 1) then
			doTeleportThing(cid, {x=33310, y=31592, z=12})
			doSendMagicEffect(getPlayerPosition(cid),10)
		else
			doTeleportThing(cid, {x=33310, y=31592, z=12})
			doSendMagicEffect(getPlayerPosition(cid),10)
		end
	end
	return true
end