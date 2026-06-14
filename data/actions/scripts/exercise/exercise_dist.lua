-- Carrega o sistema global de controle
dofile('data/lib/exercise_control.lua')

-- Carrega o sistema de proteção contra push
dofile('data/movements/scripts/training_push_protection.lua')

-- Adicione suas configurações e variáveis aqui
local skills = {
    [8245] = {id = SKILL_DISTANCE, voc = 3, range = 54},
}

local dummies = {8242, 8241}  -- Seus IDs de bonecos de treinamento
local gainStamina = 60
local playersInTraining = {}

local function calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
    local skillLevel = player:getSkillLevel(skillId) or 0
    -- print("(SKILL_DISTANCE): " .. skillLevel)

    local baseMultiplier
    local maxMultiplier

    if skillLevel >= 110 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif skillLevel >= 100 then
        baseMultiplier = 0.000120
        maxMultiplier = 0.000120
    elseif skillLevel >= 90 then
        baseMultiplier = 0.000120
        maxMultiplier = 0.000120
    elseif skillLevel >= 80 then
        baseMultiplier = 0.000320
        maxMultiplier = 0.000320
    elseif skillLevel >= 70 then
        baseMultiplier = 0.000320
        maxMultiplier = 0.000320
    elseif skillLevel >= 60 then
        baseMultiplier = 0.00320
        maxMultiplier = 0.00320
    elseif skillLevel >= 50 then
        baseMultiplier = 0.00320
        maxMultiplier = 0.00320
    elseif skillLevel >= 40 then
        baseMultiplier = 0.00320
        maxMultiplier = 0.00320
    elseif skillLevel >= 30 then
        baseMultiplier = 0.0320
        maxMultiplier = 0.0320
    elseif skillLevel >= 20 then
        baseMultiplier = 0.0320 - (skillLevel - 20) * 0.000320
        maxMultiplier = 0.0320 - (skillLevel - 20) * 0.000320
    elseif skillLevel > 1 then
        baseMultiplier = 0.0320 - (skillLevel - 1) * 0.00400
        maxMultiplier = 0.0320 - (skillLevel - 1) * 0.00400
    else
        baseMultiplier = 1.0
        maxMultiplier = 1.0
    end

    local basePenalty = 1.0 / (skillLevel + 1)  -- Penalidade decrescente com o skillLevel

    local difficultyMultiplier = baseMultiplier + (maxMultiplier - baseMultiplier) * basePenalty

    -- Ajustando o multiplicador com base nos rates
    difficultyMultiplier = difficultyMultiplier * rateSkill / rateMagic

    -- print("SkillRate: " .. difficultyMultiplier)

    return difficultyMultiplier
end

-- Função para iniciar o treinamento de distance
local function startTrainDistance(playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
    local player = Player(playerId)
    if not player then
        -- print("Player is nil.")
        return true
    end

    if playersInTraining[playerId] then
        return true
    end

    local pos_n = player:getPosition()
    if pos_n:getDistance(start_pos) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Distance Training interrupted.")
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
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Distance Training completed.")
                -- Remove proteção contra push
                if removePushProtection then
                    removePushProtection(player)
                end
            else
                addEvent(function()
                    playersInTraining[playerId] = nil
                end, player:getVocation():getAttackSpeed(), player:getId())

                addEvent(startTrainDistance, player:getVocation():getAttackSpeed(), playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Distance Training. Weapon charges: " .. (charges_n - 1))
            end
        else
            exercise:remove(1)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Distance Training Finished.")
            -- Remove proteção contra push
            if removePushProtection then
                removePushProtection(player)
            end
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Put in the backpack.")
        -- Remove proteção contra push
        if removePushProtection then
            removePushProtection(player)
        end
    end
end

-- Função chamada quando o jogador usa o item para treinar distância
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local start_pos = player:getPosition()

    -- Verifica se o alvo é um item (dummy) e está na lista de dummies
    if target:isItem() and isInArray(dummies, target:getId()) then
        -- Verifica se a skill não possui alcance e se o jogador está próximo do alvo
        if not skills[item.itemid].range and start_pos:getDistance(target:getPosition()) > 1 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Too far, get close.")
            return false
        end

        local voc = player:getVocation()
        local vocId = voc:getId()
        -- Verifica se a vocação do jogador é compatível com a vocação permitida para a skill
        if vocId == 0 or vocId == skills[item.itemid].voc or vocId == skills[item.itemid].voc + 4 then
            -- Verifica sistema global de treino
            if GlobalTrainingControl then
                local success, currentTraining = GlobalTrainingControl.startTraining(player:getId(), GlobalTrainingControl.TRAINING_TYPES.SKILL_DISTANCE)
                if not success then
                    local trainingName = GlobalTrainingControl.getTrainingTypeName(currentTraining)
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already training " .. trainingName .. ". Stop current training first.")
                    return false
                end
            else
                -- Fallback para sistema local se global não estiver disponível
                if playersInTraining[player:getId()] then
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already in Distance training.")
                    return false
                end
            end

            -- Adiciona proteção contra push
            if addPushProtection then
                addPushProtection(player)
            end

            local rateMagic = 1
            local rateSkill = 4

            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You started Distance training.")
            -- Inicia o treinamento de distância
            addEvent(startTrainDistance, 0, player:getId(), item.itemid, target:getPosition(), start_pos, rateMagic, rateSkill)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid vocation.")
            return false
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid target.")
    end

    return true
end
