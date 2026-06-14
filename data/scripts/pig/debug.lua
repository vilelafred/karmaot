-- ========================================
-- GOLDEN PIGGY - SIMPLE TEST
-- ========================================
-- This test just spawns a piggy
-- Kill it and check console logs + loot

local simpleTest = TalkAction("/piggyspawn")

function simpleTest.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return false
	end

	local pos = player:getPosition()
	pos.x = pos.x + 2
	
	local piggy = Game.createMonster("Golden Piggy", pos, false, true)
	
	if piggy then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Golden Piggy spawned! Kill it and check:")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "1. Console logs for [GOLDEN PIGGY]")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "2. Loot drops")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "3. Kill counter (!piggy)")
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Failed to spawn piggy!")
	end
	
	return false
end

simpleTest:separator(" ")
simpleTest:register()

