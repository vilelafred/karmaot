function onUse(player, item, fromPosition, item2, toPosition)
    print(string.format("Player %d used item %d at position %s.", player:getId(), item:getId(), toPosition))

    if item:getUniqueId() == 30020 then -- BOOK 1
        -- Código relacionado à Workbench...
    elseif item:getUniqueId() == 30021 then -- BOOK 2
        -- Código relacionado ao Anvil...
    elseif item:getId() == 6562 then
        print(string.format("Entered the condition for Item 6562 at position %s.", toPosition))

        -- Posições de workbench e anvil
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

        -- Verificar se está usando em um workbench
        for _, workbenchpos in ipairs(workbenchPositions) do
            if toPosition == workbenchpos then
                print("Inside the condition for Item 6562 related to Workbench")
                local workbench = Tile(workbenchpos):getItemById(6047)
                if workbench and workbench:isContainer() then
                    -- Código da Workbench...
                end
                return true
            end
        end

        -- Verificar se está usando em um anvil
        for _, anvilpos in ipairs(anvilPositions) do
            if toPosition == anvilpos then
                print("Inside the condition for Item 6562 related to Anvil")
                local anvil = Tile(anvilpos):getItemById(6038)

                if anvil:isContainer() then
                    local enchantItem = Container(anvil.uid):getItem(0)
                    local enchantOwner = enchantItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
                    local enchantDesc = enchantItem:getDescription()
                    local smithUser = player:getId()

                    print(string.format("Anvil found: %s", anvil))
                    print("Player used the item on the Anvil")
                    print(string.format("Item on Anvil: %s", enchantItem))
                    print(string.format("Item ID: %d", enchantItem:getId()))
                    print(string.format("Item Description: %s", enchantDesc))

                    if enchantItem then
                        if enchantOwner == smithUser then
                            if enchantDesc:find "rare" or enchantDesc:find "epic" or enchantDesc:find "legendary" then
                                player:sendCancelMessage("This item has already been enchanted, please remove it from the anvil.")
                            else
                                local sulfurcount = player:getItemCount(5838)

                                if sulfurcount >= 25 then
                                    if math.random(1, 2) == 2 then
                                        rollRarity(enchantItem, true)
                                        anvilpos:sendMagicEffect(6)
                                        player:removeItem(5838, 25)

                                        print("Anvil code executed successfully")
                                    else
                                        player:sendCancelMessage("Your attempt to enchant the item has failed.")
                                        anvilpos:sendMagicEffect(CONST_ME_POFF)
                                        player:removeItem(5838, 10)
                                    end
                                else
                                    player:sendCancelMessage("You do not have enough magic powder to attempt an enchantment.")
                                end
                            end
                        else
                            player:sendCancelMessage("The item on the anvil does not belong to you.")
                        end
                    end
                end
                return true
            end
        end
    elseif item:getId() == 4857 then
        -- Posições de workbench e anvil
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

        -- Verificar se está usando em um workbench
        for _, workbenchpos in ipairs(workbenchPositions) do
            if toPosition == workbenchpos then
                local workbench = Tile(workbenchpos):getItemById(6047)
                if workbench:isContainer() then
                    local disenchantItem = Container(workbench.uid):getItem(0)
                    local disenchantOwner = disenchantItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
                    local smithUser = player:getId()
                    if disenchantItem then
                        if disenchantOwner == smithUser then
                            local disenchantDesc = disenchantItem:getAttribute(ITEM_ATTRIBUTE_ARTICLE)
                            local sulfurcount = 0
                            if disenchantDesc:find "rare" then
                                sulfurcount = 1
                            elseif disenchantDesc:find "epic" then
                                sulfurcount = 3
                            elseif disenchantDesc:find "legendary" then
                                sulfurcount = 5
                            elseif disenchantDesc:find "dawnbreaker" then
                                sulfurcount = 100
                            end
                            if sulfurcount ~= 0 then
                                disenchantItem:remove()
                                player:addItem(5838, sulfurcount)
                                workbenchpos:sendMagicEffect(CONST_ME_FIREAREA)
                                
                                -- Stop the event that would send unattended items to players depot (events/scripts/player.lua)
                                -- function Player.onMoveItem(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
                                if Game.getStorageValue(30020) then
                                    stopEvent(Game.getStorageValue(30020))
                                    Game.setStorageValue(30020, -1)
                                end
                                -- Destroy item or just remove rarity?
                                -- local vanillaitem = workbench:addItem(disenchantItem:getId())
                            end
                        end
                    end
                end
                return true
            end
        end

        -- Verificar se está usando em um anvil
        for _, anvilpos in ipairs(anvilPositions) do
            if toPosition == anvilpos then
                local anvil = Tile(anvilpos):getItemById(6038)
                if anvil:isContainer() then
                    local enchantItem = Container(anvil.uid):getItem(0)
                    local enchantOwner = enchantItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
                    local enchantDesc = enchantItem:getDescription()
                    local smithUser = player:getId()
                    if enchantItem then
                        if enchantOwner == smithUser then
                            if enchantDesc:find "rare" or enchantDesc:find "epic" or enchantDesc:find "legendary" then
                                player:sendCancelMessage("This item has already been enchanted, please remove it from the anvil.")
                            else
                                local sulfurcount = player:getItemCount(5838)
                                if sulfurcount >= 25 then
                                    if math.random(1,2) == 2 then
                                        rollRarity(enchantItem, true)
                                        anvilpos:sendMagicEffect(6)
                                        player:removeItem(5838, 25)
                                    else
                                        player:sendCancelMessage("Your attempt to enchant the item has failed.")
                                        anvilpos:sendMagicEffect(CONST_ME_POFF)
                                        player:removeItem(5838, 10)
                                    end
                                else
                                    player:sendCancelMessage("You do not have enough magic powder to attempt an enchantment.")
                                end
                            end
                        else
                            player:sendCancelMessage("The item on the anvil does not belong to you.")
                        end
                    end
                end
                return true
            end
        end
    end
 return true
end