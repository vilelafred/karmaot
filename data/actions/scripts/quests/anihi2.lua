-- Annihilator Quest adaptada para solo ou time (1 a 4 players)

local questStorage = 30099
local questLevel = 300

local room = {
    fromX = 33149, fromY = 31725, fromZ = 13,
    toX = 33196, toY = 31730, toZ = 13
}

local monster_pos = {
    {pos = Position(33149, 31725, 13), monster = "Black Demon"},
    {pos = Position(33150, 31729, 13), monster = "Black Demon"},
    {pos = Position(33151, 31725, 13), monster = "Black Demon"},
    {pos = Position(33152, 31729, 13), monster = "Black Demon"},
    {pos = Position(33153, 31725, 13), monster = "Black Demon"},
    {pos = Position(33154, 31729, 13), monster = "Black Demon"},
    {pos = Position(33155, 31725, 13), monster = "Black Demon"},
    {pos = Position(33156, 31729, 13), monster = "Black Demon"},
    {pos = Position(33157, 31725, 13), monster = "Black Demon"},
    {pos = Position(33158, 31729, 13), monster = "Black Demon"},
    {pos = Position(33159, 31725, 13), monster = "Black Demon"},
    {pos = Position(33160, 31729, 13), monster = "Black Demon"},
    {pos = Position(33161, 31725, 13), monster = "Black Demon"},
    {pos = Position(33162, 31729, 13), monster = "Black Demon"},
    {pos = Position(33163, 31725, 13), monster = "Black Demon"},
    {pos = Position(33164, 31729, 13), monster = "Black Demon"},
    {pos = Position(33165, 31725, 13), monster = "Black Demon"},
    {pos = Position(33166, 31729, 13), monster = "Black Demon"},
    {pos = Position(33167, 31725, 13), monster = "Black Demon"},
    {pos = Position(33168, 31729, 13), monster = "Black Demon"},
    {pos = Position(33169, 31725, 13), monster = "Black Demon"},
    {pos = Position(33170, 31729, 13), monster = "Black Demon"},
    {pos = Position(33171, 31725, 13), monster = "Black Demon"},
    {pos = Position(33172, 31729, 13), monster = "Black Demon"},
    {pos = Position(33173, 31725, 13), monster = "Black Demon"},
    {pos = Position(33175, 31725, 13), monster = "Black Demon"},
    {pos = Position(33176, 31729, 13), monster = "Black Demon"},
    {pos = Position(33177, 31725, 13), monster = "Black Demon"},
    {pos = Position(33178, 31729, 13), monster = "Black Demon"},
    {pos = Position(33179, 31725, 13), monster = "Black Demon"},
    {pos = Position(33180, 31729, 13), monster = "Black Demon"},
    {pos = Position(33181, 31725, 13), monster = "Black Demon"},
    {pos = Position(33182, 31729, 13), monster = "Black Demon"},
    {pos = Position(33183, 31725, 13), monster = "Black Demon"},
    {pos = Position(33184, 31729, 13), monster = "Black Demon"},
    {pos = Position(33185, 31725, 13), monster = "Black Demon"},
    {pos = Position(33186, 31729, 13), monster = "Black Demon"},
    {pos = Position(33187, 31725, 13), monster = "Black Demon"},
    {pos = Position(33188, 31729, 13), monster = "Black Demon"},
    {pos = Position(33189, 31725, 13), monster = "Black Demon"},
    {pos = Position(33190, 31729, 13), monster = "Black Demon"},
    {pos = Position(33191, 31725, 13), monster = "Black Demon"},
    {pos = Position(33192, 31729, 13), monster = "Black Demon"},
    {pos = Position(33193, 31725, 13), monster = "Black Demon"},
    {pos = Position(33194, 31729, 13), monster = "Black Demon"},
    {pos = Position(33195, 31725, 13), monster = "Black Demon"},
	
    -- NOVA LINHA COMPLETA no y = 31727 (horizontal)
    {pos = Position(33156, 31727, 13), monster = "Demon"},

    {pos = Position(33158, 31727, 13), monster = "Demon"},

    {pos = Position(33160, 31727, 13), monster = "Demon"},

    {pos = Position(33162, 31727, 13), monster = "Demon"},

    {pos = Position(33164, 31727, 13), monster = "Demon"},

    {pos = Position(33166, 31727, 13), monster = "Demon"},

    {pos = Position(33168, 31727, 13), monster = "Demon"},

    {pos = Position(33170, 31727, 13), monster = "Demon"},

    {pos = Position(33172, 31727, 13), monster = "Demon"},

    {pos = Position(33174, 31727, 13), monster = "Demon"},

    {pos = Position(33176, 31727, 13), monster = "Demon"},

    {pos = Position(33178, 31727, 13), monster = "Demon"},

    {pos = Position(33180, 31727, 13), monster = "Demon"},

    {pos = Position(33182, 31727, 13), monster = "Demon"},

    {pos = Position(33184, 31727, 13), monster = "Demon"},

    {pos = Position(33186, 31727, 13), monster = "Demon"},

    {pos = Position(33188, 31727, 13), monster = "Demon"},

    {pos = Position(33190, 31727, 13), monster = "Demon"},

    {pos = Position(33192, 31727, 13), monster = "Demon"},

    {pos = Position(33194, 31727, 13), monster = "Demon"},
    {pos = Position(33195, 31727, 13), monster = "Demon"}
}
	
local players_pos = {
    Position(33222, 31691, 13),
    Position(33223, 31691, 13),
    Position(33224, 31691, 13),
    Position(33225, 31691, 13)
}

local new_player_pos = {
    Position(33149, 31727, 13),
    Position(33150, 31727, 13),
    Position(33151, 31727, 13),
    Position(33152, 31727, 13)
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
