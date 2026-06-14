-- ===================================================
-- VIP BLESSING SYSTEM (Single VIP Blessing - ID 6)
-- ===================================================
-- Adiciona 1 blessing VIP (ID 6) que oferece protecao extra contra perda de exp/skill ao morrer
-- Requisito: Ter todas as 5 blessings basicas (1-5)
-- Com 5 blessings: 5% loss | Com 6 blessings (VIP): 1% loss (80% reduction)
-- Preco dinamico baseado no level do player (alto custo = gold sink)

-- Calcula preco da bless VIP baseado no level
-- Formula progressiva: levels baixos crescem devagar, levels altos crescem mais rapido
-- Level 500: 5kk | Level 1000: 10kk | Level 1100: 13kk | Level 1500: 22kk
local function calculateVipBlessPrice(level)
    if level <= 500 then
        return 5000000  -- minimo 5kk ate level 500
    elseif level <= 1000 then
        -- de 500 a 1000: 5kk base + 1kk a cada 100 levels
        return 5000000 + ((level - 500) / 100) * 1000000
    else
        -- de 1000 em diante: 10kk base + 3kk a cada 100 levels
        return 10000000 + ((level - 1000) / 100) * 3000000
    end
end

-- Formata gold para exibicao (ex: 5000000 -> "5kk")
local function formatGold(amount)
    if amount >= 1000000 then
        return string.format("%.1fkk", amount / 1000000)
    elseif amount >= 1000 then
        return string.format("%.1fk", amount / 1000)
    else
        return tostring(amount)
    end
end

-- Executa a compra da blessing VIP
local function purchaseVipBlessing(player, price, altarPos)
    -- Remove o dinheiro
    if not player:removeTotalMoney(price) then
        player:sendCancelMessage("You do not have enough gold.")
        altarPos:sendMagicEffect(CONST_ME_POFF)
        return false
    end
    
    -- Adiciona blessing VIP (ID 6)
    player:addBlessing(6, 1)
    
    -- Mensagem de sucesso
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been blessed with the VIP protection!")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You now lose only 1% exp/skills on death!")
    
    -- Efeitos visuais
    local playerPos = player:getPosition()
    altarPos:sendMagicEffect(CONST_ME_HOLYDAMAGE)
    playerPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    altarPos:sendDistanceEffect(playerPos, CONST_ANI_SMALLHOLY)
    
    -- Log
    print(string.format("[VIP Blessing] Player %s (level %d) purchased VIP blessing for %s gold", 
        player:getName(), player:getLevel(), formatGold(price)))
    
    return true
end

