-- ========================================
-- KARMA STONES RUNTIME V3.0
-- Consumes time from equipped amulet
-- ========================================

local CHECK_INTERVAL = 60 -- Check every 60 seconds

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

local function setItemStones(item, stones)
	if not item then return end
	item:setCustomAttribute("karma_stones", json.encode(stones))
	updateItemDescription(item, stones)
end

local function formatTime(seconds)
	if seconds <= 0 then return "expired" end
	local hours = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	return string.format("%dh%02dm", hours, mins)
end

function updateItemDescription(item, stones)
	if not item then return end
	
	local baseDesc = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
	-- Remove old stones info (both formats: • and [)
	baseDesc = baseDesc:gsub("\n%[.-%]", "")  -- Remove [Fire: +10% - 4h00m] format
	baseDesc = baseDesc:gsub("\n• .*", "")     -- Remove • format (legacy)
	
	local stoneText = ""
	local hasActiveStones = false
	
	for _, stone in pairs(stones or {}) do
		-- SOMENTE mostrar stones com tempo > 60 segundos (mais de 1 minuto)
		-- Isso evita mostrar "0h01m" que confunde os players
		if stone.remaining and stone.remaining > 60 then
			hasActiveStones = true
			local element = stone.element or "unknown"
			local def = stone.def or 0
			local timeLeft = formatTime(stone.remaining)
			stoneText = stoneText .. string.format("\n[%s: +%d%% - %s]", 
				element:sub(1,1):upper() .. element:sub(2), def, timeLeft)
		end
	end
	
	-- Só adiciona as stones se tiver alguma ativa (> 60 segundos)
	if hasActiveStones and stoneText ~= "" then
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc .. stoneText)
	else
		-- Remove tudo se não tem nenhuma stone ativa
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc)
	end
end

local function consumeStoneTime(player)
	-- Check if Karma Amulet is equipped (SOMENTE equipado conta tempo)
	-- Slot 2 = necklace/amulet slot
	local amulet = player:getSlotItem(2)
	if not isKarmaAmulet(amulet) then
		return
	end

	-- Get stones from the equipped amulet
	local stones = getItemStones(amulet)
	local hasActiveStones = false
	local expiredStones = {}
	local hasChanges = false

	-- Consume time from each active stone
	for slotNum, stoneData in pairs(stones) do
		if stoneData and stoneData.remaining then
			-- Só descontar se ainda tem tempo > 0
			if stoneData.remaining > 0 then
				hasActiveStones = true
				stoneData.remaining = stoneData.remaining - CHECK_INTERVAL
				hasChanges = true
				
				-- Check if expired (chegou a zero ou negativo)
				if stoneData.remaining <= 0 then
					stoneData.remaining = 0
					table.insert(expiredStones, stoneData.element)
				end
			end
		end
	end

	-- Save updated stones E LIMPAR descrição (SEMPRE atualizar, mesmo se não mudou)
	-- Isso garante que stones expiradas antigas sejam removidas da descrição
	setItemStones(amulet, stones)

	-- Notify about expired stones
	for _, element in ipairs(expiredStones) do
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			string.format("[Karma Stones] Your %s protection has expired!", element))
	end
end

local globalEvent = GlobalEvent("karmaStones_runtime")
function globalEvent.onThink(interval)
	for _, player in ipairs(Game.getPlayers()) do
		consumeStoneTime(player)
	end
	return true
end
globalEvent:interval(CHECK_INTERVAL * 1000)
globalEvent:register()

