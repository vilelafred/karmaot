-- Sistema da Porta Principal do Castle 24h
-- Porta UniqueID: 7001 (sempre aberta para invasão)

function onUse(cid, item, frompos, item2, topos)
    local playerName = getPlayerName(cid)
    local playerGuildName = getPlayerGuildName(cid)

    if item.uid == 7001 then
        -- Verificar se o player está em uma guild
        if not playerGuildName or playerGuildName == "" or playerGuildName == "Nenhum" then
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You need to be in a guild to pass through the castle doors.')
            return false
        end

        -- Teleportar
        local pos = getPlayerPosition(cid)
        local topos
        local isEntering = false
        
        if pos.y == 31627 then
            -- Saindo do castelo (indo para fora)
            topos = {x=32300, y=31629, z=7}
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You left the castle through the main doors.')
        elseif pos.y == 31629 then
            -- Entrando no castelo (indo para dentro)
            topos = {x=32300, y=31627, z=7}
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You entered the castle through the main doors. The castle is open for invasion!')
            isEntering = true
        else
            return false
        end
        
        doSendMagicEffect(frompos, 206)
        
        doTeleportThing(cid, topos)
        doSendMagicEffect(topos, 11)
        return true
    end

    return false
end
