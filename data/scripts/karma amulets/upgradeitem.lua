	-- ========================================
	-- KARMA STONES SYSTEM V3.0
	-- Storage per ITEM (not per player)
	-- Each amulet has its own stones
	-- ========================================

	local config = {
		maxStones = 2,
		maxProtection = 20,
		debugLogs = true, -- Set to false to disable protection logs
		
		stones = {
			[8277] = {element = "physical", def = 10, duration = 4 * 3600, name = "Physical Protection Stone"},
			[8280] = {element = "energy", def = 10, duration = 4 * 3600, name = "Energy Protection Stone"},
			[8276] = {element = "earth", def = 10, duration = 4 * 3600, name = "Earth Protection Stone"},
			[8282] = {element = "fire", def = 10, duration = 4 * 3600, name = "Fire Protection Stone"},
			[8278] = {element = "ice", def = 10, duration = 4 * 3600, name = "Ice Protection Stone"},
			[8283] = {element = "death", def = 10, duration = 4 * 3600, name = "Death Protection Stone"},
			[8279] = {element = "holy", def = 10, duration = 4 * 3600, name = "Holy Protection Stone"}
		},
		
		combatTypes = {
			[COMBAT_PHYSICALDAMAGE] = "physical",
			[COMBAT_ENERGYDAMAGE] = "energy",
			[COMBAT_EARTHDAMAGE] = "earth",
			[COMBAT_FIREDAMAGE] = "fire",
			[COMBAT_ICEDAMAGE] = "ice",
			[COMBAT_HOLYDAMAGE] = "holy",
			[COMBAT_DEATHDAMAGE] = "death"
		}
	}

	-- ========== HELPER FUNCTIONS ==========

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
		local count = 0
		for _, stone in pairs(stones or {}) do
			if stone.remaining and stone.remaining > 0 then
				count = count + 1
				local element = stone.element or "unknown"
				local def = stone.def or 0
				local timeLeft = formatTime(stone.remaining)
				stoneText = stoneText .. string.format("\n[%s: +%d%% - %s]", 
					element:sub(1,1):upper() .. element:sub(2), def, timeLeft)
			end
		end
		
		if stoneText ~= "" then
			item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc .. stoneText)
		end
	end

	-- ========== USE STONE ON AMULET ==========

	local action = Action()

	function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		local stoneConfig = config.stones[item:getId()]
		if not stoneConfig then
			return false
		end

		-- Must target a Karma Amulet
		if not target or not target:isItem() then
			player:sendCancelMessage("Use this stone on a Karma Amulet.")
			return true
		end

		if not isKarmaAmulet(target) then
			player:sendCancelMessage("This stone can only be used on Karma Amulets.")
			return true
		end

		-- Get current stones on the item
		local stones = getItemStones(target)
		
		-- Check max stones
		local activeCount = 0
		for _, stone in pairs(stones) do
			if stone.remaining and stone.remaining > 0 then
				activeCount = activeCount + 1
			end
		end
		
		if activeCount >= config.maxStones then
			player:sendCancelMessage("This amulet already has " .. config.maxStones .. " active stones.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end

		-- Check if element already active
		for _, stone in pairs(stones) do
			if stone.element == stoneConfig.element and stone.remaining > 0 then
				player:sendCancelMessage("This amulet already has " .. stoneConfig.element .. " protection active.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return true
			end
		end

		-- Add new stone
		local newStone = {
			element = stoneConfig.element,
			def = stoneConfig.def,
			duration = stoneConfig.duration,
			remaining = stoneConfig.duration,
			activated = os.time()
		}
		
		-- Find empty slot (1 or 2)
		if not stones[1] or stones[1].remaining <= 0 then
			stones[1] = newStone
		elseif not stones[2] or stones[2].remaining <= 0 then
			stones[2] = newStone
		end

		-- Save to item
		setItemStones(target, stones)
		item:remove(1)

		-- Feedback
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:sendTextMessage(MESSAGE_INFO_DESCR, 
			string.format("You activated %s! (+%d%% %s protection for %dh of active use)", 
				stoneConfig.name, stoneConfig.def, stoneConfig.element, stoneConfig.duration / 3600))
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
			"[Karma Stones] Time only counts while this amulet is equipped!")

		return true
	end

for itemId in pairs(config.stones) do
	action:id(itemId)
end
action:register()

-- ========== CLEANSING STONE (REMOVES ALL PROTECTIONS) ==========

local cleansingStone = Action()

function cleansingStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Must target a Karma Amulet
	if not target or not target:isItem() then
		player:sendCancelMessage("Use this stone on a Karma Amulet.")
		return true
	end

	if not isKarmaAmulet(target) then
		player:sendCancelMessage("This stone can only be used on Karma Amulets.")
		return true
	end

	-- Get current stones
	local stones = getItemStones(target)
	local hadStones = false
	
	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 0 then
			hadStones = true
			break
		end
	end
	
	if not hadStones then
		player:sendCancelMessage("This amulet has no active stones to remove.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	-- Clear all stones
	setItemStones(target, {})
	
	-- Reset description to base
	local baseDesc = "Fast Regen (10hp/s 10mp/s)"
	local itemId = target:getId()
	if itemId == 6550 or itemId == 6525 then
		baseDesc = "Fast Regen (15hp/s 15mp/s)"
	end
	target:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc)
	
	-- Remove the cleansing stone
	item:remove(1)
	
	-- Feedback
	player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	player:getPosition():sendMagicEffect(CONST_ME_PURPLEENERGY)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "All Protection Stones removed from this amulet!")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		"[Karma Stones] The amulet has been cleansed.")

	return true
