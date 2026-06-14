local config = {
    actionId = 20163,
    bossName = "Swamp Spider",
    bossPosition = Position(33354, 32020, 8),
    bossArea = {
        fromPos = Position(33336, 32011, 8),
        toPos = Position(33377, 32041, 8),
        entrancePos = Position(33363, 32021, 8),
        exitPosition = Position(33317, 32055, 8)
    },
    allowedAnyParticipantsCount = true,
    participantsPos = {
        Position(33321, 32055, 8),
        Position(33320, 32055, 8),
        Position(33319, 32055, 8),
    },
    attempts = {
        level = 200,
        storage = 2501,
        seconds = 72000 -- 12 horas
    },
    createTeleportPos = Position(33362, 32027, 8),
    teleportToPosition = Position(33317, 32055, 8),
    teleportRemoveSeconds = 30,
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
        if not tile then error("[Warning - Tile not found]") end

        local creature = tile:getTopCreature()
        if creature and creature:isPlayer() then
            -- Verifica cooldown
            local cooldown = creature:getStorageValue(config.attempts.storage)
            if cooldown > os.time() then
                local hoursLeft = math.ceil((cooldown - os.time()) / 3600)
                player:sendCancelMessage(string.format("%s must wait %d hour(s) to challenge this boss again.", creature:getName(), hoursLeft))
                return true
            end

            if creature:getItemCount(6846) < 1 then
                player:sendCancelMessage("All players need a magic sulphur to pull the lever.")
                return true
            end
            table.insert(participants, creature)
        end
    end

    -- Impede nova entrada se já houver jogadores na sala
    if #getSpectators(true) > 0 then
        player:sendCancelMessage("At this time the room is occupied, please try again later.")
        return true
    end

    -- Remove os itens apenas após confirmar sala livre
    for _, participant in ipairs(participants) do
        participant:removeItem(6846, 1)
    end

    -- Cancela evento de kick anterior (se existir)
    stopEvent(config.kickEventId)

    -- Limpa somente monstros da sala (não remove jogadores)
    for _, entity in pairs(getSpectators()) do
        if not entity:isPlayer() then
            entity:remove()
        end
    end

    local boss = Game.createMonster(config.bossName, config.bossPosition)
    if not boss then
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end

    boss:registerEvent("bossSystemDeath")

    for _, participant in pairs(participants) do
        participant:getPosition():sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos, false)
        participant:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
    end

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
