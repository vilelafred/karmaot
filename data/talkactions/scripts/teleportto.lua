function onSay(player, words, param)
	if(param == '') then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local waypoint = getWaypointPositionByName(param)
	local tile = string.split(param, ",")
	local pos = {x = 0, y = 0, z = 0}

	if(type(waypoint) == 'table' and waypoint.x ~= 0 and waypoint.y ~= 0) then
		pos = waypoint
	elseif(tile) then
		local x, y, z = param:match("(%d+), (%d+), (%d+)")
		local position = Position(tonumber(x), tonumber(y), tonumber(z))
		if position then
			player:teleportTo(position)
		end
	else
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
		return true
	end

	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Destination not reachable.")
		return true
	end

	pos = getClosestFreeTile(player, pos, true, false)
	pos = getFreeTile(randomPos)
	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Cannot perform action.")
		return true
	end

	local tmp = getCreaturePosition(player)
	if(doTeleportThing(player, pos, true) and not isPlayerGhost(player)) then
		doSendMagicEffect(tmp, CONST_ME_POFF)
		doSendMagicEffect(pos, CONST_ME_TELEPORT)
	end

	return true
end
