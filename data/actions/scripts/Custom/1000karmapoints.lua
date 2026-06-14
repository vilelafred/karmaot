local addpoints = 1000 -- amount of points to add

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isPlayer(player) then
		return false
	end

	-- ===== COLETA DE INFORMAÇÕES =====
	local playerName = player:getName()
	local accountId = getAccountNumberByPlayerName(playerName)
	local playerLevel = player:getLevel()
	local playerIp = player:getIp()
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local position = player:getPosition()

	-- Converter IP numérico para string legível
	local function convertIpToString(ip)
		return string.format("%d.%d.%d.%d",
			bit.rshift(ip, 24),
			bit.band(bit.rshift(ip, 16), 0xFF),
			bit.band(bit.rshift(ip, 8), 0xFF),
			bit.band(ip, 0xFF))
	end

	local ipString = convertIpToString(playerIp)

	-- ===== LOG COMPLETO =====
	local logMessage = string.format(
		"[KARMA TICKET] %s | Player: %s (Account: %s, Level: %d, IP: %s, Pos: %d/%d/%d) used Karma Ticket +%d points",
		timestamp, playerName, accountId, playerLevel, ipString, 
		position.x, position.y, position.z, addpoints
	)

	-- Salvar no console do servidor (DESTACADO)
	print("========================================")
	print(">>> KARMA TICKET USADO <<<")
	print(string.format("Player: %s (Account: %s)", playerName, accountId))
	print(string.format("Level: %d | IP: %s", playerLevel, ipString))
	print(string.format("Position: %d, %d, %d", position.x, position.y, position.z))
	print(string.format("Points Added: +%d", addpoints))
	print(string.format("Date/Time: %s", timestamp))
	print("========================================")

	-- Salvar em arquivo de log
	local file = io.open("data/logs/karma_ticket_usage.log", "a")
	if file then
		file:write(logMessage .. "\n")
		file:close()
	end

	-- Remover APENAS 1 item (não toda a stack)
	if item:remove(1) then
		db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + "..addpoints.." WHERE `id` = '" ..accountId.. "';")
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, ""..addpoints.." premium points have been added to your account.")
		player:sendTextMessage(MESSAGE_INFO_DESCR, "1000 Premium Points added to your account!")
		return true
	end

	return false
end

