local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Storage local para topics (ao invés de usar npcHandler.topic)
local playerTopics = {}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) 
    npcHandler:onCreatureDisappear(cid)
    playerTopics[cid] = nil
end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- NOVO SISTEMA: Preços dinâmicos (10kk primeira, 15kk segunda)
local PRICE_FIRST = 10000000  -- 10kk para primeira stone
local PRICE_SECOND = 15000000 -- 15kk para segunda stone
local PRICE_CLEANSING = 5000000 -- 5kk para cleansing stone

-- Karma stones mapped to ids from upgrade system
local stones = {
    { names = {'physical protection stone', 'physical stone'}, id = 8277, element = "physical" },
    { names = {'energy protection stone', 'energy stone'}, id = 8280, element = "energy" },
    { names = {'earth protection stone', 'earth stone'}, id = 8276, element = "earth" },
    { names = {'fire protection stone', 'fire stone'}, id = 8282, element = "fire" },
    { names = {'ice protection stone', 'ice stone'}, id = 8278, element = "ice" },
    { names = {'holy protection stone', 'holy stone'}, id = 8279, element = "holy" },	
    { names = {'death protection stone', 'death stone'}, id = 8283, element = "death" },
    { names = {'cleansing stone', 'clean stone', 'remover'}, id = 8281, element = "cleansing", isCleansing = true }
}

-- Função para checar quantas stones o player tem ativas (SISTEMA V3 - baseado no item)
local function getActiveStoneCount(player)
	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	if not amulet then
		return 0
	end
	
	local itemId = amulet:getId()
	if itemId ~= 6161 and itemId ~= 6550 and itemId ~= 6525 then
		return 0 -- Not a Karma Amulet
	end
	
	local data = amulet:getCustomAttribute("karma_stones")
	if not data or data == "" then
		return 0
	end
	
	local success, stones = pcall(json.decode, data)
	if not success or type(stones) ~= "table" then
		return 0
	end
	
	local count = 0
	for _, stone in pairs(stones) do
		if stone.remaining and stone.remaining > 0 then
			count = count + 1
		end
	end
	
	return count
end

-- Função de compra customizada com preço dinâmico
local function onBuyStone(cid, itemId, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	if not player then
		return false
	end

	-- Determina o preço baseado em quantas stones o player já tem
	local activeCount = getActiveStoneCount(player)
	
	-- Cleansing stone has fixed price
	if itemId == 8281 then
		price = PRICE_CLEANSING
	else
		price = (activeCount == 0) and PRICE_FIRST or PRICE_SECOND
	end

	-- Check if player has enough gold
	if not player:removeMoney(price * amount) then
		player:sendCancelMessage("You don't have enough gold.")
		return false
	end

	-- Create the item
	local item = player:addItem(itemId, amount)
	if not item then
		player:addMoney(price * amount) -- Refund
		player:sendCancelMessage("You don't have enough space.")
		return false
	end

	-- Feedback
	local stoneName = ItemType(itemId):getName()
	local priceText = (activeCount == 0) and "10kk" or "15kk"
	player:sendTextMessage(MESSAGE_INFO_DESCR, 
		string.format("You bought %s for %s. Use it on your equipped Karma Amulet!", stoneName, priceText))
	
	return true
end

-- Registra stones com callback customizado
for _, s in ipairs(stones) do
	-- Não usa shopModule padrão, usa callback customizado
end

-- Story and help
local function lore()
    return table.concat({
        "Ahoy! I'm the quartermaster aboard the Karma Boat, under Captain Jack Sparrow.",
        "I've bartered with sea witches and storm spirits to bottle elemental karma into stones.",
        "These stones were distilled specifically to empower the *Karma Amulet*."
    }, " \n")
end

local function help()
    return table.concat({
        "How it works:",
        "- Each stone grants +10% resistance of its element for 4 hours of ACTIVE use.",
        "- First stone costs 10kk, second stone costs 15kk.",
        "- Equip your Karma Amulet FIRST, then use the stone.",
        "- Time only counts while the Karma Amulet is equipped!",
        "- You can have up to 2 different elemental stones active simultaneously.",
        "- Use !karma to check your active bonuses and time remaining.",
        "IMPORTANT: Stones work ONLY on the Karma Amulet. They have no effect on any other item."
    }, " \n")
end

local function list(cid)
	local player = Player(cid)
	local activeCount = getActiveStoneCount(player)
	local price = (activeCount == 0) and "10kk" or "15kk"
	
    local lines = {
        "My cargo today:",
        string.format("Price: %s (first stone: 10kk, second: 15kk)", price),
        "(Note: These stones work ONLY on the Karma Amulet.)",
        ""
    }
    for _, s in ipairs(stones) do
        if s.isCleansing then
            lines[#lines + 1] = string.format("- %s (removes all active stones) - 5kk", s.names[1])
        else
            lines[#lines + 1] = string.format("- %s (+10%% %s, 4h active use)", s.names[1], s.element)
        end
    end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "Say the stone name to buy it."
    return table.concat(lines, " \n")
end

local function greetCallback(cid)
    npcHandler:say("Welcome aboard the Karma Boat, matey. Ask me about 'stones', 'offer', 'help', or 'story'. Stones work ONLY on the Karma Amulet and grant +10% resistance for 4 hours of active use!", cid)
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

local function creatureSayCallback(cid, type, msg)
    if npcHandler.focus ~= cid then
        return false
    end
    msg = msg:lower()
    
    if msg:find('help') then
        npcHandler:say(help(), cid)
        return true
    elseif msg:find('story') or msg:find('lore') then
        npcHandler:say(lore(), cid)
        return true
    elseif msg:find('offer') or msg:find('stones') or msg:find('list') or msg:find('trade') then
        npcHandler:say(list(cid), cid)
        return true
    end
    
    -- Verifica se é uma tentativa de compra de stone
    for _, stone in ipairs(stones) do
        for _, name in ipairs(stone.names) do
            if msg:find(name) then
                local player = Player(cid)
                if not player then
                    return false
                end
                
                local activeCount = getActiveStoneCount(player)
                local price, priceText
                
                if stone.isCleansing then
                    price = PRICE_CLEANSING
                    priceText = "5kk"
                else
                    price = (activeCount == 0) and PRICE_FIRST or PRICE_SECOND
                    priceText = (activeCount == 0) and "10kk" or "15kk"
                end
                
                npcHandler:say(string.format("Do you want to buy a %s for %s?", stone.names[1], priceText), cid)
                playerTopics[cid] = stone.id
                return true
            end
        end
    end
    
    -- Confirmação de compra
    if msgcontains(msg, 'yes') and playerTopics[cid] then
        local itemId = playerTopics[cid]
        if onBuyStone(cid, itemId, 0, 1, false, false) then
            npcHandler:say("There you go! Remember: use it on the Karma Amulet while equipped. Time only runs when the amulet is on!", cid)
        else
            npcHandler:say("You don't have enough gold or inventory space.", cid)
        end
        playerTopics[cid] = nil
        return true
    elseif msgcontains(msg, 'no') and playerTopics[cid] then
        npcHandler:say("No problem! Let me know if you need anything else.", cid)
        playerTopics[cid] = nil
        return true
    end
    
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
