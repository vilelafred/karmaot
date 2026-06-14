-- Carrega o sistema global de controle
dofile('data/lib/exercise_control.lua')

-- Carrega o sistema de proteção contra push
dofile('data/movements/scripts/training_push_protection.lua')

-- Adicione suas configurações e variáveis aqui
local skills = {
    [8248] = {id = SKILL_SWORD, voc = 4, range = 25},
    -- Adicione outros itens e IDs conforme necessário
}

local dummies = {8242, 8241}
local gainStamina = 60
local playersInTraining = {}

local function calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
    local skillLevel = player:getSkillLevel(skillId) or 0
    -- print("(SKILL_SWORD): " .. skillLevel)

    local baseMultiplier
    local maxMultiplier

		if skillLevel >= 201 then
			baseMultiplier = 0.0000033
			maxMultiplier  = 0.0000033
		elseif skillLevel >= 110 then
			baseMultiplier = 0.000033
			maxMultiplier  = 0.000033
		elseif skillLevel >= 100 then
			baseMultiplier = 0.000120
			maxMultiplier  = 0.000120
		elseif skillLevel >= 90 then
			baseMultiplier = 0.000120
			maxMultiplier  = 0.000120
		elseif skillLevel >= 80 then
			baseMultiplier = 0.000320
			maxMultiplier  = 0.000320
		elseif skillLevel >= 70 then
			baseMultiplier = 0.000320
			maxMultiplier  = 0.000320
		elseif skillLevel >= 60 then
			baseMultiplier = 0.00320
			maxMultiplier  = 0.00320
		elseif skillLevel >= 50 then
			baseMultiplier = 0.00320
			maxMultiplier  = 0.00320
		elseif skillLevel >= 40 then
			baseMultiplier = 0.00320
			maxMultiplier  = 0.00320
		elseif skillLevel >= 30 then
			baseMultiplier = 0.0320
			maxMultiplier  = 0.0320
		elseif skillLevel >= 20 then
			baseMultiplier = 0.0320 - (skillLevel - 20) * 0.000320
			maxMultiplier  = 0.0320 - (skillLevel - 20) * 0.000320
		elseif skillLevel > 1 then
			baseMultiplier = 0.0320 - (skillLevel - 1) * 0.00400
			maxMultiplier  = 0.0320 - (skillLevel - 1) * 0.00400
		else
			baseMultiplier = 1.0
			maxMultiplier  = 1.0
		end


    local basePenalty = 1.0 / (skillLevel + 1)  -- Penalidade decrescente com o skillLevel
    local difficultyMultiplier = baseMultiplier + (maxMultiplier - baseMultiplier) * basePenalty

    -- Ajustando o multiplicador com base nos rates
    difficultyMultiplier = difficultyMultiplier * rateSkill / rateMagic

    -- print("SkillRate: " .. difficultyMultiplier)
    return difficultyMultiplier
end

-- Função para iniciar o treinamento de sword
local function startTrainSword(playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
    local player = Player(playerId)
    if not player then
        playersInTraining[playerId] = nil
        -- print("Player is nil.")
        return true
    end

    if playersInTraining[playerId] then
        return true
    end

    local pos_n = player:getPosition()
    if pos_n:getDistance(start_pos) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training interrupted.")
        playersInTraining[playerId] = nil
        -- Remove proteção contra push
        if removePushProtection then
            removePushProtection(player)
        end
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

            -- Recalcula o multiplicador de dificuldade com o novo nível da habilidade
            requiredPercentage = calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)

            fpos:sendMagicEffect(3)
            if skills[itemid].range then
                player:getPosition():sendDistanceEffect(fpos, skills[itemid].range)
            end
            player:setStamina(player:getStamina() + gainStamina)

            if charges_n == 1 then
                exercise:remove(1)
                playersInTraining[playerId] = nil
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sword Training completed.")
                -- Remove proteção contra push
                if removePushProtection then
                    removePushProtection(player)
                end
            else
                addEvent(function()
                    playersInTraining[playerId] = nil
                end, player:getVocation():getAttackSpeed(), player:getId())

                addEvent(startTrainSword, player:getVocation():getAttackSpeed(), playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sword Training. Weapon charges: " .. (charges_n - 1))
            end
        else
            exercise:remove(1)
            playersInTraining[playerId] = nil
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sword Training Finished.")
            -- Remove proteção contra push
            if removePushProtection then
                removePushProtection(player)
            end
        end
    else
        playersInTraining[playerId] = nil
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Put in the backpack.")
        -- Remove proteção contra push
        if removePushProtection then
            removePushProtection(player)
        end
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local start_pos = player:getPosition()

    if target:isItem() and isInArray(dummies, target:getId()) then
        if not skills[item.itemid].range and start_pos:getDistance(target:getPosition()) > 1 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Too far, get close.")
            return false
        end

        local voc = player:getVocation()
        local vocId = voc:getId()
        if vocId == 0 or vocId == skills[item.itemid].voc or vocId == skills[item.itemid].voc + 4 then
            -- Verifica sistema global de treino
            if GlobalTrainingControl then
                local success, currentTraining = GlobalTrainingControl.startTraining(player:getId(), GlobalTrainingControl.TRAINING_TYPES.SKILL_SWORD)
                if not success then
                    local trainingName = GlobalTrainingControl.getTrainingTypeName(currentTraining)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already training " .. trainingName .. ". Stop current training first.")
                    return false
                end
            else
                -- Fallback para sistema local se global não estiver disponível
                if playersInTraining[player:getId()] then
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already in Sword training.")
                    return false
                end
            end

            -- Adiciona proteção contra push
            if addPushProtection then
                addPushProtection(player)
            end

            local rateMagic = 1
            local rateSkill = 4

            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You started Sword training.")
            addEvent(startTrainSword, 0, player:getId(), item.itemid, target:getPosition(), start_pos, rateMagic, rateSkill)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid vocation.")
            return false
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid target.")
    end

    return true
end
