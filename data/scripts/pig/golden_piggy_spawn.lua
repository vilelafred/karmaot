-- ========================================
-- GOLDEN PIGGY RUSH EVENT - SPAWN SYSTEM
-- ========================================

local config = {
	bossName = "Golden Piggy",
	piggyCount = 75,  -- Number of piggies to spawn
	eventDuration = 10 * 60,  -- 10 minutes in seconds
	storageEventActive = 55601,  -- Global storage to track if event is active
	storageKillCount = 55600,    -- Storage for kill counter
	
	-- Thais city boundaries
	thaisMinX = 32331,
	thaisMaxX = 32428,
	thaisMinY = 32182,
	thaisMaxY = 32266,
	thaisZ = 7,
	thaisCenterPos = Position(32380, 32224, 7),  -- Center position for getSpectators
	
	-- Spawn positions (generated dynamically to avoid PZ)
	spawnPositions = {
		-- Exemplo de posições (serão geradas dinamicamente)
		Position(32369, 32241, 7),
		Position(32370, 32241, 7),
		Position(32371, 32241, 7),
		Position(32369, 32240, 7),
		Position(32370, 32240, 7),
		Position(32371, 32240, 7),
		Position(32369, 32242, 7),
		Position(32370, 32242, 7),
		Position(32371, 32242, 7),
		Position(32368, 32241, 7),
		Position(32372, 32241, 7),
		Position(32368, 32240, 7),
		Position(32372, 32240, 7),
		Position(32368, 32242, 7),
		Position(32372, 32242, 7),
		
		-- Add more positions as needed (at least piggyCount positions recommended)
		Position(32367, 32241, 7),
		Position(32373, 32241, 7),
		Position(32367, 32240, 7),
		Position(32373, 32240, 7),
		Position(32367, 32242, 7),
		Position(32373, 32242, 7),
		Position(32369, 32239, 7),
		Position(32370, 32239, 7),
		Position(32371, 32239, 7),
		Position(32369, 32243, 7),
		Position(32370, 32243, 7),
		Position(32371, 32243, 7),
		Position(32368, 32239, 7),
		Position(32372, 32239, 7),
		Position(32368, 32243, 7),
		Position(32372, 32243, 7),
		Position(32367, 32239, 7),
		Position(32373, 32239, 7),
		Position(32367, 32243, 7),
		Position(32373, 32243, 7),
		Position(32366, 32241, 7),
		Position(32374, 32241, 7),
		Position(32366, 32240, 7),
		Position(32374, 32240, 7),
		Position(32366, 32242, 7),
		Position(32374, 32242, 7),
		Position(32366, 32239, 7),
		Position(32374, 32239, 7),
		Position(32366, 32243, 7),
		Position(32374, 32243, 7),
		Position(32369, 32238, 7),
		Position(32370, 32238, 7),
		Position(32371, 32238, 7),
		Position(32369, 32244, 7),
		Position(32370, 32244, 7),
		Position(32371, 32244, 7),
		Position(32365, 32241, 7),
		Position(32375, 32241, 7),
		Position(32365, 32240, 7),
		Position(32375, 32240, 7),
		Position(32365, 32242, 7),
		Position(32375, 32242, 7),
		Position(32365, 32239, 7),
		Position(32375, 32239, 7),
		Position(32365, 32243, 7),
		Position(32375, 32243, 7),
		Position(32365, 32238, 7),
		Position(32375, 32238, 7),
		Position(32365, 32244, 7),
		Position(32375, 32244, 7),
		Position(32369, 32237, 7),
		Position(32370, 32237, 7),
		Position(32371, 32237, 7),
		Position(32369, 32245, 7),
		Position(32370, 32245, 7),
		Position(32371, 32245, 7),
	}
}

-- ========== HELPER: Check if event is active ==========
local function isEventActive()
	return Game.getStorageValue(config.storageEventActive) == 1
end

-- ========== HELPER: Set event status ==========
local function setEventStatus(active)
	Game.setStorageValue(config.storageEventActive, active and 1 or 0)
end

-- ========== HELPER: Check if position is PZ ==========
local function isProtectionZone(position)
	local tile = Tile(position)
	if not tile then
		return true -- Se não tem tile, considera como inválido
	end
	return tile:hasFlag(TILESTATE_PROTECTIONZONE)
end

-- ========== HELPER: Get random valid spawn position in Thais ==========
local function getRandomThaisPosition()
	local maxAttempts = 100
	for i = 1, maxAttempts do
		local pos = Position(
			math.random(config.thaisMinX, config.thaisMaxX),
			math.random(config.thaisMinY, config.thaisMaxY),
			config.thaisZ
		)
		
		local tile = Tile(pos)
		if tile then
			-- Verifica se é walkable e NÃO é PZ
			if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and 
			   not tile:hasFlag(TILESTATE_BLOCKSOLID) and
			   tile:getGround() then
				return pos
			end
		end
	end
	
	-- Fallback: retorna posição default se não achar válida
	return Position(32369, 32241, 7)
end

-- ========== HELPER: Remove all piggies ==========
local function removeAllPiggies()
	local removed = 0
	-- Use getSpectators centered on Thais
	local spectators = Game.getSpectators(config.thaisCenterPos, false, false, 50, 50, 50, 50)
	for _, spectator in ipairs(spectators) do
		if spectator:isMonster() and spectator:getName():lower() == config.bossName:lower() then
			spectator:remove()
			removed = removed + 1
		end
	end
	return removed
