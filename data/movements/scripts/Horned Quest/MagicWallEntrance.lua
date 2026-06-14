function onStepIn(cid, item, pos)
	BOOK_ID = 2354
	ACTION_ID = 52001 -- Actionid of the tile that teleport you if you have the Holy Tible
	if (item.actionid == ACTION_ID) then
		if (getPlayerItemCount(cid, BOOK_ID) ~= 1) then
			doTeleportThing(cid, {x=32805, y=32359, z=10})
			doSendMagicEffect(getPlayerPosition(cid),10)
		else
			doTeleportThing(cid, {x=32983, y=32107, z=10})
			doSendMagicEffect(getPlayerPosition(cid),10)
		end
	end
	return true
end