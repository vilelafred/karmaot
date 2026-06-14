dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)


shopModule:addBuyableItem({'sudden death backpack'}, 5874, 2000)
shopModule:addBuyableItem({'ultimate healing backpack'}, 5875, 2000)
shopModule:addBuyableItem({'magic wall backpack'}, 5876, 2000)
shopModule:addBuyableItem({'explosion backpack'}, 5877, 2000)
shopModule:addBuyableItem({'great fireball'}, 5879, 2000)
shopModule:addBuyableItem({'heavy magic missile backpack'}, 5882, 2000)


keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am selling equipment of all kinds. Do you need anything?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name and sarah, I'm a new adventurer in this world.."})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "No, I don't sell food."})
keywordHandler:addKeyword({'ghostlands'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Be careful, this place and haunted."})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I sell manys backpacks."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I sell backpacks."})
keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I have the following backpacks: sudden death backpack, ultimate healing backpack, magic wall backpack, explosion backpack, great fireball backpack, heavy magic missile backpack. ."})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ive also passed this island, i've gathered all the money I've got there."})
keywordHandler:addKeyword({'monsters'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Carlin is a city protected by powerful druids, don't be afraid."})
keywordHandler:addKeyword({'druids'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "the druids protect, and take care of carlin's people, but lately they seem worried.."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is exactly |TIME|. Maybe you want to buy a watch"})
keywordHandler:addKeyword({'queen'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Our queen is a druid with unique powers.."})
keywordHandler:addKeyword({'princess'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I've heard rumors that princesses from every city are coming together to fight something."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())