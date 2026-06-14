local exhaust = Condition(CONDITION_EXHAUST_HEAL)
exhaust:setParameter(CONDITION_PARAM_TICKS,20*1000)


local manaRegenerationTime = 10 -- The duration of the mana regeneration effect in seconds
local manaStorage = 1234 -- SET YOUR STORAGE FOR MANA REG
local manaRegeneration = Condition(CONDITION_REGENERATION)
manaRegeneration:setParameter(CONDITION_PARAM_SUBID, 101)
manaRegeneration:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
manaRegeneration:setParameter(CONDITION_PARAM_MANAGAIN, 2)
manaRegeneration:setParameter(CONDITION_PARAM_MANATICKS, 3000)


local healthStorage = 12345 -- SET YOUR STORAGE FOR HEALTH REG
local healthRegenerationTime = 10 -- The duration of the health regeneration effect in seconds
local healthRegeneration = Condition(CONDITION_REGENERATION)
healthRegeneration:setParameter(CONDITION_PARAM_SUBID, 102)
healthRegeneration:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
healthRegeneration:setParameter(CONDITION_PARAM_HEALTHGAIN, 2) -- How much health per tick
healthRegeneration:setParameter(CONDITION_PARAM_HEALTHTICKS, 3000) -- milliseconds between each tick

local conditionHaste = Condition(CONDITION_HASTE)
conditionHaste:setParameter(CONDITION_PARAM_SUBID, 103)
conditionHaste:setParameter(CONDITION_PARAM_TICKS, 10 * 1000) -- 10 seconds
conditionHaste:setParameter(CONDITION_PARAM_SPEED, 10) -- + 10 haste

local config ={
[9999] ={ -- cherry
		mana = true,
		amount = {4,10},
		text = "Yum.",
		hunger = 1,
},
[9999] ={ 
		health = true,
		amount = {5,10},
		text = "Gulp.",
		hunger = 8,
},
[9999] ={ 
		healthReg = true,
		amount = {5,10},
		text = "Munch.",
		hunger = 7,
},
[9999] ={ 
		manaReg = true,
		amount = {5,10},
		text = "Munch.",
		hunger = 7,
},
[9999] = { 
		health = true,
		amount = {1, 3},
		text = "Smack.",
		hunger = 9,
},
[9999] = { 
		speed = true,
		amount = {1, 3},
		text = "Mmmm.",
		hunger = 20,
},
[9999] = { 
		soul = true,
		amount = {0, 1},
		text = "Slurp.",
		hunger = 18,
},

}

local eatFood = Action()
function eatFood.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local food = config[item.itemid]
	if not food then
		return false
	end

	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (food.hunger * 12)) >= 1200 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are full.")
		return true
	end

	if food.mana then
		player:addMana(math.random(food.amount[1],food.amount[2]))


	elseif food.manaReg then
		-- Check if the player has already eaten
		local currentManaTicks = player:getStorageValue(manaStorage)
		local currentTime = os.time()

		if currentManaTicks == 0 or currentManaTicks < currentTime then
			-- Player hasn't eaten a mushroom or the effect has expired, set a new duration
			local newManaTicks = currentTime + manaRegenerationTime
			player:setStorageValue(manaStorage, newManaTicks)

			-- Apply the mana regeneration condition
			manaRegeneration:setParameter(CONDITION_PARAM_TICKS, manaRegenerationTime * 1000)
			player:addCondition(manaRegeneration)
		else
			-- Player has already eaten a mushroom, extend the duration
			local newManaTicks = currentManaTicks + manaRegenerationTime
			player:setStorageValue(manaStorage, newManaTicks)
			local playerCond = player:getCondition(CONDITION_REGENERATION,false,101)
			-- Find and extend the existing mana regeneration condition
				if playerCond then
					local addedDuration = manaRegenerationTime * 1000
					local remainingTimeMs = playerCond:getEndTime() - currentTime * 1000
					manaRegeneration:setParameter(CONDITION_PARAM_TICKS, remainingTimeMs + addedDuration)
					player:addCondition(manaRegeneration)
			end
			player:addCondition(exhaust)
		end

	elseif food.health then
		player:addHealth(math.random(food.amount[1],food.amount[2]))
	elseif food.healthReg then
		local currentHealthTicks = player:getStorageValue(healthStorage)
		local currentTime = os.time()
		if currentHealthTicks == 0 or currentHealthTicks < currentTime then
			local newHealthTicks = currentTime + healthRegenerationTime
			player:setStorageValue(healthStorage, newHealthTicks)

			healthRegeneration:setParameter(CONDITION_PARAM_TICKS, healthRegenerationTime * 1000)
			player:addCondition(healthRegeneration)
		else
			local newHealthTicks = currentHealthTicks + healthRegenerationTime
			player:setStorageValue(healthStorage, newHealthTicks)
			local playerCond = player:getCondition(CONDITION_REGENERATION,false,102)
			if playerCond then
				local addedDuration = healthRegenerationTime * 1000
				local remainingTimeMs = playerCond:getEndTime() - currentTime * 1000
				healthRegeneration:setParameter(CONDITION_PARAM_TICKS, remainingTimeMs + addedDuration)
				player:addCondition(healthRegeneration)
			end
			player:addCondition(exhaust)
		end
		
	elseif food.exp then
		player:addExperience(math.random(food.amount[1],food.amount[2]),true)
	elseif food.speed then
		player:addCondition(conditionHaste)
		player:addCondition(exhaust)
	elseif food.soul then
		player:addSoul(math.random(food.amount[1],food.amount[2]))
	else
		return false
		end
		item:remove(1)
		player:feed(food.hunger * 12)
		player:say(food.text,TALKTYPE_MONSTER_SAY)
	return true
end

for itemid,_ in pairs(config)do
	eatFood:id(itemid)
end
eatFood:register()
