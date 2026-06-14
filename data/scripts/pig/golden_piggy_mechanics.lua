-- ========================================
-- GOLDEN PIGGY RUSH EVENT - MECHANICS
-- ========================================

local config = {
	bossName = "Golden Piggy",
	maxDefenseReduction = 0.5,  -- 50% reduced damage if 1-2 attackers
	zergedMultiplier = 2.0,      -- 200% damage if 3+ attackers
	storageKillCount = 55600,    -- Storage for kill counter
	
	-- Loot system
	loot = {
		-- Common (60%)
		{minChance = 1, maxChance = 60, items = {
			{id = 2148, countMin = 100, countMax = 100},  -- gold coins
            {id = 2152, countMin = 100, countMax = 100},  -- platinum coins
            {id = 2160, countMin = 1, countMax = 50}  -- crystal coins
            {id = 5937, countMin = 20, countMax = 50}  -- mystic ore		

		}},
		-- Rare (25%)
		{minChance = 61, maxChance = 85, items = {
			{id = 8238, countMin = 1, countMax = 3}  -- Jasmin Coin
		}},
		-- Epic (10%)
		{minChance = 86, maxChance = 95, items = {
			{id = 5838, countMin = 1, countMax = 10},  -- Magic Powder
			{id = 6846, countMin = 1, countMax = 10},  -- Magic Sulphur
			{id = 2523, countMin = 1, countMax = 1}   -- Blessed Shield
		}},
		-- Legendary (5%)
		{minChance = 95, maxChance = 100, items = {
			{id = 6610, countMin = 1, countMax = 1},  -- Ultimate Surprise Bag
			{id = 8238, countMin = 5, countMax = 5}   -- 5 Jasmin Coins
		}}
	}
}

-- ========== HELPER: Get number of attackers ==========
local function getAttackerCount(creature)
	local damageMap = creature:getDamageMap()
	local count = 0
	for pid, _ in pairs(damageMap) do
		local player = Player(pid)
		if player then
			count = count + 1
		end
	end
	return count
end

-- ========== DAMAGE CALCULATION ==========
print("[GOLDEN PIGGY] Registering GoldenPiggyDamage event...")

local piggyDamage = CreatureEvent("GoldenPiggyDamage")
function piggyDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature or creature:getName():lower() ~= config.bossName:lower() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- Must be attacked by a player
	if not attacker or not attacker:isPlayer() then
		return 0, primaryType, 0, secondaryType
	end

	-- ONLY physical melee damage is allowed (no magic, no distance)
	if primaryType ~= COMBAT_PHYSICALDAMAGE or origin ~= ORIGIN_MELEE then
		attacker:sendTextMessage(MESSAGE_STATUS_SMALL, "You can only attack the Golden Piggy with bare hands!")
		attacker:getPosition():sendMagicEffect(CONST_ME_POFF)
		return 0, primaryType, 0, secondaryType
	end

	-- Check if player has anything equipped in hands
	local leftItem = attacker:getSlotItem(CONST_SLOT_LEFT)
	local rightItem = attacker:getSlotItem(CONST_SLOT_RIGHT)
	
	-- If any weapon/shield equipped, block damage
	if leftItem or rightItem then
		attacker:sendTextMessage(MESSAGE_STATUS_SMALL, "You can only attack the Golden Piggy with bare hands!")
		attacker:getPosition():sendMagicEffect(CONST_ME_POFF)
		return 0, primaryType, 0, secondaryType
	end

	-- Calculate damage mitigation based on number of attackers
	local attackerCount = getAttackerCount(creature)
	local damageMultiplier = 1.0
	
	if attackerCount <= 2 then
		-- Few attackers: reduce damage by 50%
		damageMultiplier = config.maxDefenseReduction
		if attackerCount == 1 then
			attacker:sendTextMessage(MESSAGE_STATUS_SMALL, "The piggy is tough! Get help!")
		end
	elseif attackerCount >= 3 then
		-- Zerg: double damage (piggy panics)
		damageMultiplier = config.zergedMultiplier
		creature:say("HELP! TOO MANY!", TALKTYPE_MONSTER_SAY)
	end

	primaryDamage = math.floor(primaryDamage * damageMultiplier)
	secondaryDamage = math.floor(secondaryDamage * damageMultiplier)

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

piggyDamage:register()
print("[GOLDEN PIGGY] GoldenPiggyDamage registered!")

-- ========== LOOT SYSTEM ==========
print("[GOLDEN PIGGY] Registering GoldenPiggyDeath event...")

