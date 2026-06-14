function onStartup()
    -- Posições originais
    local workbenchPositions = {
        Position(32394, 32191, 7), -- Original
        Position(32389, 32191, 6), -- Nova
        Position(32399, 32191, 6), -- Nova
        Position(32108, 32177, 7)  -- Nova (pedido)
    }
    
    local anvilPositions = {
        Position(32397, 32191, 7), -- Original
        Position(32392, 32191, 6), -- Nova
        Position(32402, 32191, 6), -- Nova
        Position(32111, 32177, 7)  -- Nova (pedido)
    }

    -- Configurar workbenches
    for _, workbenchpos in ipairs(workbenchPositions) do
        local workbenchTile = Tile(workbenchpos)
        local workbench = workbenchTile and workbenchTile:getItemById(6047)
        
        if workbench and not workbench:isContainer() then
            workbench:remove()
            Game.createContainer(6047, 1, workbenchpos)
        end
    end

    -- Configurar anvils
    for _, anvilpos in ipairs(anvilPositions) do
        local anvilTile = Tile(anvilpos)
        local anvil = anvilTile and anvilTile:getItemById(6038)
        
        if anvil and not anvil:isContainer() then
            anvil:remove()
            Game.createContainer(6038, 1, anvilpos)
        end
    end

    return true
end
