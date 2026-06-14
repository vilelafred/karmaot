-- ===================================================
-- TELEPORT DAMAGE LEVER
-- ===================================================
-- Alavanca que teleporta o player e causa 95% de dano
-- Position: {x = 32915, y = 30225, z = 9}

local config = {
    targetPosition = Position(32915, 30225, 9),
    damagePercent = 95, -- 95% da vida atual
    message = "You have been teleported! The journey has drained your life force!",
    effectPlayer = CONST_ME_TELEPORT, -- Efeito no player
    effectDestination = CONST_ME_ENERGYAREA, -- Efeito no destino
    leverIds = {1945, 1946} -- IDs da alavanca
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not player then
        return false
    end
    
    -- Toggle da alavanca
    if item.itemid == config.leverIds[1] then
        item:transform(config.leverIds[2])
    elseif item.itemid == config.leverIds[2] then
        item:transform(config.leverIds[1])
    end
    
    -- Efeito na posição atual do player
    local currentPos = player:getPosition()
    currentPos:sendMagicEffect(config.effectPlayer)
    
    -- Calcular dano (95% da vida atual)
    local currentHealth = player:getHealth()
    local damageAmount = math.floor(currentHealth * (config.damagePercent / 100))
    
    -- Garantir que o player não morra (deixa pelo menos 1 HP)
    if damageAmount >= currentHealth then
        damageAmount = currentHealth - 1
    end
    
    -- Aplicar o dano
    if damageAmount > 0 then
        player:addHealth(-damageAmount)
        print(string.format("[Teleport Lever] Player %s took %d damage (%d%%)", 
            player:getName(), damageAmount, config.damagePercent))
    end
    
    -- Teleportar o player
    player:teleportTo(config.targetPosition)
    
    -- Efeito na posição de destino
    config.targetPosition:sendMagicEffect(config.effectDestination)
    
    -- Mensagem para o player
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config.message)
    
    -- Log
    print(string.format("[Teleport Lever] Player %s teleported to position %s", 
        player:getName(), config.targetPosition:toString()))
    
    return true
end

