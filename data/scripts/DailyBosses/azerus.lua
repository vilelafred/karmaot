local config = {
    bossName = "Azerus",
    bossPosition = Position(1325, 1064, 10),
    playerPositions = {
        Position(1326, 1076, 9),
        Position(1326, 1077, 9),
        Position(1326, 1078, 9),
        Position(1326, 1079, 9)
    },
    teleportPositions = {
        Position(1322, 1072, 10),
        Position(1323, 1072, 10),
        Position(1324, 1072, 10),
        Position(1325, 1072, 10)
    },
    storageCooldown = 59123,   -- NOVO: cooldown opcional
    storageDone = 59125,       -- NOVO: marca como "feito"
    cooldownTime = 86400,      -- 24 horas
    minLevel = 450,
    actionId = 8611,           -- NOVO: action ID único
    despawnTime = 800          -- 10 minutos
}

local function despawnBoss()
    for _, creature in pairs(Game.getSpectators(config.bossPosition, false, false, 3, 3, 3, 3)) do
        if creature:isMonster() and creature:getName():lower() == config.bossName:lower() then
            creature:remove()
            break
        end
    end
end

local bossLever = Action()

function bossLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.actionid ~= config.actionId then
        return false
    end

    local players = {}
    for i, pos in ipairs(config.playerPositions) do
        local tile = Tile(pos)
        if tile then
            local creature = tile:getTopCreature()
            if creature and creature:isPlayer() then
                table.insert(players, creature)
            end
        end
    end

    local count = #players
    if count < 2 or count > 4 then
        player:sendCancelMessage("You need between 2 and 4 players standing on the correct tiles to start Yalahari Quest.")
        return true
    end

    for _, p in pairs(players) do
        if p:getLevel() < config.minLevel then
            p:sendCancelMessage("All players must be at least level " .. config.minLevel .. ".")
            return true
        end
        if p:getStorageValue(config.storageDone) == 1 then
            p:sendCancelMessage("Someone in your team has already completed this quest.")
            return true
        end
    end

    if Tile(config.bossPosition):getTopCreature() then
        player:sendCancelMessage("The boss area is currently occupied.")
        return true
    end

    -- Summon boss
    Game.createMonster(config.bossName, config.bossPosition, false, true)
    for x = -1, 1 do
        for y = -1, 1 do
            local pos = Position(config.bossPosition.x + x, config.bossPosition.y + y, config.bossPosition.z)
            pos:sendMagicEffect(CONST_ME_ENERGYAREA)
        end
    end

    -- Teleport players
    for i, p in pairs(players) do
        local destination = config.teleportPositions[i]
        if destination then
            p:teleportTo(destination)
            destination:sendMagicEffect(CONST_ME_TELEPORT)
            p:setStorageValue(config.storageCooldown, os.time())
        end
    end

    addEvent(despawnBoss, config.despawnTime * 1000)
    return true
end

bossLever:aid(config.actionId)
bossLever:register()
