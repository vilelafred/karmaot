local config = {
    actionId = 20263,
    bossName = "Dreadfiend",
    bossPosition = Position(33362, 32029, 9),
    bossArea = {
        fromPos = Position(33331, 32001, 9),
        toPos = Position(33394, 32064, 9),
        entrancePos = Position(33359, 32039, 9),
        exitPosition = Position(32601, 32601, 8)
    },
    allowedAnyParticipantsCount = true,
    participantsPos = {
        Position(32598, 32599, 8),
        Position(32597, 32599, 8),
        Position(32596, 32599, 8),
        Position(32595, 32599, 8),        
    },
    attempts = {
        level = 300,
        storage = 2235,
        seconds = 72000 -- 12 horas
    },
    createTeleportPos = Position(33358, 32038, 9),
    teleportToPosition = Position(32601, 32601, 8),
    teleportRemoveSeconds = 30,
    kickParticipantAfterSeconds = 10 * 60,
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
            -- Verificar level
            if creature:getLevel() < config.attempts.level then
                player:sendCancelMessage(string.format("All players must be level %d or higher.", config.attempts.level))
                return true
            end

            -- Verificar cooldown
            local cooldown = creature:getStorageValue(config.attempts.storage)
            if cooldown > os.time() then
                local remaining = cooldown - os.time()
                local hours = math.floor(remaining / 3600)
                local minutes = math.floor((remaining % 3600) / 60)
                player:sendCancelMessage(string.format("%s must wait %02dh %02dm to enter again.", creature:getName(), hours, minutes))
                return true
            end

            -- Verificar item
            if creature:getItemCount(6846) < 2 then
                player:sendCancelMessage("All players need 2 magic sulphurs to pull the lever.")
                return true
            end

            table.insert(participants, creature)
        end
    end

    -- Checa sala ocupada antes de remover itens
    if #getSpectators(true) > 0 then
        player:sendCancelMessage("At this time the room is occupied, please try again later.")
        return true
    end

    -- Remover itens somente após confirmar sala livre
    for _, participant in ipairs(participants) do
        participant:removeItem(6846, 2)
    end

    -- Cancela evento de kick anterior (se existir)
    stopEvent(config.kickEventId)

    -- Limpa somente monstros da sala
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

    for _, participant in ipairs(participants) do
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
