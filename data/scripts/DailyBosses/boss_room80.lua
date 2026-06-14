local config = {
    actionId = 20363,
    bossName = "Mozradek",
    bossPosition = Position(33317, 32069, 11),
    bossArea = {
        fromPos = Position(33283, 32030, 11),
        toPos = Position(33350, 32100, 11),
        entrancePos = Position(33317, 32073, 11),
        exitPosition = Position(33282, 32460, 10)
    },
    allowedAnyParticipantsCount = true,
    participantsPos = {
        Position(33283, 32459, 10),
        Position(33282, 32459, 10),
        Position(33281, 32459, 10),
        Position(33280, 32459, 10),
    },
    attempts = {
        level = 400,
        storage = 2240,
        seconds = 72000 -- 12 horas
    },
    createTeleportPos = Position(33317, 32081, 11),
    teleportToPosition = Position(33282, 32460, 10),
    teleportRemoveSeconds = 60,
    kickParticipantAfterSeconds = 15 * 60,
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
    local participants = {}

    for _, pos in pairs(config.participantsPos) do
        local tile = Tile(pos)
        if not tile then
            error("[Warning - Tile not found]")
        end

        local creature = tile:getTopCreature()
        if creature and creature:isPlayer() then
            -- Verificação de nível mínimo
            if creature:getLevel() < config.attempts.level then
                player:sendCancelMessage(string.format("All players must be at least level %d to enter.", config.attempts.level))
                return true
            end

            -- Verificação de cooldown
            local storage = creature:getStorageValue(config.attempts.storage)
            if storage > os.time() then
                local remaining = storage - os.time()
                local hours = math.floor(remaining / 3600)
                local minutes = math.floor((remaining % 3600) / 60)
                player:sendCancelMessage(string.format("%s must wait %02dh %02dm before entering again.", creature:getName(), hours, minutes))
                return true
            end

            -- Verificação de item
            if creature:getItemCount(6846) < 3 then
                player:sendCancelMessage("All players need 3 magic sulphurs to pull the lever.")
                return true
            end

            table.insert(participants, creature)
        end
    end

    -- Remove item de todos
    for _, participant in ipairs(participants) do
        participant:removeItem(6846, 3)
    end

    -- Checa se a sala está ocupada
    if #getSpectators(true) > 0 then
        player:sendCancelMessage("At this time the room is occupied, please try again later.")
        return true
    end

    stopEvent(config.kickEventId)

    -- Limpa criaturas antigas
    for _, entity in pairs(getSpectators()) do
        entity:remove()
    end

    -- Cria o boss
    local boss = Game.createMonster(config.bossName, config.bossPosition)
    if not boss then
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    boss:registerEvent("bossSystemDeath")

    -- Teleporta jogadores
    for _, participant in ipairs(participants) do
        participant:getPosition():sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos)
        participant:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
    end

    config.kickEventId = addEvent(function ()
        for _, spectator in pairs(getSpectators()) do
            if spectator:isPlayer() then
                spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                spectator:teleportTo(config.bossArea.exitPosition)
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

local creatureEvent = CreatureEvent("bossSystemDeath")

function creatureEvent.onDeath()
    stopEvent(config.kickEventId)
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
                    spectator:teleportTo(config.teleportToPosition)
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
