-- /checkspeed [nome] — GM: mostra speed do alvo (ou de si mesmo)

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	param = (param or ""):trim()
	local target = player
	if param ~= "" then
		target = Player(param)
		if not target then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,
				"Player not found or offline. Usage: /checkspeed [nome]")
			return false
		end
	end

	local baseSpeed = target:getBaseSpeed()
	local currentSpeed = target:getSpeed()
	local delta = currentSpeed - baseSpeed

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format(
		"=== %s SPEED ===\nLevel: %d\nBase: %d\nCurrent: %d\nBonus: %+d",
		target:getName(), target:getLevel(), baseSpeed, currentSpeed, delta
	))
	return false
end
