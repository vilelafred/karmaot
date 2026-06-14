-- ===================================================
-- REMOVE BLESSINGS - TalkAction
-- ===================================================
-- Comando: /removebless [playerName]
-- Remove todas as 6 blessings (1-5 basicas + 6 VIP)
-- Uso: /removebless (remove suas proprias blessings)
--      /removebless PlayerName (remove de outro player - requer GM)

function onSay(player, words, param)
    -- Verificar se é GM/Admin
    if not player:getGroup():getAccess() then
        player:sendCancelMessage("You don't have permission to use this command.")
        return false
    end
    
    local targetPlayer = nil
    
    -- Se nao especificou nome, remove do proprio player
    if param == "" then
        targetPlayer = player
    else
        -- Procurar player online
        targetPlayer = Player(param)
        
        if not targetPlayer then
            player:sendCancelMessage("Player '" .. param .. "' is not online.")
            return false
        end
    end
    
    local playerName = targetPlayer:getName()
    local removedCount = 0
    
    -- Remover todas as 6 blessings
    for i = 1, 6 do
        if targetPlayer:hasBlessing(i) then
            targetPlayer:removeBlessing(i)
            removedCount = removedCount + 1
        end
    end
    
    if removedCount > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "Successfully removed " .. removedCount .. " blessing(s) from player " .. playerName .. ".")
        
        targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
            "All your blessings have been removed by " .. player:getName() .. ".")
        
        -- Log
        print(string.format("[RemoveBless] %s removed %d blessings from %s", 
            player:getName(), removedCount, playerName))
    else
        player:sendCancelMessage(playerName .. " doesn't have any blessings.")
    end
    
    return false
end

