-- Adicione suas configurações e variáveis aqui
local skills = {
    [8244] = {id = SKILL_MAGLEVEL, voc = 1, range = CONST_ANI_FIRE},
}

local dummies = {8242, 8241}
local gainStamina = 60
local playersInTraining = {}

local function calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
    local maglevel = player:getMagicLevel() or 0

    print("(SKILL_MAGLEVEL): " .. maglevel)

    local baseMultiplier
    local maxMultiplier

    if maglevel == 0 then
		baseMultiplier = 0.033 - (maglevel - 1) * 0.0033
		maxMultiplier = 0.033 - (maglevel - 1) * 0.0033
    elseif maglevel > 110 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif maglevel > 100 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif maglevel > 90 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif maglevel > 80 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif maglevel > 70 then
        baseMultiplier = 0.000033
        maxMultiplier = 0.000033
    elseif maglevel > 60 then
        baseMultiplier = 0.00033
        maxMultiplier = 0.00033
    elseif maglevel > 50 then
        baseMultiplier = 0.00033
        maxMultiplier = 0.00033
    elseif maglevel > 40 then
        baseMultiplier = 0.00033
        maxMultiplier = 0.00033
    elseif maglevel > 30 then
        baseMultiplier = 0.0033
        maxMultiplier = 0.0033
	elseif maglevel > 20 then
		baseMultiplier = 0.0033 - (maglevel - 20) * 0.000033
		maxMultiplier = 0.0033 - (maglevel - 20) * 0.000033
	elseif maglevel > 1 then
		baseMultiplier = 0.033 - (maglevel - 1) * 0.00165
		maxMultiplier = 0.033 - (maglevel - 1) * 0.00165
    else
        baseMultiplier = 1.0
        maxMultiplier = 1.0
    end

    local basePenalty = 1.0 / (maglevel + 1)  -- Penalidade decrescente com o maglevel

    local difficultyMultiplier = baseMultiplier + (maxMultiplier - baseMultiplier) * basePenalty

    -- Ajustando o multiplicador com base nos rates
    difficultyMultiplier = difficultyMultiplier * rateSkill / rateMagic

    print("SkillRate: " .. difficultyMultiplier)

    return difficultyMultiplier
end


-- Função para iniciar o treinamento
local function startTrain(playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
    local player = Player(playerId)
    if not player then
        print("Player is nil.")
        return true
    end

    if playersInTraining[playerId] then
        return true
    end

    local pos_n = player:getPosition()
    if pos_n:getDistance(start_pos) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training interrupted.")
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

            if skillId == SKILL_MAGLEVEL then
                local required = player:getVocation():getRequiredManaSpent(player:getBaseMagicLevel() + 1)
                local gainAmount = math.ceil(required * requiredPercentage)
                player:addManaSpent(gainAmount)
            else
                local required = player:getVocation():getRequiredSkillTries(skillId, player:getSkillLevel(skillId) + 1)
                local gainAmount = math.ceil(required * requiredPercentage)
                player:addSkillTries(skillId, gainAmount)

                -- Recalcula o multiplicador de dificuldade com o novo nível da habilidade
                requiredPercentage = calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
            end

            fpos:sendMagicEffect(3)
            if skills[itemid].range then
                player:getPosition():sendDistanceEffect(fpos, skills[itemid].range)
            end
            player:setStamina(player:getStamina() + gainStamina)

            if charges_n == 1 then
                exercise:remove(1)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training completed.")
            else
                addEvent(function()
                    playersInTraining[playerId] = nil
                end, player:getVocation():getAttackSpeed(), player:getId())

                addEvent(startTrain, player:getVocation():getAttackSpeed(), playerId, itemid, fpos, start_pos, rateMagic, rateSkill)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training. Weapon charges: " .. (charges_n - 1))
            end
        else
            exercise:remove(1)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training Finished.")
        end
    else
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

        local voc = player:getVocation()
        if voc:getId() == skills[item.itemid].voc or voc:getId() == skills[item.itemid].voc + 4 then
            if playersInTraining[player:getId()] then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are already in training.")
                return false
            end

            local rateMagic = 1
            local rateSkill = 4

            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You started training.")
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
