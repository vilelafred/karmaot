function onUse(cid, item, fromPosition, itemEx, toPosition)
	local inDoor = Position(31925, 32086, 14)
	local outDoor = Position(31925, 32088, 14)
	local posPlayer = getPlayerPosition(cid)

	if posPlayer ~= inDoor and posPlayer ~= outDoor then
		cid:sendCancelMessage("You need to be in front of door.")
		return true
	end

	if posPlayer == inDoor then
		doTeleportThing(cid, outDoor)
		return true
	end

	if posPlayer == outDoor then
		doTeleportThing(cid, inDoor)
		doSendMagicEffect(posPlayer, 11)
		doPlayerSendTextMessage(cid, 22, "You found a secret passage.")
		return true
	end
end