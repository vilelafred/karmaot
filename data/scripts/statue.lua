---------- CONFIG ------------
local howManyPlayers = 10
local statues = {
    { position = Position(32383, 32212, 7), skill = "level" }, -- {x = 32383, y = 32212, z = 7} THAIS
   -- { position = Position(100, 101, 7), skill = "magic" },
   -- { position = Position(100, 102, 7), skill = "axe" },
   -- { position = Position(100, 103, 7), skill = "sword" },
   -- { position = Position(100, 104, 7), skill = "club" },
   -- { position = Position(100, 105, 7), skill = "shielding" },
   -- { position = Position(100, 106, 7), skill = "dist" },
   -- { position = Position(100, 107, 7), skill = "fist" },
   -- { position = Position(100, 108, 7), skill = "sorcerer" },
   -- { position = Position(100, 109, 7), skill = "druid" },
   -- { position = Position(100, 110, 7), skill = "knight" },
   -- { position = Position(100, 111, 7), skill = "paladin" },
    { position = Position(32094, 32201, 7), skill = "rook" } -- {x = 32094, y = 32201, z = 7} ROOK
}
------------------------------

local function getPlayersByLevelText()
    local filteredQuery = db.storeQuery("SELECT * FROM `players` WHERE `level` < 1000 AND `group_id` NOT IN (3, 4) ORDER BY `experience` DESC LIMIT " .. howManyPlayers)
    local text = "Top " .. howManyPlayers .. " players by Level:"
    for i = 1, howManyPlayers do
        local topPlayerName = result.getDataString(filteredQuery, "name")
        local topPlayerLevel = result.getDataString(filteredQuery, "level")
        text = text .. "\n" .. i .. ". " .. topPlayerName .. " [" .. topPlayerLevel .. "]"
        result.next(filteredQuery)
    end   
    result.free(filteredQuery)
    return text
end

local function getPlayersByVocationText(name)
    local vocationIds = {
        ["rook"] = { 0, 9, "Rook Slayers" },
        ["sorcerer"] = { 1, 5, "Sorcerers" },
        ["druid"] = { 2, 6, "Druids" },
        ["paladin"] = { 3, 7, "Paladins" },
        ["knight"] = { 4, 8, "Knights" }
    }
    local filteredQuery = db.storeQuery("SELECT COUNT(*) AS `count` FROM `players` WHERE (`vocation` = " .. vocationIds[name][1] .. " or `vocation` = " .. vocationIds[name][2] .. ") AND `level` < 1000 AND `group_id` NOT IN (3, 4) ORDER BY `experience` DESC LIMIT 1")
    local vocationPlayers = result.getDataInt(filteredQuery, "count")
    result.free(filteredQuery)
    vocationPlayers = math.min(vocationPlayers, howManyPlayers)
    local text = "Top " .. vocationPlayers .. " " .. vocationIds[name][3] ..  " by Level:"
    local topPlayerQuery = db.storeQuery("SELECT * FROM `players` WHERE (`vocation` = " .. vocationIds[name][1] .. " or `vocation` = " .. vocationIds[name][2] .. ") AND `level` < 1000 AND `group_id` NOT IN (3, 4) ORDER BY `experience` DESC LIMIT " .. vocationPlayers)
    for i = 1, vocationPlayers do
        local topPlayerName = result.getDataString(topPlayerQuery, "name")
        local topPlayerLevel = result.getDataString(topPlayerQuery, "level")
        text = text .. "\n" .. i .. ". " .. topPlayerName .. " [" .. topPlayerLevel .. "]"
        result.next(topPlayerQuery)
    end   
    result.free(topPlayerQuery)
    return text
end

local globalevent = GlobalEvent("HeroStatues")
function globalevent.onStartup()
    local texts = {
        ["sorcerer"] = getPlayersByVocationText("sorcerer"),
        ["druid"] = getPlayersByVocationText("druid"),
        ["paladin"] = getPlayersByVocationText("paladin"),
        ["knight"] = getPlayersByVocationText("knight"),
        ["rook"] = getPlayersByVocationText("rook"),
        ["level"] = getPlayersByLevelText(),
        -- Adicione outras categorias conforme necessário
    }
    
    for k,v in pairs(statues) do
        local tile = Tile(v.position)
        if tile then
            local statue = tile:getTopTopItem()
            if statue then
                statue:setAttribute(ITEM_ATTRIBUTE_TEXT, texts[v.skill])
            else
              --  print("Erro: Estátua não encontrada na posição: " .. v.position.x .. ", " .. v.position.y .. ", " .. v.position.z)
            end
        else
         --   print("Erro: Tile não encontrado na posição: " .. v.position.x .. ", " .. v.position.y .. ", " .. v.position.z)
        end
    end
end

globalevent:register()
