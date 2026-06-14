-- Carrega o sistema global de controle
dofile('data/lib/exercise_control.lua')

local skills = {
	[7730] = {id = SKILL_SHIELD, voc = {1, 2, 3, 4}}, -- Todas as vocações
}

local dummies = {8242, 8241}
local gainStamina = 60
local playersInTraining = {} -- Mantido para compatibilidade local

local function calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
	-- Usa o nível atual de Shielding do jogador
	local shieldLevel = player:getSkillLevel(SKILL_SHIELD) or 0
	if shieldLevel < 0 then
		shieldLevel = 0
	end

	local baseMultiplier

	-- Curva baseada no exercise_magic, adaptada para Shielding e 30% MAIS difícil
	-- "Mais difícil" => 30% MENOS ganho por carga (multiplicador x 0.7)
	if shieldLevel == 0 then
		baseMultiplier = 0.01
	elseif shieldLevel <= 10 then
		baseMultiplier = 0.008
	elseif shieldLevel <= 20 then
		baseMultiplier = 0.006
	elseif shieldLevel <= 30 then
		baseMultiplier = 0.005
	elseif shieldLevel <= 40 then
		baseMultiplier = 0.004
	elseif shieldLevel <= 50 then
		baseMultiplier = 0.003
	elseif shieldLevel <= 60 then
		baseMultiplier = 0.0025
	elseif shieldLevel <= 70 then
		baseMultiplier = 0.002
	elseif shieldLevel <= 80 then
		baseMultiplier = 0.0015
	elseif shieldLevel <= 90 then
		baseMultiplier = 0.0012
	elseif shieldLevel <= 100 then
		baseMultiplier = 0.001
	elseif shieldLevel <= 110 then
		baseMultiplier = 0.0005
	elseif shieldLevel <= 120 then
		baseMultiplier = 0.00033
	elseif shieldLevel <= 130 then
		baseMultiplier = 0.00025
	elseif shieldLevel <= 140 then
		baseMultiplier = 0.0002
	elseif shieldLevel <= 150 then
		baseMultiplier = 0.0001
	else
		baseMultiplier = 0.00007
	end

	-- Aplica a dificuldade 30% maior (reduz o ganho)
	baseMultiplier = baseMultiplier * 0.7

	local difficultyMultiplier = baseMultiplier * rateSkill / rateMagic
	return difficultyMultiplier
end

local function startTrain(playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
	local player = Player(playerId)
	if not player then
		playersInTraining[playerId] = nil
		GlobalTrainingControl.stopTraining(playerId)
		return true
	end

	if playersInTraining[playerId] then return true end

	if player:getPosition():getDistance(start_pos) > 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training interrupted.")
		playersInTraining[playerId] = nil
		GlobalTrainingControl.stopTraining(playerId)
		return true
	end

	-- Verifica se o dummy ainda existe na posição
	local tile = Tile(fpos)
	if not tile then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training interrupted - dummy not found.")
		playersInTraining[playerId] = nil
		GlobalTrainingControl.stopTraining(playerId)
		return true
	end

	local item = tile:getTopDownItem()
	if not item or not isInArray(dummies, item:getId()) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training interrupted - dummy not found.")
		playersInTraining[playerId] = nil
		GlobalTrainingControl.stopTraining(playerId)
		return true
	end

	playersInTraining[playerId] = true
	local exercise = player:getItemById(itemid, true)

	if exercise and exercise:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
		local charges_n = exercise:getAttribute(ITEM_ATTRIBUTE_CHARGES)

		if charges_n >= 1 then
			exercise:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges_n - 1)

			local skillId = skills[itemid].id
			local requiredPercentage = calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)

			local required = player:getVocation():getRequiredSkillTries(skillId, player:getSkillLevel(skillId) + 1)
			local gainAmount = math.ceil(required * requiredPercentage)
			player:addSkillTries(skillId, gainAmount)

			fpos:sendMagicEffect(3)
			if skills[itemid].range then
				player:getPosition():sendDistanceEffect(fpos, skills[itemid].range)
			end
			player:setStamina(player:getStamina() + gainStamina)

			if charges_n == 1 then
				exercise:remove(1)
				playersInTraining[playerId] = nil
				GlobalTrainingControl.stopTraining(playerId)
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Shield Training completed.")
			else
				addEvent(function()
					playersInTraining[playerId] = nil
				end, player:getVocation():getAttackSpeed(), player:getId())

				addEvent(startTrain, player:getVocation():getAttackSpeed(), playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Shield Training. Weapon charges: " .. (charges_n - 1))
			end
		else
			exercise:remove(1)
			playersInTraining[playerId] = nil
			GlobalTrainingControl.stopTraining(playerId)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Shield Training Finished.")
		end
	else
		playersInTraining[playerId] = nil
		GlobalTrainingControl.stopTraining(playerId)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Put in the backpack.")
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local start_pos = player:getPosition()

	if target:isItem() and isInArray(dummies, target:getId()) then
		if not skills[item.itemid].range and start_pos:getDistance(target:getPosition()) > 1 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Too far, get close.")
			return false
		end

        local vocId = player:getVocation():getId()
		local allowedVocs = skills[item.itemid].voc
        if vocId == 0 or isInArray(allowedVocs, vocId) or isInArray(allowedVocs, vocId - 4) then
			-- Verifica sistema global de treino
			if GlobalTrainingControl then
				local success, currentTraining = GlobalTrainingControl.startTraining(player:getId(), GlobalTrainingControl.TRAINING_TYPES.SKILL_SHIELD)
				if not success then
					local trainingName = GlobalTrainingControl.getTrainingTypeName(currentTraining)
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already training " .. trainingName .. ". Stop current training first.")
					return false
				end
			else
				-- Fallback para sistema local se global não estiver disponível
				if playersInTraining[player:getId()] then
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already in training.")
					return false
				end
			end

			local rateMagic = 1
			local rateSkill = 2

			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You started training Shielding.")
			addEvent(startTrain, 0, player:getId(), item.itemid, target:getPosition(), start_pos, rateMagic, rateSkill)
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid vocation.")
			return false
		end
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid target.")
	end

	return true
end


