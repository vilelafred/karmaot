-- Sistema global de controle de treino
-- Impede que players treinem múltiplas skills/magic level simultaneamente

if not GlobalTrainingControl then
    GlobalTrainingControl = {}
end

-- Tabela global para rastrear players em treino
GlobalTrainingControl.playersInTraining = {}

-- Tipos de treino
GlobalTrainingControl.TRAINING_TYPES = {
    MAGIC_LEVEL = "magic_level",
    SKILL_AXE = "skill_axe",
    SKILL_SWORD = "skill_sword", 
    SKILL_CLUB = "skill_club",
    SKILL_DISTANCE = "skill_distance",
    SKILL_SHIELD = "skill_shield"
}

-- Função para verificar se player já está treinando
function GlobalTrainingControl.isPlayerTraining(playerId)
    return GlobalTrainingControl.playersInTraining[playerId] ~= nil
end

-- Função para iniciar treino
function GlobalTrainingControl.startTraining(playerId, trainingType)
    if GlobalTrainingControl.isPlayerTraining(playerId) then
        local currentType = GlobalTrainingControl.playersInTraining[playerId]
        return false, currentType
    end
    
    GlobalTrainingControl.playersInTraining[playerId] = trainingType
    return true, nil
end

-- Função para parar treino
function GlobalTrainingControl.stopTraining(playerId)
    GlobalTrainingControl.playersInTraining[playerId] = nil
end

-- Função para obter tipo de treino atual
function GlobalTrainingControl.getCurrentTraining(playerId)
    return GlobalTrainingControl.playersInTraining[playerId]
end

-- Função para obter nome amigável do tipo de treino
function GlobalTrainingControl.getTrainingTypeName(trainingType)
    local names = {
        [GlobalTrainingControl.TRAINING_TYPES.MAGIC_LEVEL] = "Magic Level",
        [GlobalTrainingControl.TRAINING_TYPES.SKILL_AXE] = "Axe Fighting",
        [GlobalTrainingControl.TRAINING_TYPES.SKILL_SWORD] = "Sword Fighting",
        [GlobalTrainingControl.TRAINING_TYPES.SKILL_CLUB] = "Club Fighting",
        [GlobalTrainingControl.TRAINING_TYPES.SKILL_DISTANCE] = "Distance Fighting",
        [GlobalTrainingControl.TRAINING_TYPES.SKILL_SHIELD] = "Shielding"
    }
    return names[trainingType] or "Unknown"
end
