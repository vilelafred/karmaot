local config = {
    bossName = "Lory Mistress",
    bossPosition = Position(33043, 32290, 4),
    storageCooldown = 54455, -- 24h cooldown
    cooldownTime = 72000, -- 24 hours in seconds
    minLevel = 500,
    actionId = 8887,
    leverId = 1945,
    despawnTime = 600 -- 10 minutes
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

    if player:getLevel() < config.minLevel then
        player:sendCancelMessage("You must be at least level " .. config.minLevel .. " to pull this lever.")
        return true
    end

    local currentTime = os.time()
    local lastUse = player:getStorageValue(config.storageCooldown)
    if lastUse ~= -1 and currentTime - lastUse < config.cooldownTime then
        local remaining = config.cooldownTime - (currentTime - lastUse)
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        player:sendCancelMessage("You must wait " .. hours .. "h and " .. minutes .. "min before using this lever again.")
        return true
    end

    if not Tile(config.bossPosition):getTopCreature() then
        -- Boss summon
        Game.createMonster(config.bossName, config.bossPosition, false, true)

        -- Area effect (3x3 energy blast)
        local center = config.bossPosition
        for x = -1, 1 do
            for y = -1, 1 do
                local pos = Position(center.x + x, center.y + y, center.z)
                pos:sendMagicEffect(CONST_ME_ENERGYAREA)
            end
        end

        player:setStorageValue(config.storageCooldown, currentTime)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The silence breaks... Lory Mistress has awakened!")
        addEvent(despawnBoss, config.despawnTime * 1000)
    else
        player:sendCancelMessage("The boss area is currently occupied.")
    end

    return true
end

bossLever:aid(config.actionId)
bossLever:register()
