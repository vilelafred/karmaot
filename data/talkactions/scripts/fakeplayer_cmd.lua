dofile("data/lib/fakeplayer/init.lua")

local function splitWords(text)
	local parts = {}
	for word in text:gmatch("%S+") do
		table.insert(parts, word)
	end
	return parts
end

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local parts = splitWords(param:trim())
	local command = (parts[1] or "help"):lower()
	local arg = parts[2]

	if command == "" or command == "help" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat({
			"Comandos FakePlayer:",
			"/fp create [Nome] - cria e spawna bot",
			"/fp summon [id|all] - spawna bot(s)",
			"/fp dismiss [id|all] - remove bot(s) do mapa",
			"/fp purge - remove todos e apaga do banco",
			"/fp list - lista bots",
			"/fp status [id] - status detalhado",
		}, "\n"))
		return false
	end

	if command == "create" then
		local name = arg or FakePlayerDb.nextDefaultName()
		local ok, msg = FakePlayer.create(name, player:getPosition())
		player:sendTextMessage(ok and MESSAGE_STATUS_CONSOLE_BLUE or MESSAGE_STATUS_CONSOLE_RED, msg)
		return false
	end

	if command == "summon" or command == "spawn" then
		local ok, msg
		if not arg or arg == "all" then
			ok, msg = FakePlayer.summonAll(player:getPosition())
		else
			ok, msg = FakePlayer.summon(tonumber(arg), player:getPosition())
		end
		player:sendTextMessage(ok and MESSAGE_STATUS_CONSOLE_BLUE or MESSAGE_STATUS_CONSOLE_RED, msg)
		return false
	end

	if command == "dismiss" or command == "remove" then
		local ok, msg = FakePlayer.dismiss(arg or "all")
		player:sendTextMessage(ok and MESSAGE_STATUS_CONSOLE_BLUE or MESSAGE_STATUS_CONSOLE_RED, msg)
		return false
	end

	if command == "purge" or command == "clear" then
		local ok, msg = FakePlayer.purge()
		player:sendTextMessage(ok and MESSAGE_STATUS_CONSOLE_BLUE or MESSAGE_STATUS_CONSOLE_RED, msg)
		return false
	end

	if command == "list" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, FakePlayer.list())
		return false
	end

	if command == "status" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, FakePlayer.status(arg and tonumber(arg) or nil))
		return false
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Comando invalido. Use /fp help")
	return false
end
