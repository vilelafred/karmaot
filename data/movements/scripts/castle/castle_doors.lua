-- Sistema de Bloqueio do Castle 24h
-- Tile AID: 8881 (bloqueia passagem para guilds inimigas)

-- Storage IDs para o sistema
local CASTLE_OWNER_GUILD = 7001
local CASTLE_OWNER_TIME = 7002
-- Removido: não precisamos mais do controle de portas

function onStepIn(cid, item, pos)
    -- Verificar se é o tile correto (AID 8881)
    if item.actionid ~= 8881 then
        return true
    end
    
    local playerName = getPlayerName(cid)
    local playerGuildName = getPlayerGuildName(cid)
    local currentTime = os.time()

    -- Verificar se o player está em uma guild
    if not playerGuildName or playerGuildName == "" or playerGuildName == "Nenhum" then
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You need to be in a guild to pass through the castle doors.')
        doSendMagicEffect(pos, 3)
        local newPos = {x = pos.x + 1, y = pos.y, z = pos.z}
        doTeleportThing(cid, newPos, false)
        return true
    end

    -- Verificar se o castle está sendo dominado
    local castleOwnerGuild = getGlobalStorageValue(CASTLE_OWNER_GUILD)
    local castleOwnerTime = getGlobalStorageValue(CASTLE_OWNER_TIME)

    -- Se o castle não está sendo dominado
    if castleOwnerGuild == -1 or castleOwnerGuild == "" or castleOwnerTime == -1 then
        -- Permitir acesso para qualquer guild
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You passed through the castle doors. The castle is free to be dominated!')
        doSendMagicEffect(pos, 206)
        return true
    end

    -- Se o castle está sendo dominado - portas das hunts restritas APENAS para guild dominante
    if castleOwnerGuild == playerGuildName then
        -- Guild dominante passando
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You passed through the doors of your castle.')
        doSendMagicEffect(pos, 206)
        return true
    else
        -- Guild inimiga bloqueada
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, 'You need to be a member of the guild that owns the castle to pass through this door.')
        doSendMagicEffect(pos, 3)
        local newPos = {x = pos.x + 1, y = pos.y, z = pos.z}
        doTeleportThing(cid, newPos, false)
        return true
    end


end
