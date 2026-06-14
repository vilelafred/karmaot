dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- Antidote rune
shopModule:addBuyableItem({'antidote', 'antidote rune'}, 2266, 40)

-- Palavras-chave
keywordHandler:addKeyword({'how are you'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Very well. Thank you."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I only sell my antidote runes and I'll be happy to buy some blueberries from you."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am a druid, bound to the spirit of nature. I'm selling antidote runes that help against poison. Oh, and I buy blueberries, of course."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Lily."})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Hyacinth lives in the forest. He's never in town so I don't know him very well."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can sell you an antidote rune. It's against the poison of so many dangerous creatures."})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Many monsters are poisonous. Don't let them bite you or you will need one of my antidote runes."})
keywordHandler:addKeyword({'creature'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Many monsters are poisonous. Don't let them bite you or you will need one of my antidote runes."})
keywordHandler:addKeyword({'poison'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Many monsters are poisonous. Don't let them bite you or you will need one of my antidote runes."})
keywordHandler:addKeyword({'life fluid'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm sorry, but Hyacinth is the only one on Rookgaard who knows how to brew life fluids."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is about |TIME|."})

-- Estados de conversa por jogador
local talk_state = {}

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isPlayerFocused(cid) then return false end

	local player = Player(cid)
	local msg_lc = msg:lower()

	-- Venda de blueberries
	if msgcontains(msg_lc, 'blueberry') or msgcontains(msg_lc, 'blueberries') then
		npcHandler:say("Do you want to sell 5 blueberries for 1 gold?", cid)
		talk_state[cid] = 301

	elseif talk_state[cid] == 301 and msgcontains(msg_lc, 'yes') then
		if player:removeItem(2677, 5) then
			player:addMoney(1)
			npcHandler:say("Here is your gold coin.", cid)
		else
			npcHandler:say("Oh, I'm sorry. I'm not buying less than 5 blueberries.", cid)
		end
		talk_state[cid] = nil

	-- Troca de ruby
	elseif msgcontains(msg_lc, 'trocar ruby') or msgcontains(msg_lc, 'exchange ruby') then
		npcHandler:say("Do you want to trade your Small Ruby for a Rooker Ruby?", cid)
		talk_state[cid] = 302

	elseif talk_state[cid] == 302 and msgcontains(msg_lc, 'yes') then
		if player:removeItem(2147, 1) then
			player:addItem(5840, 1)
			npcHandler:say("Here is your Rooker Ruby.", cid)
		else
			npcHandler:say("You don't have a Small Ruby to trade.", cid)
		end
		talk_state[cid] = nil

	elseif msgcontains(msg_lc, 'no') then
		npcHandler:say("As you wish.", cid)
		talk_state[cid] = nil
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
