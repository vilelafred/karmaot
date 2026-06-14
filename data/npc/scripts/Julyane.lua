dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)          end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)       end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()                      npcHandler:onThink()                      end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- ================== CONFIG ==================
local CASINO_TICKET_ID = 6692

-- Itens aceitos: [itemId] = "nome"
local EXCHANGE_ITEMS = {
    [2523] = "rainbow shield",
    [8323] = "lucky ring",
    [6613] = "royal customer outfit",
    [5861] = "cupid backpack",
    [6838] = "bless scroll",
    [6780] = "7 days of premium account",
    [6781] = "15 days of premium account",
    [6782] = "30 days of premium account",
    [2474] = "winged helmet",
    [6181] = "multi tool",
    [6698] = "exp boost",
    [6800] = "dragon slayer outfit",
    [6784] = "demon knight outfit"
}
-- ============================================

local function normalize(s)
    s = s:lower()
    s = s:gsub("%s+", " ")
    return s
end

local function findExchangeItemIdFromMessage(msg)
    local text = normalize(msg)
    -- tenta por id
    local idnum = tonumber(text:match("(%d+)"))
    if idnum and EXCHANGE_ITEMS[idnum] then
        return idnum
    end
    -- tenta por nome
    for iid, name in pairs(EXCHANGE_ITEMS) do
        if text:find(normalize(name), 1, true) then
            return iid
        end
    end
    return nil
end

local function listItems()
    local parts = {}
    for iid, name in pairs(EXCHANGE_ITEMS) do
        parts[#parts+1] = string.format("%s (%d)", name, iid)
    end
    table.sort(parts)
    return table.concat(parts, ", ")
end

-- Compatibilidade de foco entre diferentes versões do npcsystem
local function npcHasFocus(handler, cid)
    if handler and type(handler.checkInteraction) == 'function' then
        return handler:checkInteraction(cid)
    end
    if handler and handler.focus then
        return handler.focus == cid
    end
    return true
end

local function tradeOne(cid, itemId)
    if getPlayerItemCount(cid, itemId) <= 0 then
        npcHandler:say("You don't have a ".. EXCHANGE_ITEMS[itemId] ..".", cid)
        return
    end
    doPlayerRemoveItem(cid, itemId, 1)
    doPlayerAddItem(cid, CASINO_TICKET_ID, 1)
    npcHandler:say("Done! 1x ".. EXCHANGE_ITEMS[itemId] .." exchanged for 1x casino ticket.", cid)
end

local function tradeAll(cid)
    local totalGiven = 0
    for itemId, _ in pairs(EXCHANGE_ITEMS) do
        local count = getPlayerItemCount(cid, itemId)
        if count > 0 then
            doPlayerRemoveItem(cid, itemId, count)
            doPlayerAddItem(cid, CASINO_TICKET_ID, count)
            totalGiven = totalGiven + count
        end
    end
    if totalGiven > 0 then
        npcHandler:say("All eligible items exchanged. You received ".. totalGiven .." casino ticket(s).", cid)
    else
        npcHandler:say("You have no eligible items to exchange.", cid)
    end
end

local function creatureSayCallback(cid, type, msg)
    if not npcHasFocus(npcHandler, cid) then
        return false
    end

    local text = normalize(msg)

    if text == "hi" or text == "hello" then
        return true
    end

    if text == "list" or text == "items" then
        npcHandler:say("I accept these items (1:1): ".. listItems() ..". Say {trade <item name>} or {trade all}.", cid)
        return true
    end

    if text:find("trade") then
        if text:find("all") then
            tradeAll(cid)
            return true
        end

        local itemId = findExchangeItemIdFromMessage(text)
        if not itemId then
            npcHandler:say("Tell me exactly what to exchange. Example: {trade rainbow shield} or {trade 2523}. Or say {list}.", cid)
            return true
        end

        tradeOne(cid, itemId)
        return true
    end

    if text:find("change") then
        npcHandler:say("Use {trade <item name>} to exchange 1 item for 1 casino ticket, or {trade all} to exchange all eligible items.", cid)
        return true
    end

    return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
