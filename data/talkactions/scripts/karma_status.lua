-- KarmaOT - !karma Command
-- Shows active Elemental Stones status
-- Author: Gustavo (KarmaOT) - 2025

local function getStoneSlot(player, slotNum)
	local storageKey = (slotNum == 1) and STORAGE.KarmaStones.Slot1 or STORAGE.KarmaStones.Slot2
	local data = player:getStorageValue(storageKey)
	if data == -1 or data == nil or data == "" then
		return nil
	end
	local success, decoded = pcall(json.decode, data)
	if success and type(decoded) == "table" then
		return decoded
	end
	return nil
end

local function formatTime(seconds)
	if seconds <= 0 then return "expired" end
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	return string.format("%dh%02dm", hours, mins)
end

local karmaStatus = TalkAction("!karma")

function karmaStatus.onSay(player, words, param)
	local activeCount = player:getStorageValue(STORAGE.KarmaStones.ActiveCount) or 0
	
	if activeCount == 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Karma Stones] You don't have any active stones.")
		return false
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "========== KARMA STONES ==========")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Active Stones: %d/2", activeCount))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "")

	for slotNum = 1, 2 do
		local stoneData = getStoneSlot(player, slotNum)
		if stoneData and stoneData.remaining and stoneData.remaining > 0 then
			local element = stoneData.element or "unknown"
			local def = stoneData.def or 0
			local timeLeft = formatTime(stoneData.remaining)
			
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
				string.format("• %s Protection: +%d%% (%s remaining)", 
					element:sub(1,1):upper() .. element:sub(2), def, timeLeft))
		end
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Time only counts while Karma Amulet is equipped!")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "==================================")

	return false
end

karmaStatus:separator(" ")
karmaStatus:register()
