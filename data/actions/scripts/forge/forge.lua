function onUse(player, item, fromPosition, item2, toPosition)

    if item:getUniqueId() == 30020 then -- BOOK 1
        local text = "Disenchanting items using the Workbench:"
        text = text .. "\r\r" .. "\n1. Place rare, epic or legendary items in the Workbench."
        text = text .. "\r" .. "\n2. Use a Smithing Hammer on the Workbench."
        text = text .. "\r\r" .. "\n\nThis will DESTROY the item and extract some magic powder.\n"
        text = text .. "\r\r" .. "  \n Ex.:\n1 Magic Powder"
        text = text .. "\r" .. ":   Rare\n3 Magic Powder"
        text = text .. "" .. ":   Epic\n5 Magic Powder:  Legendary"
        text = text .. "\r\r" .. "\n\n(Smithing Hammers can be purchased from Carl)"
        player:showTextDialog(item:getId(), text)

    elseif item:getUniqueId() == 30021 then -- BOOK 2
        local text = "Enchanting items using the Anvil:"
        text = text .. "\r\r" .. "\n1. Place a regular item in the Anvil."
        text = text .. "\r" .. "\n2. Use a Smithing Hammer on the Anvil."
        text = text .. "\r\r" .. "\n\nThis requires 25 Magic Powder and will attempt to enchant the item."
        text = text .. "\r\r" .. "\n\n20 Magic Powder is wasted if your enchantment fails."
        player:showTextDialog(item:getId(), text)

    elseif item:getId() == 6562 or item:getId() == 4857 then -- Smithing Hammer

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
                if workbench and workbench:isContainer() then
                    local disenchantItem = Container(workbench.uid):getItem(0)
                    if disenchantItem then
                        local disenchantOwner = disenchantItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
                        if disenchantOwner == player:getId() then
                            local desc = disenchantItem:getAttribute(ITEM_ATTRIBUTE_ARTICLE)
                            local sulfurcount = 0
                            if desc:find("rare") then
                                sulfurcount = 1
                            elseif desc:find("epic") then
                                sulfurcount = 3
                            elseif desc:find("legendary") then
                                sulfurcount = 5
                            elseif desc:find("dawnbreaker") then
                                sulfurcount = 100
                            end

                            if sulfurcount > 0 then
                                disenchantItem:remove()
                                player:addItem(5838, sulfurcount)
                                workbenchpos:sendMagicEffect(CONST_ME_FIREAREA)

                                -- Se havia evento para mover pro depot, cancela
                                if Game.getStorageValue(30020) then
                                    stopEvent(Game.getStorageValue(30020))
                                    Game.setStorageValue(30020, -1)
                                end
                            end
                        else
                            player:sendCancelMessage("The item on the workbench does not belong to you.")
                        end
                    else
                        player:sendCancelMessage("There is nothing in the workbench to disenchant.")
                    end
                end
                return true
            end
        end

        -- Verificar se está usando em um anvil
        for _, anvilpos in ipairs(anvilPositions) do
            if toPosition == anvilpos then
                local anvil = Tile(anvilpos):getItemById(6038)
                if anvil and anvil:isContainer() then
                    local enchantItem = Container(anvil.uid):getItem(0)
                    if enchantItem then
                        local enchantOwner = enchantItem:getAttribute(ITEM_ATTRIBUTE_OWNER)
                        local desc = enchantItem:getDescription()
                        if enchantOwner == player:getId() then
                            if desc:find("rare") or desc:find("epic") or desc:find("legendary") then
                                player:sendCancelMessage("This item has already been enchanted, please remove it from the anvil.")
                            else
                                local sulfurcount = player:getItemCount(5838)
                                if sulfurcount >= 25 then
                                    if math.random(1, 2) == 2 then
                                        rollRarity(enchantItem, true) -- forge and attribute errors are 1`00% disappeared if the crash happened again you have to let me know because this is my job but im sure crash of this type won't repeat itself it gonna be different loveu brov <3 what next :p3
                                        anvilpos:sendMagicEffect(6)
                                        player:removeItem(5838, 25)
                                    else
                                        player:sendCancelMessage("Your attempt to enchant the item has failed.")
                                        anvilpos:sendMagicEffect(CONST_ME_POFF)
                                        player:removeItem(5838, 20)
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