-- Abre modal window de confirmacao
local function openVipBlessModal(player, altarPos)
    -- Verificar se tem todas as 5 blessings basicas
    local hasAllBasic = true
    for i = 1, 5 do
        if not player:hasBlessing(i) then
            hasAllBasic = false
            break
        end
    end
    
    if not hasAllBasic then
        local msg = "=== VIP BLESSING ===\n\n"
        msg = msg .. "REQUIREMENT NOT MET\n\n"
        msg = msg .. "You must have all 5 basic blessings before purchasing the VIP blessing!\n\n"
        msg = msg .. "Talk to the Monge to get the basic blessings first.\n\n"
        msg = msg .. "EXAMPLE (Level 700):\n"
        msg = msg .. "5 basic blessings: lose ~3-4 levels\n"
        msg = msg .. "6 blessings (with VIP): lose ~1 level!"
        
        local window = ModalWindow({})
        window:setTitle("VIP Blessing - Locked")
        window:setMessage(msg)
        window:addButtons("OK")
        window:setDefaultEnterButton("OK")
        window:setDefaultEscapeButton("OK")
        window:sendToPlayer(player)
        
        altarPos:sendMagicEffect(CONST_ME_POFF)
        return true
    end
    
    -- Verificar se ja tem a blessing VIP
    if player:hasBlessing(6) then
        local msg = "=== VIP BLESSING ===\n\n"
        msg = msg .. "MAXIMUM PROTECTION ACTIVE\n\n"
        msg = msg .. "You already have the VIP blessing!\n\n"
        msg = msg .. "[X] Basic Blessing 1\n"
        msg = msg .. "[X] Basic Blessing 2\n"
        msg = msg .. "[X] Basic Blessing 3\n"
        msg = msg .. "[X] Basic Blessing 4\n"
        msg = msg .. "[X] Basic Blessing 5\n"
        msg = msg .. "[X] VIP Blessing (Premium)\n\n"
        msg = msg .. "EXP/Skill Loss: Only 1%\n"
        msg = msg .. "You have maximum protection!"
        
        local window = ModalWindow({})
        window:setTitle("VIP Blessing - Complete")
        window:setMessage(msg)
        window:addButtons("OK")
        window:setDefaultEnterButton("OK")
        window:setDefaultEscapeButton("OK")
        window:sendToPlayer(player)
        
        altarPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        return true
    end
    
    -- Calcular preco
    local level = player:getLevel()
    local price = calculateVipBlessPrice(level)
    local totalMoney = player:getMoney() + player:getBankBalance()
    
    -- Montar mensagem
    local msg = "=== VIP BLESSING ===\n\n"
    msg = msg .. "BASIC BLESSINGS:\n"
    msg = msg .. "[X] Basic Blessing 1-5 (Complete)\n\n"
    msg = msg .. "VIP BLESSING:\n"
    msg = msg .. "[ ] VIP Blessing (Premium Protection)\n\n"
    msg = msg .. "===========================\n\n"
    msg = msg .. "EXAMPLE (Level 700):\n"
    msg = msg .. "Current (5 blessings): lose ~3-4 levels\n"
    msg = msg .. "With VIP (6 blessings): lose ~1 level!\n\n"
    msg = msg .. "===========================\n\n"
    msg = msg .. "PURCHASE INFO:\n"
    msg = msg .. "Your Level: " .. level .. "\n"
    msg = msg .. "VIP Blessing Price: " .. formatGold(price) .. "\n"
    msg = msg .. "Your Gold: " .. formatGold(totalMoney) .. "\n\n"
    
    if totalMoney < price then
        msg = msg .. "WARNING: Insufficient gold!\n"
        msg = msg .. "You need " .. formatGold(price - totalMoney) .. " more gold."
    else
        msg = msg .. "Proceed with purchase?"
    end
    
    -- Criar modal window
    local window = ModalWindow({})
    window:setTitle("VIP Blessing Purchase")
    window:setMessage(msg)
    window:addButtons("Confirm", "Cancel")
    window:setDefaultEnterButton("Confirm")
    window:setDefaultEscapeButton("Cancel")
    
    -- Callback de confirmacao
    window:setDefaultCallback(function(button)
        if not button or button.text ~= "Confirm" then
            return
        end
        
        -- Revalidar condicoes
        local stillHasAllBasic = true
        for i = 1, 5 do
            if not player:hasBlessing(i) then
                stillHasAllBasic = false
                break
            end
        end
        
        if not stillHasAllBasic then
            player:sendCancelMessage("You need all 5 basic blessings first!")
            altarPos:sendMagicEffect(CONST_ME_POFF)
            return
        end
        
        if player:hasBlessing(6) then
            player:sendCancelMessage("You already have the VIP blessing!")
            altarPos:sendMagicEffect(CONST_ME_POFF)
            return
        end
        
        local currentMoney = player:getMoney() + player:getBankBalance()
        if currentMoney < price then
            player:sendCancelMessage("You need " .. formatGold(price) .. " to purchase the VIP blessing.")
            altarPos:sendMagicEffect(CONST_ME_POFF)
            return
        end
        
        -- Executar compra
        purchaseVipBlessing(player, price, altarPos)
    end)
    
    window:sendToPlayer(player)
    return true
end

-- Funcao principal do altar/alavanca
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not player then
        return false
    end
    
    -- Toggle lever se for alavanca (IDs 1945/1946)
    if item.itemid == 1945 then
        item:transform(1946)
    elseif item.itemid == 1946 then
        item:transform(1945)
    end
    
    local altarPos = item:getPosition()
    
    -- Efeito visual ao usar o altar
    altarPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
    
    -- Abre a modal window
    return openVipBlessModal(player, altarPos)
end
