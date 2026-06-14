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

shopModule:addSellableItem({'spike sword'}, 2383, 1000)
shopModule:addSellableItem({'fire sword'}, 2392, 4000)
shopModule:addSellableItem({'war hammer'}, 2391, 1200)
shopModule:addSellableItem({'ice rapier'}, 2396, 1000)
shopModule:addSellableItem({'broad sword'}, 2413, 500)
shopModule:addSellableItem({'dragon lance'}, 2414, 9000)
shopModule:addSellableItem({'obsidian lance'}, 2425, 500)
shopModule:addSellableItem({'fire axe'}, 2432, 8000)
shopModule:addSellableItem({'guardian shield'}, 2515, 2000)
shopModule:addSellableItem({'dragon shield'}, 2516, 4000)
shopModule:addSellableItem({'beholder shield'}, 2518, 1200)
shopModule:addSellableItem({'crown shield', 'c shield'}, 2519, 8000)
shopModule:addSellableItem({'phoenix shield'}, 2539, 16000)
shopModule:addSellableItem({'noble armor'}, 2486, 900)
shopModule:addSellableItem({'crown armor'}, 2487, 12000)
shopModule:addSellableItem({'crown legs'}, 2488, 12000)
shopModule:addSellableItem({'crown helmet'}, 2491, 2500)
shopModule:addSellableItem({'crusader helmet'}, 2497, 6000)
shopModule:addSellableItem({'royal helmet'}, 2498, 30000)
shopModule:addSellableItem({'blue robe'}, 2656, 10000)
shopModule:addSellableItem({'boots of haste'}, 2195, 30000)
shopModule:addSellableItem({'dragon scale mail'}, 2492, 40000)

shopModule:addBuyableItem({'spike sword'}, 2383, 8000)
shopModule:addBuyableItem({'war hammer'}, 2391, 10000)
shopModule:addBuyableItem({'obsidian lance'}, 2425, 3000)
shopModule:addBuyableItem({'beholder shield'}, 2518, 7000)
shopModule:addBuyableItem({'noble armor'}, 2486, 8000)

npcHandler:addModule(FocusModule:new())


function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())