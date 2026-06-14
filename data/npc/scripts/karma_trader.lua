local COST_RANDOM = 10000000  -- 10kk for random trade
local COST_SPECIFIC = 25000000 -- 25kk for specific trade
local COST_ITEM = 0 -- item cost disabled (Jasmine Coin is counted as gold in your server)
local COST_ITEM_COUNT = 0

local KARMA_ITEMS = {
    6167, -- hat
    6225, -- axe
    6118, -- sword
    5791, -- crossbow
    6128, -- shield
    6196, -- staff
    6176, -- legs
    7630, -- spellbook
    5818, -- cape
    6221, -- hammer
    6174, -- bow
    6127, -- armor
}

local function isKarmaItem(itemId)
    for _, id in ipairs(KARMA_ITEMS) do
        if id == itemId then return true end
    end
    return false
end

local function listKarmaNames()
    local names = {}
    for _, id in ipairs(KARMA_ITEMS) do
        table.insert(names, ItemType(id):getName())
    end
    return table.concat(names, ", ")
end

local function normalize(str)
    return (str or ""):lower():gsub("[^%w]", "")
end

local function resolveKarma(input)
    if not input or input == "" then return 0 end
    local norm = normalize(input)
    for _, id in ipairs(KARMA_ITEMS) do
        local name = ItemType(id):getName()
        if normalize(name) == norm then
            return id
        end
    end
    return 0
end

local function removeCost(player, tradeType)
    local cost = (tradeType == "specific") and COST_SPECIFIC or COST_RANDOM
    local costText = (tradeType == "specific") and "25kk" or "10kk"
    
    if COST_ITEM > 0 then
        if player:getItemCount(COST_ITEM) < COST_ITEM_COUNT then
            return false, "You need " .. COST_ITEM_COUNT .. "x " .. ItemType(COST_ITEM):getName() .. "."
        end
        player:removeItem(COST_ITEM, COST_ITEM_COUNT)
        return true
    end
    if not player:removeTotalMoney(cost) then
        return false, "You need " .. costText .. " for this exchange."
    end
    return true
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function greet(cid)
    npcHandler:say("Hello! I swap Karma items. {Random} trade (10kk) or {specific} trade (25kk)? Say {list} to see all items.", cid)
end

npcHandler:setCallback(CALLBACK_GREET, greet)

keywordHandler:addKeyword({"list"}, function(cid)
    npcHandler:say("Karma items: " .. listKarmaNames() .. ".", cid)
end)

-- Note: We handle 'random <item>' exclusively in creatureSayCallback to avoid overlapping messages

local function parseItemIdFromMsg(msg)
    local id = tonumber(msg:match("%d+"))
    return id or 0
end

local function doChosenSwap(player, fromId, toId, cid)
    if fromId == toId then
        player:sendCancelMessage("Choose a different item.")
        return true
    end
    if player:getItemCount(fromId) < 1 then
        player:sendCancelMessage("You don't have the required Karma item.")
        if cid then npcHandler:say("You don't have this Karma item.", cid) end
        return true
    end
    local ok, err = removeCost(player, "specific")
    if not ok then
        player:sendCancelMessage(err)
        if cid then npcHandler:say(err, cid) end
        local pp = player:getPosition()
        pp:sendMagicEffect(CONST_ME_POFF)
        return true
    end
    player:removeItem(fromId, 1)
    player:addItem(toId, 1)
    local msg = "Karma trade complete: received 1x " .. ItemType(toId):getName() .. "."
    player:say(msg, TALKTYPE_MONSTER_SAY)
    if cid then npcHandler:say(msg, cid) end
    local p = player:getPosition()
    p:sendMagicEffect(CONST_ME_MAGIC_BLUE)
    p:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    return true
end

local function doRandomSwap(player, fromId, cid)
    if player:getItemCount(fromId) < 1 then
        player:sendCancelMessage("You don't have the required Karma item.")
        if cid then npcHandler:say("You don't have this Karma item.", cid) end
        return true
    end
    local ok, err = removeCost(player, "random")
    if not ok then
        player:sendCancelMessage(err)
        if cid then npcHandler:say(err, cid) end
        return true
    end
    -- build pool excluding fromId
    local pool = {}
    for _, id in ipairs(KARMA_ITEMS) do
        if id ~= fromId then table.insert(pool, id) end
    end
    local toId = pool[math.random(#pool)]
    player:removeItem(fromId, 1)
    player:addItem(toId, 1)
    local msg = "Karma trade complete: received random 1x " .. ItemType(toId):getName() .. "."
    player:say(msg, TALKTYPE_MONSTER_SAY)
    if cid then npcHandler:say(msg, cid) end
    local p = player:getPosition()
    p:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    p:sendMagicEffect(CONST_ME_FIREWORK_RED)
    return true
end

function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    local lower = msg:lower()
    
    -- Random trade: "random karma sword"
    if lower:find("random") then
        local name = msg:match("^%s*random%s+(.+)$")
        local id = resolveKarma(name)
        if id == 0 then
            npcHandler:say("Usage: random <karma item name>. Example: random karma sword.", cid)
            return true
        end
        doRandomSwap(player, id, cid)
        return true
    end
    
    -- Specific trade: "specific karma sword, karma axe"
    if lower:find("specific") then
        local content = msg:match("^%s*specific%s+(.+)$")
        if not content then
            npcHandler:say("Usage: specific <from item>, <to item>. Example: specific karma sword, karma axe.", cid)
            return true
        end
        
        -- Split by comma
        local parts = {}
        for part in content:gmatch("[^,]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$")) -- trim spaces
        end
        
        if #parts ~= 2 then
            npcHandler:say("Usage: specific <from item>, <to item>. Example: specific karma sword, karma axe.", cid)
            return true
        end
        
        local fromId = resolveKarma(parts[1])
        local toId = resolveKarma(parts[2])
        
        if fromId == 0 or toId == 0 then
            npcHandler:say("Invalid karma item name. Say {list} to see all items.", cid)
            return true
        end
        
        doChosenSwap(player, fromId, toId, cid)
        return true
    end
    
    return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())


