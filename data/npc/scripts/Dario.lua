dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Eventos padrão
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Palavras-chave padrão
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the master archer of the arena. I train distance fighters and sell them equipment."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Dario of Ab'Dendriel."})
keywordHandler:addKeyword({'ammo'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Do you need arrows for a bow, or bolts for a crossbow?"})
keywordHandler:addKeyword({'ammunition'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Do you need arrows for a bow, or bolts for a crossbow?"})

-- TalkState por jogador
local talkState = {}

-- Callback de mensagens
function creatureSayCallback(cid, type, msg)
	if npcHandler.focus ~= cid then
		return false
	end

	local player = Player(cid)
	if not player then return false end

	local msg_l = msg:lower()

	-- Sistema de venda manual de arrows via fala
	if msg_l:match("arrow") then
		local amount = tonumber(msg_l:match("%d+")) or 1
		if amount < 1 then amount = 1 elseif amount > 100 then amount = 100 end

		talkState[cid] = { state = 859, count = amount }
		npcHandler:say("Would you like to buy ".. amount .." arrow(s) for ".. amount * 2 .." gold?", cid)
		return true

	elseif talkState[cid] and talkState[cid].state == 859 then
		if msg_l == "yes" then
			local cost = talkState[cid].count * 2
			if player:removeMoney(cost) then
				player:addItem(2544, talkState[cid].count) -- Arrow
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you don't have enough money.", cid)
			end
			talkState[cid] = nil
			return true

		elseif msg_l == "no" then
			npcHandler:say("Then not.", cid)
			talkState[cid] = nil
			return true
		end
	end

	return true
end

-- Loja padrão (trade window)
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addBuyableItem({'crossbow'}, 2455, 500)
shopModule:addBuyableItem({'power bolt', 'pbolt'}, 2547, 7)
shopModule:addBuyableItem({'bow'}, 2456, 400)
shopModule:addBuyableItem({'bolt'}, 2543, 3)
shopModule:addBuyableItem({'spear'}, 2389, 10)
shopModule:addBuyableItem({'royal spear', 'rspear'}, 7514, 15)
shopModule:addBuyableItem({'arrow'}, 2544, 2)

-- Registrar os callbacks finais
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