end

cleansingStone:id(8281)
cleansingStone:register()

	-- ========== DAMAGE REDUCTION (ONLY STONES) ==========
	-- Base protection (absorbPercentAll) is now handled by attributes.lua
	-- This system ONLY applies Karma Stone protection

	local function getStoneProtection(player, element)
		local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
		if not isKarmaAmulet(amulet) then
			return 0 -- no amulet equipped
		end
		
		-- Get stone protection only
		local stones = getItemStones(amulet)
		local stoneProtection = 0
		
		for _, stone in pairs(stones) do
			if stone.element == element and stone.remaining and stone.remaining > 0 then
				stoneProtection = stoneProtection + (stone.def or 0)
			end
		end
		
		stoneProtection = math.min(stoneProtection, config.maxProtection)
		
		return stoneProtection
	end

	local function damageCalculator(player, primaryDamage, primaryType, secondaryDamage, secondaryType)
		local stoneProtPrimary = 0
		local stoneProtSecondary = 0
		
		if config.combatTypes[primaryType] then
			stoneProtPrimary = getStoneProtection(player, config.combatTypes[primaryType])
		end
		if config.combatTypes[secondaryType] then
			stoneProtSecondary = getStoneProtection(player, config.combatTypes[secondaryType])
		end

		-- Apply STONE protection only (base protection is handled by attributes.lua)
		if stoneProtPrimary > 0 then
			local reduced = primaryDamage * (stoneProtPrimary / 100)
			primaryDamage = primaryDamage - reduced
			
			if config.debugLogs and reduced > 0 then
				player:sendTextMessage(MESSAGE_STATUS_DEFAULT, 
					string.format("[Karma] Blocked %d %s damage (-%d%% stone)", 
						math.floor(reduced), config.combatTypes[primaryType], stoneProtPrimary))
			end
		end
		
		-- Same for secondary damage
		if stoneProtSecondary > 0 then
			local reduced = secondaryDamage * (stoneProtSecondary / 100)
			secondaryDamage = secondaryDamage - reduced
			
			if config.debugLogs and reduced > 0 then
				player:sendTextMessage(MESSAGE_STATUS_DEFAULT, 
					string.format("[Karma] Blocked %d %s damage (-%d%% stone)", 
						math.floor(reduced), config.combatTypes[secondaryType], stoneProtSecondary))
			end
		end
		
		return primaryDamage, secondaryDamage
	end

	-- Register damage reduction
	local healthChange = CreatureEvent("karmaStones_healthChange")
	function healthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		primaryDamage, secondaryDamage = damageCalculator(creature, primaryDamage, primaryType, secondaryDamage, secondaryType)
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	healthChange:register()

	local manaChange = CreatureEvent("karmaStones_manaChange")
	function manaChange.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		primaryDamage, secondaryDamage = damageCalculator(creature, primaryDamage, primaryType, secondaryDamage, secondaryType)
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	manaChange:register()

	local creatureevent = CreatureEvent("karmaStones_login")
	function creatureevent.onLogin(player)
		player:registerEvent("karmaStones_healthChange")
		player:registerEvent("karmaStones_manaChange")
		return true
	end
	creatureevent:register()


