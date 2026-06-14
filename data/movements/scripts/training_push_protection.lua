-- Sistema de proteção contra push para players em treino
-- Este script adiciona proteção contra push diretamente nos scripts de treino

-- Carrega o sistema global de controle
dofile('data/lib/exercise_control.lua')

-- Função para adicionar proteção contra push a um player
function addPushProtection(player)
    if not player then
        return false
    end
    
    -- Adiciona a flag cannotbepushed temporariamente usando grupo específico
    player:setGroup(Group(4)) -- Grupo training_protection que tem apenas cannotbepushed
    return true
end

-- Função para remover proteção contra push de um player
function removePushProtection(player)
    if not player then
        return false
    end
    
    -- Remove a flag cannotbepushed voltando para grupo Player
    player:setGroup(Group(1)) -- Volta para grupo Player
    return true
end

-- Função para verificar se um player está protegido
function isPushProtected(player)
    if not player then
        return false
    end
    
    local group = player:getGroup()
    return group and group:getId() == 4 -- Grupo training_protection
end

-- Exporta as funções para serem usadas nos scripts de treino
_G.addPushProtection = addPushProtection
_G.removePushProtection = removePushProtection
_G.isPushProtected = isPushProtected
