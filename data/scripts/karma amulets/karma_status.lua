-- ========================================
-- KARMA STONES STATUS V3.0
-- Shows stones from EQUIPPED amulet
-- ========================================

local function isKarmaAmulet(item)
	if not item then return false end
	local id = item:getId()
	return id == 6161 or id == 6550 or id == 6525
end

local function getItemStones(item)
	if not item then return {} end
	local data = item:getCustomAttribute("karma_stones")
	if not data or data == "" then return {} end
	local success, decoded = pcall(json.decode, data)
	return (success and type(decoded) == "table") and decoded or {}
end

local function formatTime(seconds)
	if seconds <= 0 then return "expired" end
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	return string.format("%dh%02dm", hours, mins)
end

local karmaStatus = TalkAction("!karma")

function karmaStatus.onSay(player, words, param)
	-- Check if Karma Amulet is equipped
	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	
	if not isKarmaAmulet(amulet) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Karma Stones] You need to equip a Karma Amulet first!")
		return false
	end

	-- Get stones from equipped amulet
	local stones = getItemStones(amulet)
	local activeCount = 0
	
	-- Count active stones
	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 0 then
			activeCount = activeCount + 1
		end
	end
	
	if activeCount == 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Karma Stones] This amulet has no active stones.")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use a Protection Stone on the amulet to activate it!")
		return false
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "========== KARMA STONES ==========")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Active Stones: %d/2", activeCount))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "")

	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 0 then
			local element = stone.element or "unknown"
			local def = stone.def or 0
			local timeLeft = formatTime(stone.remaining)
			
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
				string.format("[%s Protection: +%d%% - %s remaining]", 
					element:sub(1,1):upper() .. element:sub(2), def, timeLeft))
		end
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Time only counts while THIS amulet is equipped!")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "==================================")

	return false
end

karmaStatus:separator(" ")
karmaStatus:register()


