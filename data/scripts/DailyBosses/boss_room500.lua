local config = {
    actionId = 20999,
    bossName = "Terragor",
    bossPosition = Position(31823, 31305, 7), 
    bossArea = {
        fromPos = Position(31812, 31293, 7), 
        toPos = Position(31835, 31312, 7),
        entrancePos = Position(31824, 31298, 7),
        exitPosition = Position(31824, 31285, 7)
    },
    allowedAnyParticipantsCount = true,
    participantsPos = {
        Position(31824, 31290, 7),
        Position(31824, 31289, 7),
        Position(31824, 31288, 7),
        Position(31824, 31287, 7),       
    },
    attempts = {
        level = 500,
        storage = 2255,
        seconds = 72000 -- 24h
    },
    createTeleportPos = Position(31816, 31302, 7),
    teleportToPosition = Position(31824, 31285, 7),
    teleportRemoveSeconds = 60,
    kickParticipantAfterSeconds = 25 * 60,
    leverIds = {1945, 1946}
}

local function getSpectators(onlyPlayers)
    local diffX = math.ceil((config.bossArea.toPos.x - config.bossArea.fromPos.x) / 2)
    local diffY = math.ceil((config.bossArea.toPos.y - config.bossArea.fromPos.y) / 2)
    local centerPosition = config.bossArea.fromPos + Position(diffX, diffY, 0)
    return Game.getSpectators(centerPosition, false, onlyPlayers, diffX, diffX, diffY, diffY)
end

local action = Action()

function action.onUse(player, item, fromPos, target, toPos, isHotkey)
    -- Primeira verificação: checar se sala já está ocupada (ANTES de qualquer coisa)
    if #getSpectators(true) > 0 then
        player:sendCancelMessage("At this time the room is occupied, please try again later.")
        return true
    end

    local participants = {}

    -- Verificar se todos os jogadores têm os 4 sulphurs e não fizeram o boss nas últimas 24h
    for _, pos in pairs(config.participantsPos) do
        local tile = Tile(pos)
        if not tile then
            error("[Warning - Tile not found]")
        end

        local creature = tile:getTopCreature()
        if creature and creature:isPlayer() then
            if creature:getLevel() < config.attempts.level then
                player:sendCancelMessage(string.format("%s needs to be at least level %d to enter.", creature:getName(), config.attempts.level))
                return true
            end

            local cooldown = creature:getStorageValue(config.attempts.storage)
            if cooldown > os.time() then
                local remaining = cooldown - os.time()
			player:sendCancelMessage(string.format("%s must wait %d hours to challenge this boss again.", creature:getName(), math.ceil(remaining / 3600)))
                return true
            end

            if creature:getItemCount(6846) < 4 then
                player:sendCancelMessage("All players need 4 Magic Sulphurs to pull the lever.")
                return true
            end

            table.insert(participants, creature)
        end
    end

    -- Remover 4 sulphurs de cada jogador (só depois de todas as verificações)
    for _, participant in ipairs(participants) do
        participant:removeItem(6846, 4)
    end

    stopEvent(config.kickEventId)

    -- Limpar monstros antigos (só por segurança)
    for _, monsterSpectator in pairs(getSpectators()) do
        monsterSpectator:remove()
    end

    -- Criar o boss
    local boss = Game.createMonster(config.bossName, config.bossPosition)
    if not boss then
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end
    boss:registerEvent("bossSystemDeath")

    -- Teleportar os players para a sala e registrar tentativa
    for _, participant in pairs(participants) do
        participant:getPosition():sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos, false)
        participant:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
    end

    -- Evento de expulsão automática após X minutos
    config.kickEventId = addEvent(function ()
        for _, spectator in pairs(getSpectators()) do
            if spectator:isPlayer() then
                spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                spectator:teleportTo(config.bossArea.exitPosition, false)
                spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It's been a long time and you haven't managed to defeat the boss.")
            else
                spectator:remove()
            end
        end
    end, config.kickParticipantAfterSeconds * 1000)

    item:transform(item:getId() == config.leverIds[1] and config.leverIds[2] or config.leverIds[1])
    return true
end

action:aid(config.actionId)
action:register()

-- Evento de morte do boss
local creatureEvent = CreatureEvent("bossSystemDeath")

function creatureEvent.onDeath()
    stopEvent(config.kickEventId)

    -- Criar teleporte de saída
    local teleport = Game.createItem(1387, 1, config.createTeleportPos)
    if teleport then
        teleport:setDestination(config.teleportToPosition)
        addEvent(function ()
            local tile = Tile(config.createTeleportPos)
            if tile then
                local teleport = tile:getItemById(1387)
                if teleport then
                    teleport:remove()
                    config.teleportToPosition:sendMagicEffect(CONST_ME_POFF)
                end
            end

            for _, spectator in pairs(getSpectators()) do
                if spectator:isPlayer() then
                    spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                    spectator:teleportTo(config.teleportToPosition, false)
                    spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                else
                    spectator:remove()
                end
            end
        end, config.teleportRemoveSeconds * 1000)
    end

    return true
end

creatureEvent:register()
