dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Cria o módulo de venda
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- Assassin Star por 100 gp cada
shopModule:addBuyableItem({'assassin star', 'star'}, 7696, 100, 'assassin star')

-- Palavras-chave básicas
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm Xodet, master of silent weapons."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I sell only one thing: assassin stars, fast and deadly."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm selling assassin stars for 100 gold coins each."})

-- Finaliza configuração
npcHandler:addModule(FocusModule:new())
