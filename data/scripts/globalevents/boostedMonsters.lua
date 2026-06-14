boostedMonsters = {}
boostedMonstersExperienceMultiplier = 1.5 -- 1 = default, 2 = 200% (aka, double experience)
boostedMonstersLootChanceMultiplier = 2 -- 1 = default, 2 = 200% (aka, double chance of loot.) (1.36% -> 2.72%)(88% -> 100%)

local boostedMonstersAmount = 1 -- how many arrays from boostedMonstersList will be chosen
-- NOTE: Ensure that this amount does not exceed the amount of arrays in boostedMonstersAmount.. or your server will crash.

local boostedMonstersList = {
    {"ancient giant spider"},
    {"behemoth"},
    {"black knight"},
    {"demon"},
    {"dragon lord"},
    {"frost dragon"},
    {"frost hero"},
    {"fury"},
    {"hellspawn"},
    {"hero"},
    {"hellfire fighter"},	
    {"silver hero"},	
    {"jasmin hero"},	
    {"tark trueblade"},	
    {"hydra"},
    {"belphegor"},		
    {"nokmir"},
    {"red magician"},
    {"darkness dragon"},
    {"serpent spawn"},
    {"solar dragon"},
    {"warlock"},
    {"golden hero"},	
    {"lory madam"},	
    {"lory keeper"},	
    {"queen medusa"},
    {"black demon"},
    {"mystical dragon"},
    {"milenar dragon"},	
    {"white magician"},
    {"spider queen"},	
    {"omruc"},
    {"dipthrah"},	
    {"skull dragon"},	
    {"demon knight"},	
    {"darkness dragon"},
    {"grim reaper"},	

}

local function generateBoostedMonstersText()
    local text = ""
    for i = 1, #boostedMonsters do
        if text ~= "" then
            if i == #boostedMonsters then
                text = text .. " and "
            else
                text = text .. ", "
            end
        end
        text = text .. boostedMonsters[i]
    end
    text = "Today's boosted monster is " .. text .. "."
    return text
end

local function chooseBoostedMonsters()
    local boostedMonstersCount = 0
    while boostedMonstersCount < boostedMonstersAmount do
        local randomMonster = math.random(#boostedMonstersList)
        if not table.contains(boostedMonsters, boostedMonstersList[randomMonster][1]:lower()) then
            for i = 1, #boostedMonstersList[randomMonster] do
                table.insert(boostedMonsters, boostedMonstersList[randomMonster][i]:lower())
            end
            boostedMonstersCount = boostedMonstersCount + 1
        end
    end
end

local function splitWithComma(inputstring)
    local array = {}
    for str in string.gmatch(inputstring, "[^,]+") do
        table.insert(array, str)
    end
    return array
end

local function writeBoostedMonstersToFile()
    local text = ""
    for i = 1, #boostedMonsters do
        if text ~= "" then
            text = text ..  ","
        end
        text = text .. boostedMonsters[i]
    end
    local file = io.open("data\\logs\\boostedMonsters.txt", "w+")
    file:write(text)
    file:close()
end

local function updateBoostedMonstersFromFile()
    local file = io.open("data\\logs\\boostedMonsters.txt", "r")
    local text = file:read()
    boostedMonsters = splitWithComma(text)
    file:close()
end

local function insertBoostedMonster(monsterName)
    -- Escapa as aspas simples no nome do monstro
    local escapedName = monsterName:gsub("'", "''")
    
    -- Deleta todos os registros antigos da tabela
    db:query("DELETE FROM boostedMonsters")
    
    -- Insere o novo monstro na tabela
    local query = string.format("INSERT INTO boostedMonsters (monster_name) VALUES ('%s')", escapedName)
    db:query(query)
end

local function chooseBoostedMonsters()
    local boostedMonstersCount = 0
    while boostedMonstersCount < boostedMonstersAmount do
        local randomMonster = math.random(#boostedMonstersList)
        local monsterName = boostedMonstersList[randomMonster][1]:lower()

        if not table.contains(boostedMonsters, monsterName) then
            for i = 1, #boostedMonstersList[randomMonster] do
                table.insert(boostedMonsters, monsterName)
            end
            boostedMonstersCount = boostedMonstersCount + 1

            -- Inserir o nome do monstro na base de dados
            insertBoostedMonster(monsterName)
        end
    end
end

local onStartup_boostedMonsters = GlobalEvent("onStartup_boostedMonsters")

function onStartup_boostedMonsters.onStartup()
    local file = io.open("data\\logs\\boostedMonsters.txt", "r")
    if file ~= nil then
        file:close()
        updateBoostedMonstersFromFile()
    else
        chooseBoostedMonsters()
        writeBoostedMonstersToFile()
    end
    local text = generateBoostedMonstersText()
    -- addEvent(print, 0, text)
    return true
end

onStartup_boostedMonsters:register()


local onTime_boostedMonsters = GlobalEvent("onTime_boostedMonsters")

function onTime_boostedMonsters.onTime()
    boostedMonsters = {}
    chooseBoostedMonsters()
    writeBoostedMonstersToFile()
    local text = generateBoostedMonstersText()
    print(text)
    Game.broadcastMessage(text)
    return true
end

onTime_boostedMonsters:time("00:00:00")
onTime_boostedMonsters:register()


local loginEvent = CreatureEvent("onLogin_boostedMonsters")
loginEvent:type("login")

function loginEvent.onLogin(player)
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, generateBoostedMonstersText())
    return true
end

loginEvent:register()