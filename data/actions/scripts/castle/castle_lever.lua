-- Sistema de Alavanca do Castle 24h
-- Alavanca ID: 1945
-- Portas AID: 8881

-- Storage IDs para o sistema
local CASTLE_OWNER_GUILD = 7001
local CASTLE_OWNER_TIME = 7002
-- Removido: não precisamos mais do controle de portas

function onUse(cid, item, fromPosition, itemEx, toPosition)
    local playerName = getPlayerName(cid)
    local playerGuildName = getPlayerGuildName(cid)
    local currentTime = os.time()

               -- Verificar se o player está em uma guild
           if not playerGuildName or playerGuildName == "" or playerGuildName == "Nenhum" then
               doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You need to be in a guild to use the castle lever.')
        doSendMagicEffect(fromPosition, 3)
        return false
    end

    -- Verificar se o castle está sendo dominado
    local castleOwnerGuild = getGlobalStorageValue(CASTLE_OWNER_GUILD)
    local castleOwnerTime = getGlobalStorageValue(CASTLE_OWNER_TIME)

         -- Se o castle não está sendo dominado
     if castleOwnerGuild == -1 or castleOwnerTime == -1 then
         -- Iniciar domínio do castle
         setGlobalStorageValue(CASTLE_OWNER_GUILD, playerGuildName)
         setGlobalStorageValue(CASTLE_OWNER_TIME, currentTime)
         -- Removido: não precisamos mais do controle de portas
 
                        local alertMessage = '[ BLESS CASTLE 24h ]\n\nThe guild [ ' .. playerGuildName .. ' ] has dominated the Bless Castle 24h!\nThe castle now belongs to them!'
                broadcastMessage(alertMessage, MESSAGE_EVENT_ADVANCE)
                
                doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You activated the lever! Your guild now dominates the castle!')
        doSendMagicEffect(fromPosition, 206)
        
        -- Efeito visual nas portas (opcional)
        doSendMagicEffect(toPosition, 206)
        
        return true
    end

         -- Se o castle está sendo dominado
     if castleOwnerGuild == playerGuildName then
         -- Guild dominante - portas sempre abertas
         doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'The castle doors are always open for invasion. Other guilds can try to take control!')
         doSendMagicEffect(fromPosition, 206)
         
         local alertMessage = '[ BLESS CASTLE 24h ]\n\nThe dominant guild [ ' .. playerGuildName .. ' ] checked the castle status.\nThe castle is always open for invasion!'
         broadcastMessage(alertMessage, MESSAGE_EVENT_ADVANCE)
         else
         -- Guild inimiga tentando tomar o domínio
         setGlobalStorageValue(CASTLE_OWNER_GUILD, playerGuildName)
         setGlobalStorageValue(CASTLE_OWNER_TIME, currentTime)
         -- Removido: não precisamos mais do controle de portas
         
                        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You activated the lever! Your guild has taken control of the castle from guild [ ' .. castleOwnerGuild .. ' ]!')
                doSendMagicEffect(fromPosition, 206)
                
                local alertMessage = '[ BLESS CASTLE 24h ]\n\nThe guild [ ' .. playerGuildName .. ' ] has taken control of the castle from guild [ ' .. castleOwnerGuild .. ' ]!\nThe castle now belongs to them!'
        broadcastMessage(alertMessage, MESSAGE_EVENT_ADVANCE)
    end

    return true
end
