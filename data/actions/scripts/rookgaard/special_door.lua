function onUse(cid, item, fromPosition, itemEx, toPosition)
	local inDoor = Position(32098, 32137, 7)
	local outDoor = Position(32098, 32139, 7)
	local posPlayer = getPlayerPosition(cid)
	local tile = Tile(inDoor)
	local thing = tile:getTopVisibleThing()
	local thingPos = thing:isPlayer()
	
	if posPlayer == outDoor and thingPos == true then
		cid:sendCancelMessage("Only one player is permitted in room.")
		return true
	end

	if posPlayer ~= inDoor and posPlayer ~= outDoor then
		cid:sendCancelMessage("You need to be in front of door.")
		return true
	end

	if posPlayer == inDoor then
		doTeleportThing(cid, outDoor)
		doSendMagicEffect(posPlayer, 11)
		return true
	end

	if posPlayer == outDoor then
		doTeleportThing(cid, inDoor)
		doSendMagicEffect(posPlayer, 11)
		return true
	end
end