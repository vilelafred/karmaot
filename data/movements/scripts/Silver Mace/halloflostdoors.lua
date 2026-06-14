function onStepIn(cid, item, pos)
	BOOK_ID = 2327
	ACTION_ID = 22001 -- Actionid of the tile that teleport you if you have the Holy Tible
	if (item.actionid == ACTION_ID) then
		if (getPlayerItemCount(cid, BOOK_ID) ~= 1) then
			doTeleportThing(cid, {x=32668, y=32150, z=10})
		else
			doTeleportThing(cid, {x=32669, y=32149, z=10})
			doSendMagicEffect(getPlayerPosition(cid),10)
		end
	end
	return true
end