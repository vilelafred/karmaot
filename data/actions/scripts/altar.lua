function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    print("[SACRIFICIAL ALTAR] Script iniciada pelo jogador: " .. player:getName())
    
    -- Posições dos altares sacrificiais
    local altar1Position = Position(32374, 32140, 8) -- Altar para Sudden Death (ID: 2612)
    local altar2Position = Position(32376, 32140, 8) -- Altar para Ultimate Healing (ID: 2613)
    local leverPosition = Position(32376, 32141, 8)  -- Alavanca (ID: 1946, Action ID: 9001)
    local teleportPosition = Position(32375, 32138, 8) -- Destino do teleporte (white stone tile)
    
    print("[SACRIFICIAL ALTAR] Posições configuradas")
    
    -- IDs dos itens necessários
    local suddenDeathId = 2268
    local ultimateHealingId = 6675
    local altarId1 = 2612
    local altarId2 = 2613
    local leverId = 1946
    
    -- Verificar se as runas estão nas posições corretas dos altares
    local tile1 = Tile(altar1Position)
    local tile2 = Tile(altar2Position)
    
    print("[SACRIFICIAL ALTAR] Verificando tile 1: " .. (tile1 and "existe" or "nil"))
    print("[SACRIFICIAL ALTAR] Verificando tile 2: " .. (tile2 and "existe" or "nil"))
    
    local suddenDeathFound = false
    local ultimateHealingFound = false
    
    -- Verificar se Sudden Death está no altar 1
    if tile1 then
        local items = tile1:getItems()
        print("[SACRIFICIAL ALTAR] Tile 1 tem " .. #items .. " itens")
        for i = 1, #items do
            print("[SACRIFICIAL ALTAR] Item " .. i .. " no tile 1: ID " .. items[i]:getId())
            if items[i]:getId() == suddenDeathId then
                suddenDeathFound = true
                print("[SACRIFICIAL ALTAR] Sudden Death encontrada no altar 1")
            end
        end
    end
    
    -- Verificar se Ultimate Healing está no altar 2
    if tile2 then
        local items = tile2:getItems()
        print("[SACRIFICIAL ALTAR] Tile 2 tem " .. #items .. " itens")
        for i = 1, #items do
            print("[SACRIFICIAL ALTAR] Item " .. i .. " no tile 2: ID " .. items[i]:getId())
            if items[i]:getId() == ultimateHealingId then
                ultimateHealingFound = true
                print("[SACRIFICIAL ALTAR] Ultimate Healing encontrada no altar 2")
            end
        end
    end
    
    -- Verificar se ambas as runas estão presentes
    if not suddenDeathFound then
        print("[SACRIFICIAL ALTAR] Sudden Death não encontrada no altar 1")
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você precisa colocar uma Sudden Death rune no primeiro altar (posição 32374, 32140, 8).")
        return false
    end
    
    if not ultimateHealingFound then
        print("[SACRIFICIAL ALTAR] Ultimate Healing não encontrada no altar 2")
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você precisa colocar uma Ultimate Healing rune no segundo altar (posição 32376, 32140, 8).")
        return false
    end
    
    print("[SACRIFICIAL ALTAR] Ambas as runas estão nos altares corretos")
    
    print("[SACRIFICIAL ALTAR] Iniciando processo da alavanca")
    
    -- Aguardar um momento antes de ativar o teleporte
    addEvent(function()
        print("[SACRIFICIAL ALTAR] Verificando alavanca na posição: " .. leverPosition.x .. ", " .. leverPosition.y .. ", " .. leverPosition.z)
        
        local leverTile = Tile(leverPosition)
        print("[SACRIFICIAL ALTAR] Lever tile: " .. (leverTile and "existe" or "nil"))
        
        if leverTile then
            local items = leverTile:getItems()
            print("[SACRIFICIAL ALTAR] Lever tile tem " .. #items .. " itens")
            for i = 1, #items do
                print("[SACRIFICIAL ALTAR] Item " .. i .. " no lever tile: ID " .. items[i]:getId())
            end
            
            -- Procurar qualquer alavanca (ID 1945 ou 1946) ou ativar mesmo se não encontrar
            local leverFound = false
            for i = 1, #items do
                if items[i]:getId() == 1945 or items[i]:getId() == 1946 then
                    leverFound = true
                    print("[SACRIFICIAL ALTAR] Alavanca encontrada com ID: " .. items[i]:getId())
                    break
                end
            end
            
            -- Mesmo que não encontre alavanca, continuar o ritual (pode ser que seja um item ground)
            if not leverFound then
                print("[SACRIFICIAL ALTAR] Alavanca não encontrada como item, mas continuando ritual...")
            end
            
            print("[SACRIFICIAL ALTAR] Ativando teleporte do ritual")
            
            -- Teletransportar o jogador após um breve delay
            addEvent(function()
                print("[SACRIFICIAL ALTAR] Teletransportando jogador para: " .. teleportPosition.x .. ", " .. teleportPosition.y .. ", " .. teleportPosition.z)
                
                local oldPosition = player:getPosition()
                player:teleportTo(teleportPosition)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você foi teletransportado pelo ritual sacrificial!")
                
                -- Efeito visual no teleporte
                teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
                oldPosition:sendMagicEffect(CONST_ME_TELEPORT)
                
                -- Remover as runas dos altares após o teleporte
                addEvent(function()
                    print("[SACRIFICIAL ALTAR] Removendo runas dos altares")
                    
                    -- Remover Sudden Death do primeiro altar
                    local tile1 = Tile(altar1Position)
                    if tile1 then
                        local items = tile1:getItems()
                        for i = 1, #items do
                            if items[i]:getId() == suddenDeathId then
                                items[i]:remove()
                                print("[SACRIFICIAL ALTAR] Sudden Death removida do altar 1")
                                break
                            end
                        end
                    end
                    
                    -- Remover Ultimate Healing do segundo altar
                    local tile2 = Tile(altar2Position)
                    if tile2 then
                        local items = tile2:getItems()
                        for i = 1, #items do
                            if items[i]:getId() == ultimateHealingId then
                                items[i]:remove()
                                print("[SACRIFICIAL ALTAR] Ultimate Healing removida do altar 2")
                                break
                            end
                        end
                    end
                    
                    print("[SACRIFICIAL ALTAR] Ritual completamente finalizado")
                end, 500)
            end, 1000)
            
        else
            print("[SACRIFICIAL ALTAR] ERRO: Tile da alavanca não existe")
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "Posição da alavanca não existe.")
            -- Mesmo assim, vamos tentar teleportar
            addEvent(function()
                print("[SACRIFICIAL ALTAR] Tentando teleporte mesmo sem tile da alavanca")
                player:teleportTo(teleportPosition)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ritual realizado com sucesso!")
                teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
            end, 1000)
        end
    end, 2000)
    
    -- Efeitos visuais nos altares
    altar1Position:sendMagicEffect(CONST_ME_HOLYAREA)
    altar2Position:sendMagicEffect(CONST_ME_HOLYAREA)
    
    print("[SACRIFICIAL ALTAR] Efeitos visuais aplicados")
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ritual iniciado! As runas foram colocadas nos altares sacrificiais...")
    
    print("[SACRIFICIAL ALTAR] Script finalizada com sucesso")
    return true
end
