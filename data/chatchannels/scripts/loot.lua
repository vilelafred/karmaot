function canJoin(player)
	return player:getClient().version < 772
end

function onSpeak(player, type, message)
	return false
end