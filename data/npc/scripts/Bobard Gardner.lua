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

shopModule:addSellableItem({'scale armor'}, 2483, 100, 'scale armor')
shopModule:addSellableItem({'plate armor'}, 2463, 400, 'plate armor')
shopModule:addSellableItem({'golden armor'}, 2486, 1000, 'noble armor')
shopModule:addSellableItem({'knight armor'}, 2476, 3000, 'knight armor')
shopModule:addSellableItem({'dragon armor'}, 5818, 4200, 'dragon armor')

shopModule:addSellableItem({'plate legs'}, 2647, 280, 'plate legs')

shopModule:addSellableItem({'bone shield'}, 25480, 'bone shield')
shopModule:addSellableItem({'dark shield'}, 252400, 'dark shield')
shopModule:addSellableItem({'dwarven shield'}, 2525, 200, 'dwarven shield')
shopModule:addSellableItem({'medusa shield'}, 2536, 8000, 'medusa shield')
shopModule:addSellableItem({'scarab shield'}, 2540, 2000, 'scarab shield')
shopModule:addSellableItem({'dragon shield'}, 2516, 4000, 'scarab shield')

shopModule:addSellableItem({'viking helmet'}, 2473, 77, 'vikig helmet')
shopModule:addSellableItem({'steel helmet'}, 2457, 7500, 'steel helmet')
shopModule:addSellableItem({'devil helmet'}, 2462, 1000, 'devil helmet')
shopModule:addSellableItem({'dark helmet'}, 2490, 200, 'dark helmet')
shopModule:addSellableItem({'warrior helmet'}, 2475, 5000, 'warrior helmet')
shopModule:addSellableItem({'warrior helmet'}, 2460, 39, 'brass helmet')


shopModule:addSellableItem({'boots of haste'}, 3892, 60000, 'boots of haste')
shopModule:addSellableItem({'steel boots'}, 2645, 30000, 'steel boots')

shopModule:addSellableItem({'mace'}, 2398, 40, 'mace')
shopModule:addSellableItem({'serpent sword'}, 2439, 910, 'serpent sword')
shopModule:addSellableItem({'spike sword'}, 2383, 600, 'spide sword')
shopModule:addSellableItem({'bow'}, 2456, 90, 'bow')
shopModule:addSellableItem({'crossbow'}, 2455, 120, 'crossbow')
shopModule:addSellableItem({'silver dagger'}, 2402, 500, 'silver dagger')
shopModule:addSellableItem({'war axe'}, 2454, 9000, 'war axe')

shopModule:addSellableItem({'crystal necklace'}, 2125, 400, 'crystal necklace')
shopModule:addSellableItem({'crystal ring'}, 2124, 250, 'crystal ring')
shopModule:addSellableItem({'emerald bangle'}, 2127, 800, 'emerald bangle')
shopModule:addSellableItem({'platinum amulet'}, 2172, 500, 'platinum amulet')
shopModule:addSellableItem({'ring of the sky'}, 2123, 30000, 'ring of the sky')
shopModule:addSellableItem({'ruby necklace'}, 2133, 2000, 'ruby necklace')

shopModule:addSellableItem({'doll'},2100 , 200, 'doll')
shopModule:addSellableItem({'voodoo doll'}, 3955, 400, 'voodoo doll')

end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())