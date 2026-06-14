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
    [7632] = "rainbow shield",
    [2523] = "blessed shield",	
    [8323] = "lucky ring",
    [6613] = "royal customer outfit",
	[6799] = "banshee outfit",
    [6850] = "thaddeus scroll",
    [6835] = "rashid scroll",	
    [6838] = "bless scroll",
    [6781] = "15 days of premium account",
    [6782] = "30 days of premium account",
    [2474] = "winged helmet",
    [6181] = "multi tool",
    [5806] = "love ring",
    [6801] = "karma surprise bag",		
    [6694] = "dwarf geomancer outfit",		
    [5807] = "blessed golden ring",	
    [6698] = "exp boost",
    [6606] =  "mystic converter",	
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
        parts[#parts+1] = name
    end
    table.sort(parts)
    return table.concat(parts, ",\n")
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
    
    -- Verifica se o item está equipado
    local player = Player(cid)
    local isEquipped = false
    local slots = {CONST_SLOT_HEAD, CONST_SLOT_NECKLACE, CONST_SLOT_BACKPACK, CONST_SLOT_ARMOR, CONST_SLOT_RIGHT, CONST_SLOT_LEFT, CONST_SLOT_LEGS, CONST_SLOT_FEET, CONST_SLOT_FINGER, CONST_SLOT_AMMO}
    for _, slot in ipairs(slots) do
        local equippedItem = player:getSlotItem(slot)
        if equippedItem and equippedItem:getId() == itemId then
            isEquipped = true
            break
        end
    end
    
    if isEquipped then
        npcHandler:say("I cannot exchange ".. EXCHANGE_ITEMS[itemId] .." because it is equipped. Please unequip it first.", cid)
        return
    end
    
    -- Verifica se é uma backpack e se está vazia
    if itemId == 5861 then -- cupid backpack
        local backpack = player:getItemById(itemId, true)
        if backpack then
            -- Verifica se é um container verificando se tem o método getContainer
            if backpack.getContainer then
                local container = backpack:getContainer()
                if container and container:getSize() > 0 then
                    npcHandler:say("I cannot exchange the cupid backpack because it contains items. Please empty it first.", cid)
                    return
                end
            end
        end
    end
    
    -- Verifica se o jogador tem capacidade suficiente
    if getPlayerFreeCap(cid) < getItemWeight(CASINO_TICKET_ID, 1) then
        npcHandler:say("You don't have enough capacity to carry the casino ticket.", cid)
        return
    end
    
    -- Tenta adicionar o casino ticket primeiro
    local addedItem = doPlayerAddItem(cid, CASINO_TICKET_ID, 1)
    if not addedItem then
        npcHandler:say("You don't have enough space in your inventory.", cid)
        return
    end
    
    -- Se conseguiu adicionar, remove o item original
    doPlayerRemoveItem(cid, itemId, 1)
    npcHandler:say("Done! 1x ".. EXCHANGE_ITEMS[itemId] .." exchanged for 1x casino ticket.", cid)
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
        npcHandler:say("I accept these items (1:1):\n".. listItems() .."\n\nSay {trade <item name>} to exchange an item.", cid)
        return true
    end

    if text:find("trade") then
        local itemId = findExchangeItemIdFromMessage(text)
        if not itemId then
            npcHandler:say("Tell me exactly what to exchange. Example: {trade rainbow shield}. Or say {list} to see all available items.", cid)
            return true
        end

        tradeOne(cid, itemId)
        return true
    end

    if text:find("change") then
        npcHandler:say("Use {trade <item name>} to exchange 1 item for 1 casino ticket.", cid)
        return true
    end

    return false
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
