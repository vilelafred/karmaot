local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- ITENS QUE O NPC COMPRA
shopModule:addSellableItem({'might ring'}, 2164, 250, 20)
shopModule:addSellableItem({'energy ring'}, 2167, 100)
shopModule:addSellableItem({'life ring'}, 2168, 50)
shopModule:addSellableItem({'time ring'}, 2169, 100)
shopModule:addSellableItem({'silver amulet'}, 2170, 50, 200)
shopModule:addSellableItem({'strange talisman'}, 2161, 30, 200)
shopModule:addSellableItem({'dwarven ring'}, 2213, 100)
shopModule:addSellableItem({'ring of healing'}, 2214, 100)
shopModule:addSellableItem({'protection amulet'}, 2200, 100, 250)
shopModule:addSellableItem({'dragon necklace'}, 2201, 100, 200)
shopModule:addSellableItem({'mysterious fetish'}, 2194, 50)
shopModule:addSellableItem({'ankh'}, 2193, 100)
shopModule:addSellableItem({'snakebite rod'}, 2182, 100)
shopModule:addSellableItem({'moonlight rod'}, 2186, 200)
shopModule:addSellableItem({'volcanic rod'}, 2185, 1000)
shopModule:addSellableItem({'quagmire rod'}, 2181, 2000)
shopModule:addSellableItem({'tempest rod'}, 2183, 3000)

-- ITENS QUE O NPC VENDE
shopModule:addBuyableItem({'might ring'}, 2164, 5000, 20)
shopModule:addBuyableItem({'energy ring'}, 2167, 2000)
shopModule:addBuyableItem({'life ring'}, 2168, 900)
shopModule:addBuyableItem({'time ring'}, 2169, 2000)
shopModule:addBuyableItem({'silver amulet'}, 2170, 100, 200)
shopModule:addBuyableItem({'strange talisman'}, 2161, 100, 200)
shopModule:addBuyableItem({'dwarven ring'}, 2213, 2000)
shopModule:addBuyableItem({'ring of healing'}, 2214, 2000)
shopModule:addBuyableItem({'protection amulet'}, 2200, 700, 250)
shopModule:addBuyableItem({'dragon necklace'}, 2201, 1000, 200)

-- FOCUS
npcHandler:addModule(FocusModule:new())

-- CALLBACK (caso você queira adicionar falas personalizadas depois)
function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
