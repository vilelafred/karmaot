-- Script de teste para o Auto Loot Sell
-- Use este comando para testar: !testautosell

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        player:sendCancelMessage("Você não tem permissão para usar este comando.")
        return false
    end
    
    -- Teste 1: Verificar se as funções nativas existem
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "=== TESTE AUTO SELL ===")
    
    if player.getBackpackItemCount then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "✓ Função getBackpackItemCount existe")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "✗ Função getBackpackItemCount NÃO existe")
    end
    
    if player.removeBackpackItem then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "✓ Função removeBackpackItem existe")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "✗ Função removeBackpackItem NÃO existe")
    end
    
    -- Teste 2: Verificar backpack
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if backpack then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "✓ Backpack encontrada - Tamanho: " .. backpack:getSize())
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "✗ Backpack NÃO encontrada")
    end
    
    -- Teste 3: Verificar dinheiro atual
    local currentMoney = player:getMoney()
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Dinheiro atual: " .. currentMoney .. " gp")
    
    -- Teste 4: Verificar alguns itens vendáveis
    local testItems = {2463, 2464, 2465} -- plate armor, chain armor, brass armor
    for _, itemId in ipairs(testItems) do
        local count = 0
        if player.getBackpackItemCount then
            count = player:getBackpackItemCount(itemId)
        else
            -- Fallback manual
            local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
            if backpack then
                for i = 0, backpack:getSize()-1 do
                    local item = backpack:getItem(i)
                    if item and item:getId() == itemId then
                        count = count + item:getCount()
                    end
                end
            end
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item " .. itemId .. ": " .. count .. " unidades")
    end
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "=== FIM DO TESTE ===")
    return false
end
