-- ========================================
-- KARMA AMULET EQUIP/DEEQUIP EFFECTS
-- Visual feedback when equipping/unequipping
-- ========================================

local karmaAmuletIds = {6161, 6550, 6525}

-- Helper function to check if item is Karma Amulet
local function isKarmaAmulet(item)
	if not item then return false end
	local itemId = item:getId()
	for _, id in ipairs(karmaAmuletIds) do
		if itemId == id then
			return true
		end
	end
	return false
end

-- Helper function to get active stones from item
local function getItemStones(item)
	if not item then return {} end
	local data = item:getCustomAttribute("karma_stones")
	if not data or data == "" then return {} end
	local success, decoded = pcall(json.decode, data)
	return (success and type(decoded) == "table") and decoded or {}
end

-- EQUIP EVENT
local equipEvent = MoveEvent()

function equipEvent.onEquip(player, item, slot, isCheck)
	if isCheck then
		return true
	end
	
	if not isKarmaAmulet(item) then
		return true
	end
	
	-- Visual effect
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	
	-- Check active stones E LIMPAR stones expiradas
	local stones = getItemStones(item)
	local activeStones = {}
	local needsCleanup = false
	
	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 60 then
			table.insert(activeStones, stone.element)
		elseif stone.remaining and stone.remaining > 0 then
			-- Tem stone com < 60s, precisa limpar
			needsCleanup = true
		end
	end
	
	-- FORÇAR limpeza da descrição ao equipar (remove stones antigas)
	if needsCleanup or #activeStones == 0 then
		local baseDesc = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
		baseDesc = baseDesc:gsub("\n%[.-%]", "")
		baseDesc = baseDesc:gsub("\n• .*", "")
		
		local stoneText = ""
		for _, stone in pairs(stones) do
			if stone.remaining and stone.remaining > 60 then
				local element = stone.element or "unknown"
				local def = stone.def or 0
				local hours = math.floor(stone.remaining / 3600)
				local mins = math.floor((stone.remaining % 3600) / 60)
				local timeLeft = string.format("%dh%02dm", hours, mins)
				stoneText = stoneText .. string.format("\n[%s: +%d%% - %s]", 
					element:sub(1,1):upper() .. element:sub(2), def, timeLeft)
			end
		end
		
		if stoneText ~= "" then
			item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc .. stoneText)
		else
			item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc)
		end
	end
	
	-- Message
	if #activeStones > 0 then
		local elementsList = table.concat(activeStones, ", ")
		player:sendTextMessage(MESSAGE_INFO_DESCR, 
			string.format("Karma Amulet activated! Active protections: %s", elementsList))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			"[Karma Stones] Time consumption started! Use !karma to check status.")
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Karma Amulet equipped!")
		-- Mensagem removida para não spammar quando não tem stones ativas
	end
	
	return true
end

for _, itemId in ipairs(karmaAmuletIds) do
	equipEvent:id(itemId)
end
equipEvent:slot("necklace")
equipEvent:register()

-- DEEQUIP EVENT
local deequipEvent = MoveEvent()

function deequipEvent.onDeEquip(player, item, slot, isCheck)
	if isCheck then
		return true
	end
	
	if not isKarmaAmulet(item) then
		return true
	end
	
	-- Visual effect (different from equip)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	
	-- Check active stones
	local stones = getItemStones(item)
	local hasActiveStones = false
	
	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 0 then
			hasActiveStones = true
			break
		end
	end
	
	-- Message
	if hasActiveStones then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Karma Amulet deactivated!")
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
			"[Karma Stones] Time consumption paused. Equip the amulet again to resume.")
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Karma Amulet removed.")
	end
	
	return true
end

for _, itemId in ipairs(karmaAmuletIds) do
	deequipEvent:id(itemId)
end
deequipEvent:slot("necklace")
deequipEvent:register()

