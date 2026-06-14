-- ========================================
-- GOLDEN PIGGY RUSH - TEST SCRIPT
-- ========================================
-- Quick test to verify all mechanics work properly
-- Usage: /piggytest

local config = {
	bossName = "Golden Piggy",
	testPiggyCount = 3,        -- Spawn only 3 piggies for testing
	testDuration = 2 * 60,     -- 2 minutes for quick test
	storageKillCount = 55600,
	storageEventActive = 55601
}

-- ========== HELPER: Remove all piggies ==========
local function removeAllPiggies()
	local removed = 0
	-- Center of Thais: Position(32380, 32224, 7)
	local spectators = Game.getSpectators(Position(32380, 32224, 7), false, false, 50, 50, 50, 50)
	for _, spectator in ipairs(spectators) do
		if spectator:isMonster() and spectator:getName():lower() == config.bossName:lower() then
			spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectator:remove()
			removed = removed + 1
		end
	end
	return removed
end

-- ========== TEST COMMAND ==========
local piggyTest = TalkAction("/piggytest")

function piggyTest.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	local action = param:trim():lower()

	if action == "" or action == "start" then
		-- Check if event is already active
		if Game.getStorageValue(config.storageEventActive) == 1 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Event is already active!")
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Use /piggytest stop or /piggytest reset to clear it")
			return false
		end

		-- Get player position
		local playerPos = player:getPosition()
		
		-- Reset kill counter
		player:setStorageValue(config.storageKillCount, 0)
		
		-- Mark event as active
		Game.setStorageValue(config.storageEventActive, 1)
		
		-- Spawn 3 piggies around player
		local spawned = 0
		local spawnOffsets = {
			{x = 2, y = 0},
			{x = -2, y = 0},
			{x = 0, y = 2}
		}
		
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ========== GOLDEN PIGGY TEST ==========")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Spawning 3 piggies around you...")
		
		for _, offset in ipairs(spawnOffsets) do
			local spawnPos = Position(playerPos.x + offset.x, playerPos.y + offset.y, playerPos.z)
			local piggy = Game.createMonster(config.bossName, spawnPos, false, true)
			if piggy then
				-- Events are now auto-registered via XML <script> tag
				spawned = spawned + 1
				spawnPos:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			string.format("[TEST] %d piggies spawned! Test duration: 2 minutes", spawned))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST]")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] WHAT TO TEST:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 1. Attack with weapon equipped = NO DAMAGE")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 2. Attack with bare hands = DAMAGE")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 3. Solo attack = 50% damage reduction")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 4. 3+ players = 100% damage increase")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 5. Kill piggy = random loot drops")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] 6. Use !piggy to check kill count")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST]")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Use /piggytest stop to end test early")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ==========================================")
		
		-- Schedule auto-end
		addEvent(function()
			if Game.getStorageValue(config.storageEventActive) == 1 then
				-- Remove remaining piggies
				local removed = removeAllPiggies()
				
				-- Mark as inactive
				Game.setStorageValue(config.storageEventActive, 0)
				
				-- Notify all online GMs
				for _, p in ipairs(Game.getPlayers()) do
					if p:getGroup():getAccess() then
						p:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
							string.format("[TEST] Golden Piggy test ended! Removed %d piggies.", removed))
					end
				end
				
				print("[GOLDEN PIGGY TEST] Test ended automatically after 2 minutes.")
			end
		end, config.testDuration * 1000)
		
		print(string.format("[GOLDEN PIGGY TEST] Test started by %s. %d piggies spawned.", 
			player:getName(), spawned))
		
	elseif action == "stop" then
		if Game.getStorageValue(config.storageEventActive) ~= 1 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] No test is active!")
			return false
		end
		
		-- Remove all piggies
		local removed = removeAllPiggies()
		
		-- Mark as inactive
		Game.setStorageValue(config.storageEventActive, 0)
		
		-- Show results
		local kills = player:getStorageValue(config.storageKillCount)
		if kills < 0 then kills = 0 end
		
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ========== TEST RESULTS ==========")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			string.format("[TEST] Piggies killed: %d", kills))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			string.format("[TEST] Piggies removed: %d", removed))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Check corpses for loot drops!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST]")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] DID EVERYTHING WORK?")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Fist fighting requirement?")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Damage mitigation (solo vs group)?")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Random loot in corpses?")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Kill counter working?")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST]")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] If all OK, use /piggy start for full event!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ======================================")
		
		print(string.format("[GOLDEN PIGGY TEST] Test stopped by %s. Results: %d kills, %d removed.", 
			player:getName(), kills, removed))
		
	elseif action == "reset" then
		-- Force reset event status
		Game.setStorageValue(config.storageEventActive, 0)
		player:setStorageValue(config.storageKillCount, 0)
		
		-- Remove any remaining piggies
		local removed = removeAllPiggies()
		
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ========== RESET ==========")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Event status: RESET")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("[TEST] Removed %d piggies", removed))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] You can now start a new test!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ============================")
		
	elseif action == "info" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ========== TEST INFO ==========")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] /piggytest start - Spawn 3 piggies for 2 min test")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] /piggytest stop - End test and show results")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] /piggytest reset - Force reset if stuck")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] /piggytest info - Show this help")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST]")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] WHAT IS TESTED:")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Fist fighting only requirement")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Dynamic damage (solo vs group)")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Random loot system")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Kill counter tracking")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Monster HP randomization")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] - Visual effects")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] ====================================")
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[TEST] Usage: /piggytest [start|stop|reset|info]")
	end

	return false
end

piggyTest:separator(" ")
piggyTest:register()

-- ========== VERIFICATION COMMAND ==========
local piggyVerify = TalkAction("/piggyverify")

function piggyVerify.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] ========== SYSTEM CHECK ==========")
	
	-- Check if monster exists
	local testMonster = Game.createMonster(config.bossName, player:getPosition(), false, false)
	if testMonster then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] Monster 'Golden Piggy': OK")
		testMonster:remove()
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] Monster 'Golden Piggy': FAILED!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] Check if registered in monsters.xml")
	end
	
	-- Check if mechanics script is loaded
	local mechanicsLoaded = false
	for _, event in ipairs({"GoldenPiggyDamage", "GoldenPiggyDeath", "GoldenPiggySpawn"}) do
		-- We can't directly check if CreatureEvent exists, so we note it
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			string.format("[VERIFY] Event '%s': Should be loaded", event))
		mechanicsLoaded = true
	end
	
	-- Check storages
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("[VERIFY] Storage 55600 (kill counter): %d", 
			player:getStorageValue(config.storageKillCount)))
	
	local eventActive = Game.getStorageValue(config.storageEventActive)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("[VERIFY] Storage 55601 (event active): %d", 
			eventActive and eventActive or -1))
	
	-- Check if main event script is available
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY]")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] REQUIRED FILES:")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] - Golden Piggy.xml (monster)")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] - golden_piggy_mechanics.lua")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] - golden_piggy_spawn.lua")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] - golden_piggy_test.lua (this)")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY]")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] If monster OK, run /piggytest start to test!")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[VERIFY] =====================================")

	return false
end

piggyVerify:register()

