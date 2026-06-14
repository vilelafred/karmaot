dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Shop
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
shopModule:addBuyableItem({'hammer'}, 6562, 20000000, 0, 'smithing hammer')

-- Palavras-chave no estilo clássico
keywordHandler:addKeyword({'job'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "I'm a blacksmith. I forge the finest hammers in the land."
})

keywordHandler:addKeyword({'smith'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Only the strongest tools survive my forge's heat."
})

keywordHandler:addKeyword({'hammer'}, StdModule.say, {
    npcHandler = npcHandler,
    onlyFocus = true,
    text = "Ah, looking for a hammer? I've got one, but it's not cheap."
})

-- Events do NPC
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

npcHandler:addModule(FocusModule:new())
