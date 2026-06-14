-- Annihilator Quest adaptada para solo ou time (1 a 4 players)

local questStorage = 30015
local questLevel = 100

local room = {
    fromX = 33219, fromY = 31657, fromZ = 13,
    toX = 33224, toY = 31661, toZ = 13
}

local monster_pos = {
    {pos = Position(33219, 31657, 13), monster = "Demon"},
    {pos = Position(33221, 31657, 13), monster = "Demon"},
    {pos = Position(33220, 31661, 13), monster = "Demon"},
    {pos = Position(33222, 31661, 13), monster = "Demon"},
    {pos = Position(33223, 31659, 13), monster = "Demon"},
    {pos = Position(33224, 31659, 13), monster = "Demon"}
}

local players_pos = {
    Position(33222, 31671, 13),
    Position(33223, 31671, 13),
    Position(33224, 31671, 13),
    Position(33225, 31671, 13)
}

local new_player_pos = {
    Position(33219, 31659, 13),
    Position(33220, 31659, 13),
    Position(33221, 31659, 13),
    Position(33222, 31659, 13)
}

local function isRoomOccupied()
    for x = room.fromX, room.toX do
        for y = room.fromY, room.toY do
            local pos = Position(x, y, room.fromZ)
            local tile = Tile(pos)
            if tile then
                local creature = tile:getTopCreature()
                if creature and creature:isPlayer() then
                    return true
                end
            end
        end
    end
    return false
end

function onUse(player, item, fromPosition, target, toPosition)
    if item.itemid == 1945 then
        if isRoomOccupied() then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "There is already someone in the quest room.")
            return true
        end

        local participants = {}
        for i = 1, #players_pos do
            local tile = Tile(players_pos[i])
            if tile then
                local creature = tile:getTopCreature()
                if creature and creature:isPlayer() then
                    table.insert(participants, creature)
                end
            end
        end

        if #participants < 1 then
            player:sendCancelMessage("You need at least 1 player to start the quest.")
            return true
        end

        if #participants > 4 then
            player:sendCancelMessage("Maximum 4 players are allowed.")
            return true
        end

        for i = 1, #participants do
            if participants[i]:getLevel() < questLevel then
                player:sendCancelMessage("All players must be level " .. questLevel .. " or higher.")
                return true
            end
            if participants[i]:getStorageValue(questStorage) > 0 then
                player:sendCancelMessage("Someone in your team has already completed this quest.")
                return true
            end
        end

        -- Invoca os Demons
        for _, info in ipairs(monster_pos) do
            Game.createMonster(info.monster, info.pos)
        end

        -- Teleporta os players
        for i = 1, #participants do
            participants[i]:teleportTo(new_player_pos[i])
            participants[i]:getPosition():sendMagicEffect(CONST_ME_ENERGYAREA)
        end

        item:transform(1946)

    elseif item.itemid == 1946 then
        if isRoomOccupied() then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "Someone is still inside the room.")
        else
            item:transform(1945)
            -- Limpa monstros restantes
            for x = room.fromX, room.toX do
                for y = room.fromY, room.toY do
                    local pos = Position(x, y, room.fromZ)
                    local tile = Tile(pos)
                    if tile then
                        local creature = tile:getTopCreature()
                        if creature and creature:isMonster() then
                            creature:remove()
                        end
                    end
                end
            end
        end
    end
    return true
end
