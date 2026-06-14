local config = {
    actionId = 20222,
    bossName = "Yalahari",
    bossPosition = Position(1325, 1064, 10),
    bossArea = {
        fromPos = Position(1314, 1052, 10), 
        toPos = Position(1336, 1075, 10), 
        entrancePos = Position(1325, 1072, 10),
        exitPosition = Position(1325, 1092, 8)
    },
    allowedAnyParticipantsCount = true,
    participantsPos = {
        Position(1326, 1076, 9),
        Position(1326, 1077, 9),
        Position(1326, 1078, 9),
        Position(1326, 1079, 9),		
    },
    attempts = {
        level = 300,
        storage = 2522,
        seconds = 43200
    },
    createTeleportPos = Position(1325, 1062, 10),
    teleportToPosition = Position(1320, 1104, 7),
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
        if not tile then
            error("[Warning - Tile not found]")
        end

        local creature = tile:getTopCreature()
        if creature and creature:isPlayer() then
            table.insert(participants, creature)
        end
    end

    for _, monsterSpectator in pairs(getSpectators()) do
        monsterSpectator:remove()
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
