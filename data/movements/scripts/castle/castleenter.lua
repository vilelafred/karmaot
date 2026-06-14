-- by Nottinghster
-- Sistema de Domínio do Castle 24h

-- Storage IDs para o sistema
local CASTLE_OWNER_GUILD = 7001
local CASTLE_OWNER_TIME = 7002
-- Removido: não precisamos mais do controle de portas

function onStepIn(cid, item, pos)
    local bridgeActionID = 7002 -- ActionID do piso de entrada

    if item.actionid == bridgeActionID then
        local playerName = getPlayerName(cid)
        local playerGuildName = getPlayerGuildName(cid)
        local currentTime = os.time()

        -- Verificar se o player está em uma guild
                       if not playerGuildName or playerGuildName == "" or playerGuildName == "Nenhum" then
                   doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You need to be in a guild to invade the Bless Castle 24h.')
            doSendMagicEffect(pos, 3)
            local newPos = {x = pos.x, y = pos.y + 3, z = pos.z}
            doTeleportThing(cid, newPos, false)
            return true
        end

        -- Verificar se o castle está sendo dominado
        local castleOwnerGuild = getGlobalStorageValue(CASTLE_OWNER_GUILD)
        local castleOwnerTime = getGlobalStorageValue(CASTLE_OWNER_TIME)
        -- Removido: não precisamos mais do controle de portas

                 -- Se o castle não está sendo dominado
         if castleOwnerGuild == -1 or castleOwnerTime == -1 then
                                -- Permitir acesso para qualquer guild
                    local alertMessage = '[ BLESS CASTLE 24h ]\n\nThe player [ ' .. playerName .. ' ] from guild [ ' .. playerGuildName .. ' ] is invading the Bless Castle 24h. The castle is free to be dominated!'
            broadcastMessage(alertMessage, MESSAGE_EVENT_ADVANCE)
            doSendMagicEffect(pos, 206)
            return true
        end

        -- Se o castle está sendo dominado - entrada sempre aberta
        if castleOwnerGuild == playerGuildName then
            -- Guild dominante entrando
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'Welcome to your castle! You have full access.')
            doSendMagicEffect(pos, 206)
        else
            -- Guild inimiga tentando invadir
            local alertMessage = '[ BLESS CASTLE 24h ]\n\nThe player [ ' .. playerName .. ' ] from guild [ ' .. playerGuildName .. ' ] is trying to invade the castle dominated by guild [ ' .. castleOwnerGuild .. ' ].'
            broadcastMessage(alertMessage, MESSAGE_EVENT_ADVANCE)
            doSendMagicEffect(pos, 206)
        end
    end

    return true
end
