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

-- Vende para o jogador
shopModule:addBuyableItem({'ice rapier'}, 2396, 5000)
shopModule:addBuyableItem({'serpent sword'}, 2409, 6000)
shopModule:addBuyableItem({'ancient shield'}, 2532, 5000)
shopModule:addBuyableItem({'dark armor'}, 2489, 1500)
shopModule:addBuyableItem({'dark helmet'}, 2490, 1000)

-- Compra do jogador
shopModule:addSellableItem({'serpent sword'}, 2409, 900)
shopModule:addSellableItem({'dragon hammer'}, 2434, 2000)
shopModule:addSellableItem({'giant sword'}, 2393, 17000)
shopModule:addSellableItem({'poison dagger'}, 2411, 50)
shopModule:addSellableItem({'scimitar'}, 2419, 150)
shopModule:addSellableItem({'skull staff'}, 2436, 6000)
shopModule:addSellableItem({'knight axe'}, 2430, 2000)
shopModule:addSellableItem({'tower shield'}, 2528, 8000)
shopModule:addSellableItem({'black shield'}, 2529, 800)
shopModule:addSellableItem({'ancient shield'}, 2532, 900)
shopModule:addSellableItem({'vampire shield'}, 2534, 15000)
shopModule:addSellableItem({'warrior helmet'}, 2475, 5000)
shopModule:addSellableItem({'knight armor'}, 2476, 5000)
shopModule:addSellableItem({'knight legs'}, 2477, 5000)
shopModule:addSellableItem({'strange helmet'}, 2479, 500)
shopModule:addSellableItem({'dark armor'}, 2489, 400)
shopModule:addSellableItem({'dark helmet'}, 2490, 250)
shopModule:addSellableItem({'mystic turban'}, 2663, 150)

npcHandler:addModule(FocusModule:new())



function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())