end

-- ========== START EVENT ==========
function startGoldenPiggyEvent()
	if isEventActive() then
		return false, "Golden Piggy Rush is already active!"
	end

	-- Mark event as active
	setEventStatus(true)

	-- Reset all player kill counters
	for _, player in ipairs(Game.getPlayers()) do
		player:setStorageValue(config.storageKillCount, 0)
	end

	-- Spawn piggies (random positions in Thais, avoiding PZ)
	local spawned = 0
	
	for i = 1, config.piggyCount do
		local pos = getRandomThaisPosition()
		local piggy = Game.createMonster(config.bossName, pos, false, true)
		if piggy then
			-- Events are now auto-registered via XML <script> tag
			spawned = spawned + 1
		end
	end

	-- Broadcast
	Game.broadcastMessage("GOLDEN PIGGY RUSH", MESSAGE_EVENT_ADVANCE)
	Game.broadcastMessage("The Golden Piggies have escaped from the Karma Vault!", MESSAGE_EVENT_ADVANCE)
	Game.broadcastMessage("Only FIST FIGHTING can stop them!", MESSAGE_EVENT_ADVANCE)
	Game.broadcastMessage("The event lasts 10 minutes!", MESSAGE_EVENT_ADVANCE)
	Game.broadcastMessage(string.format("%d piggies spawned - GO!", spawned), MESSAGE_EVENT_ADVANCE)

	-- Schedule end event
	addEvent(endGoldenPiggyEvent, config.eventDuration * 1000)

	print(string.format("[GOLDEN PIGGY RUSH] Event started! Spawned %d piggies.", spawned))
	return true, string.format("Event started! %d piggies spawned.", spawned)
end

-- ========== END EVENT ==========
function endGoldenPiggyEvent()
	if not isEventActive() then
		return false, "No event is currently active."
	end

	-- Remove remaining piggies
	local removed = removeAllPiggies()

	-- Mark event as inactive
	setEventStatus(false)

	-- Find top 3 hunters
	local rankings = {}
	for _, player in ipairs(Game.getPlayers()) do
		local kills = player:getStorageValue(config.storageKillCount)
		if kills > 0 then
			table.insert(rankings, {name = player:getName(), kills = kills})
		end
	end

	-- Sort by kills (descending)
	table.sort(rankings, function(a, b) return a.kills > b.kills end)

	-- Broadcast results
	Game.broadcastMessage("GOLDEN PIGGY RUSH - EVENT ENDED!", MESSAGE_EVENT_ADVANCE)
	
	if #rankings > 0 then
		Game.broadcastMessage("TOP PIGGY HUNTERS:", MESSAGE_EVENT_ADVANCE)
		for i = 1, math.min(3, #rankings) do
			local medal = {"GOLD", "SILVER", "BRONZE"}
			Game.broadcastMessage(
				string.format("%s: %s - %d piggies caught", 
					medal[i], rankings[i].name, rankings[i].kills),
				MESSAGE_EVENT_ADVANCE
			)
		end
	else
		Game.broadcastMessage("No piggies were caught!", MESSAGE_EVENT_ADVANCE)
	end

	print(string.format("[GOLDEN PIGGY RUSH] Event ended. Removed %d remaining piggies.", removed))
	return true, "Event ended!"
end

-- ========== COMMAND: /piggy ==========
local piggyCommand = TalkAction("/piggy")

function piggyCommand.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	local action = param:trim():lower()

	if action == "start" then
		local success, message = startGoldenPiggyEvent()
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[GOLDEN PIGGY] " .. message)
	elseif action == "stop" or action == "end" then
		local success, message = endGoldenPiggyEvent()
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[GOLDEN PIGGY] " .. message)
	elseif action == "status" then
		if isEventActive() then
			local piggyCount = 0
			local spectators = Game.getSpectators(config.thaisCenterPos, false, false, 50, 50, 50, 50)
			for _, spectator in ipairs(spectators) do
				if spectator:isMonster() and spectator:getName():lower() == config.bossName:lower() then
					piggyCount = piggyCount + 1
				end
			end
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
				string.format("[GOLDEN PIGGY] Event is ACTIVE. %d piggies remaining.", piggyCount))
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[GOLDEN PIGGY] No event is active.")
		end
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[GOLDEN PIGGY] Usage:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/piggy start - Start the event")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/piggy stop - End the event")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/piggy status - Check event status")
	end

	return false
end

piggyCommand:separator(" ")
piggyCommand:register()

-- ========== PLAYER COMMAND: !piggy ==========
local piggyPlayerCommand = TalkAction("!piggy")

function piggyPlayerCommand.onSay(player, words, param)
	local kills = player:getStorageValue(config.storageKillCount)
	if kills < 0 then
		kills = 0
	end

	if isEventActive() then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "========== GOLDEN PIGGY RUSH ==========")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Status: EVENT ACTIVE")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Your kills: %d piggies", kills))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Remember: Only FIST FIGHTING works!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "=======================================")
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Golden Piggy Rush is not active.")
		if kills > 0 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
				string.format("Your last event record: %d piggies", kills))
		end
	end

	return false
end

piggyPlayerCommand:register()

