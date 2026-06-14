local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- WANDS (Sorcerer) - até a versão 8.0
shopModule:addBuyableItem({{'wand of vortex'}}, 2190, 500, 'wand of vortex')
shopModule:addBuyableItem({{'wand of dragonbreath'}}, 2191, 1000, 'wand of dragonbreath')
shopModule:addBuyableItem({{'wand of plague'}}, 2188, 5000, 'wand of plague')
shopModule:addBuyableItem({{'wand of cosmic energy'}}, 2189, 10000, 'wand of cosmic energy')
shopModule:addBuyableItem({{'wand of inferno'}}, 2187, 15000, 'wand of inferno')

-- RODS (Druid)
shopModule:addBuyableItem({{'snakebite rod'}}, 2182, 500, 'snakebite rod')
shopModule:addBuyableItem({{'moonlight rod'}}, 2186, 1000, 'moonlight rod')
shopModule:addBuyableItem({{'volcanic rod'}}, 2185, 5000, 'volcanic rod')
shopModule:addBuyableItem({{'quagmire rod'}}, 2181, 10000, 'quagmire rod')
shopModule:addBuyableItem({{'tempest rod'}}, 2183, 15000, 'tempest rod')

npcHandler:addModule(FocusModule:new())
