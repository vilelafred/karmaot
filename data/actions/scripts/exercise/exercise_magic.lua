-- Carrega o sistema global de controle
dofile('data/lib/exercise_control.lua')

local skills = {
    [8244] = {id = SKILL_MAGLEVEL, voc = {0, 1, 2, 3, 4}, range = CONST_ANI_FIRE}, -- Todas as vocações
}

local dummies = {8242, 8241}
local gainStamina = 60
local playersInTraining = {} -- Mantido para compatibilidade local

local function calculateDifficultyMultiplier(player, skillId, rateMagic, rateSkill)
    -- Usa getBaseMagicLevel() para não considerar bônus de equipamentos
    local maglevel = player:getBaseMagicLevel() or 0
    
    -- Verificação de segurança para evitar valores negativos
    if maglevel < 0 then
        maglevel = 0
    end
    local baseMultiplier
    
    -- Obtém a vocação base do jogador
    local vocId = player:getVocation():getId()
    if vocId > 4 then
        vocId = vocId - 4 -- Converte vocações promovidas para base
    end
    
    -- Sistema EXTREMAMENTE restritivo para cada vocação
    if vocId == 1 or vocId == 2 then -- Sorcerer/Druid (ML até 150)
        if maglevel == 0 then
            baseMultiplier = 0.01 -- ML 0: ~1-2 varinhas de 15000 cargas para ML 1
        elseif maglevel <= 10 then
            baseMultiplier = 0.008 -- ML 1-10: ~2-3 varinhas de 15000 cargas por ML
        elseif maglevel <= 20 then
            baseMultiplier = 0.006 -- ML 11-20: ~3-4 varinhas de 15000 cargas por ML
        elseif maglevel <= 30 then
            baseMultiplier = 0.005 -- ML 21-30: ~4-5 varinhas de 15000 cargas por ML
        elseif maglevel <= 40 then
            baseMultiplier = 0.004 -- ML 31-40: ~5-6 varinhas de 15000 cargas por ML
        elseif maglevel <= 50 then
            baseMultiplier = 0.003 -- ML 41-50: ~7-8 varinhas de 15000 cargas por ML
        elseif maglevel <= 60 then
            baseMultiplier = 0.0025 -- ML 51-60: ~8-10 varinhas de 15000 cargas por ML
        elseif maglevel <= 70 then
            baseMultiplier = 0.002 -- ML 61-70: ~10-12 varinhas de 15000 cargas por ML
        elseif maglevel <= 80 then
            baseMultiplier = 0.0015 -- ML 71-80: ~13-15 varinhas de 15000 cargas por ML
        elseif maglevel <= 90 then
            baseMultiplier = 0.0012 -- ML 81-90: ~16-18 varinhas de 15000 cargas por ML
        elseif maglevel <= 100 then
            baseMultiplier = 0.001 -- ML 91-100: 1 varinha de 15000 cargas por ML
        elseif maglevel <= 110 then
            baseMultiplier = 0.0005 -- ML 101-110: 2 varinhas de 15000 cargas por ML
        elseif maglevel <= 120 then
            baseMultiplier = 0.00033 -- ML 111-120: 3 varinhas de 15000 cargas por ML
        elseif maglevel <= 130 then
            baseMultiplier = 0.00025 -- ML 121-130: 4 varinhas de 15000 cargas por ML
        elseif maglevel <= 140 then
            baseMultiplier = 0.0002 -- ML 131-140: 5 varinhas de 15000 cargas por ML
        elseif maglevel <= 145 then
            baseMultiplier = 0.0002 -- ML 141-145: 5 varinhas de 15000 cargas por ML
        elseif maglevel <= 150 then
            baseMultiplier = 0.0001 -- ML 146-150: 10 varinhas de 15000 cargas por ML
        else
            baseMultiplier = 0.000005 -- ML 151+: 20 varinhas de 15000 cargas por ML
        end
    elseif vocId == 3 then -- Paladin (ML até ~40-50)
        if maglevel == 0 then
            baseMultiplier = 0.02 -- ML 0: ~1 varinha de 15000 cargas para ML 1
        elseif maglevel <= 5 then
            baseMultiplier = 0.0015 -- ML 1-5: ~2-3 varinhas de 15000 cargas por ML
        elseif maglevel <= 10 then
            baseMultiplier = 0.0012 -- ML 6-10: ~3-4 varinhas de 15000 cargas por ML
        elseif maglevel <= 15 then
            baseMultiplier = 0.001 -- ML 11-15: ~4-5 varinhas de 15000 cargas por ML
        elseif maglevel <= 20 then
            baseMultiplier = 0.0008 -- ML 16-20: ~50-60 varinhas de 15000 cargas por ML
        elseif maglevel <= 25 then
            baseMultiplier = 0.0006 -- ML 21-25: ~70-80 varinhas de 15000 cargas por ML
        elseif maglevel <= 30 then
            baseMultiplier = 0.0004 -- ML 26-30: ~100-120 varinhas de 15000 cargas por ML
        elseif maglevel <= 35 then
            baseMultiplier = 0.0003 -- ML 31-35: ~1500-2000 varinhas de 15000 cargas por ML
        elseif maglevel <= 40 then
            baseMultiplier = 0.0001 -- ML 36-40: ~5000-6000 varinhas de 15000 cargas por ML
        elseif maglevel <= 45 then
            baseMultiplier = 0.000005 -- ML 41-45: ~10000-12000 varinhas de 15000 cargas por ML
        else
            baseMultiplier = 0.000002 -- ML 46+: ~2500-3000 varinhas de 15000 cargas por ML
        end
    elseif vocId == 4 then -- Knight (ML até ~14)
        if maglevel == 0 then
            baseMultiplier = 0.03 -- Muito fácil
        elseif maglevel <= 3 then
            baseMultiplier = 0.0025
        elseif maglevel <= 6 then
            baseMultiplier = 0.002
        elseif maglevel <= 9 then
            baseMultiplier = 0.00015
        elseif maglevel <= 10 then
            baseMultiplier = 0.00001 -- ML 4-10 = ~3-4 varinhas total
        elseif maglevel <= 12 then
            baseMultiplier = 0.000005 -- ML 10+ = 3-4 varinhas por ML
        elseif maglevel <= 14 then
            baseMultiplier = 0.000002 -- Extremamente difícil
        else
            baseMultiplier = 0.000001 -- Praticamente impossível
        end
    else
        baseMultiplier = 0.0001 -- Fallback muito restritivo
    end

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

            if skillId == SKILL_MAGLEVEL then
                local required = player:getVocation():getRequiredManaSpent(player:getBaseMagicLevel() + 1)
                local gainAmount = math.ceil(required * requiredPercentage)
                player:addManaSpent(gainAmount)
            else
                local required = player:getVocation():getRequiredSkillTries(skillId, player:getSkillLevel(skillId) + 1)
                local gainAmount = math.ceil(required * requiredPercentage)
                player:addSkillTries(skillId, gainAmount)
            end

            fpos:sendMagicEffect(3)
            if skills[itemid].range then
                player:getPosition():sendDistanceEffect(fpos, skills[itemid].range)
            end
            player:setStamina(player:getStamina() + gainStamina)

            if charges_n == 1 then
                exercise:remove(1)
                playersInTraining[playerId] = nil
                GlobalTrainingControl.stopTraining(playerId)
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
            playersInTraining[playerId] = nil
            GlobalTrainingControl.stopTraining(playerId)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Training Finished.")
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
        if isInArray(allowedVocs, vocId) or isInArray(allowedVocs, vocId - 4) then
            -- Verifica sistema global de treino
            if GlobalTrainingControl then
                local success, currentTraining = GlobalTrainingControl.startTraining(player:getId(), GlobalTrainingControl.TRAINING_TYPES.MAGIC_LEVEL)
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
            local rateSkill = 2 -- Corrigido: não multiplicar por 4
            
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You started training Magic Level.")
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