-- Function to add loot (called after delay)
local function addPiggyLoot(creaturePos, itemId, itemCount, killerName)
	print(string.format("[GOLDEN PIGGY] addPiggyLoot called: pos(%d,%d,%d), item %d x%d", 
		creaturePos.x, creaturePos.y, creaturePos.z, itemId, itemCount))
	
	-- Find corpse at creature position
	local tile = Tile(creaturePos)
	if not tile then
		print("[GOLDEN PIGGY ERROR] Tile not found")
		return
	end
	
	local corpseItem = nil
	for i = tile:getThingCount() - 1, 0, -1 do
		local thing = tile:getThing(i)
		if thing and thing:isItem() and thing:isContainer() then
			local itemType = ItemType(thing:getId())
			if itemType:isCorpse() then
				corpseItem = thing
				print(string.format("[GOLDEN PIGGY] Found corpse: ID %d", thing:getId()))
				break
			end
		end
	end
	
	if corpseItem then
		-- Convert gold coins to platinum/crystal if needed
		if itemId == 2148 then -- gold coin
			local crystalCoins = math.floor(itemCount / 10000)
			local platinumCoins = math.floor((itemCount % 10000) / 100)
			local goldCoins = itemCount % 100
			
			print(string.format("[GOLDEN PIGGY] Converting: %d gold -> %d crystal, %d platinum, %d gold", 
				itemCount, crystalCoins, platinumCoins, goldCoins))
			
			if crystalCoins > 0 then
				corpseItem:addItem(2160, crystalCoins) -- crystal coin
			end
			if platinumCoins > 0 then
				corpseItem:addItem(2152, platinumCoins) -- platinum coin
			end
			if goldCoins > 0 then
				corpseItem:addItem(2148, goldCoins) -- gold coin
			end
		else
			-- For other items, add in stacks of 100
			local remaining = itemCount
			while remaining > 0 do
				local stackSize = math.min(100, remaining)
				corpseItem:addItem(itemId, stackSize)
				remaining = remaining - stackSize
			end
		end
		
		-- Visual effect
		creaturePos:sendMagicEffect(CONST_ME_FIREATTACK)
		creaturePos:sendMagicEffect(CONST_ME_YELLOWENERGY)
		
		print(string.format("[GOLDEN PIGGY] SUCCESS! Loot added: %d x%d", itemId, itemCount))
		
		-- Send message to killer
		if killerName and killerName ~= "" then
			local killer = Player(killerName)
			if killer then
				local itemName = ItemType(itemId):getName()
				killer:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
					string.format("You got %d x %s from Golden Piggy!", itemCount, itemName))
			end
		end
	else
		print("[GOLDEN PIGGY ERROR] Corpse not found on tile")
	end
end

local piggyDeath = CreatureEvent("GoldenPiggyDeath")
function piggyDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if not creature or creature:getName():lower() ~= config.bossName:lower() then
		return true
	end

	print(string.format("[GOLDEN PIGGY] onDeath triggered for %s", creature:getName()))

	-- Determine loot tier
	local roll = math.random(1, 100)
	print(string.format("[GOLDEN PIGGY] Loot roll: %d", roll))
	local selectedTier = nil
	
	for _, tier in ipairs(config.loot) do
		if roll >= tier.minChance and roll <= tier.maxChance then
			selectedTier = tier
			print(string.format("[GOLDEN PIGGY] Selected tier: %d-%d", tier.minChance, tier.maxChance))
			break
		end
	end

	if not selectedTier or #selectedTier.items == 0 then
		print("[GOLDEN PIGGY ERROR] No tier selected or empty items")
		return true
	end

	-- Select random item from tier
	local selectedItem = selectedTier.items[math.random(1, #selectedTier.items)]
	local itemCount = math.random(selectedItem.countMin, selectedItem.countMax)
	print(string.format("[GOLDEN PIGGY] Selected item: %d x%d", selectedItem.id, itemCount))

	-- Schedule loot addition after corpse is created (500ms delay)
	local creaturePos = creature:getPosition()
	local killerName = (mostDamageKiller and mostDamageKiller:isPlayer()) and mostDamageKiller:getName() or ""
	
	print(string.format("[GOLDEN PIGGY] Scheduling loot addition in 500ms at pos(%d,%d,%d)", 
		creaturePos.x, creaturePos.y, creaturePos.z))
	
	addEvent(addPiggyLoot, 500, creaturePos, selectedItem.id, itemCount, killerName)

	-- Increment kill counter for killer
	if mostDamageKiller and mostDamageKiller:isPlayer() then
		local currentKills = mostDamageKiller:getStorageValue(config.storageKillCount)
		if currentKills < 0 then
			currentKills = 0
		end
		mostDamageKiller:setStorageValue(config.storageKillCount, currentKills + 1)
		
		-- Announce every 5 kills
		if (currentKills + 1) % 5 == 0 then
			mostDamageKiller:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
				string.format("Golden Piggy Rush: %d piggies caught!", currentKills + 1))
		end
	end

	-- Broadcast if legendary loot
	if roll >= 96 then
		Game.broadcastMessage(
			string.format("%s caught a Golden Piggy and received legendary loot!", 
				mostDamageKiller and mostDamageKiller:getName() or "Someone"),
			MESSAGE_EVENT_ADVANCE
		)
	end

	return true
end

piggyDeath:register()
print("[GOLDEN PIGGY] GoldenPiggyDeath registered!")

-- ========== SPAWN EVENT ==========
-- Events are now registered directly when monster is created
-- in golden_piggy_spawn.lua and golden_piggy_test.lua

print("[GOLDEN PIGGY] golden_piggy_mechanics.lua loaded successfully!")

