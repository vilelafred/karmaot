dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

	function FocusModule:init(handler)
	FOCUS_GREETSWORDS = {'charach'}
	FOCUS_FAREWELLSWORDS = {'xbxyxeewzzxxwe'}
		self.npcHandler = handler
		for i, word in pairs(FOCUS_GREETSWORDS) do
			local obj = {}
			table.insert(obj, word)
			obj.callback = FOCUS_GREETSWORDS.callback or FocusModule.messageMatcher
			handler.keywordHandler:addKeyword(obj, FocusModule.onGreet, {module = self})
		end
		
		for i, word in pairs(FOCUS_FAREWELLSWORDS) do
			local obj = {}
			table.insert(obj, word)
			obj.callback = FOCUS_FAREWELLSWORDS.callback or FocusModule.messageMatcher
			handler.keywordHandler:addKeyword(obj, FocusModule.onFarewell, {module = self})
		end
		
		return true
	end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end

if msgcontains(msg, 'goshak charcha') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 101
elseif msgcontains(msg, 'goshak burka bata') then
npcHandler:say("Maruk goshak ta?", 1)
talk_state = 103
elseif msgcontains(msg, 'goshak burka') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 102						
elseif msgcontains(msg, 'goshak hakhak') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 104
elseif msgcontains(msg, 'goshak bora') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 105
elseif msgcontains(msg, 'goshak tulak bora') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 106
elseif msgcontains(msg, 'goshak grofa') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 107
elseif msgcontains(msg, 'goshak donga') then
	npcHandler:say("Maruk goshak ta?", 1)
	talk_state = 108	
elseif msgcontains(msg, 'goshak batuk') then
	npcHandler:say("Ahhhh, maruk goshak batuk?", 1)
	talk_state = 109
elseif msgcontains(msg, 'goshak pixo') then
	npcHandler:say("Maruk goshak tefar pixo ul batuk?", 1)
	talk_state = 110
elseif talk_state == 101 and msgcontains(msg, 'mok') == true then
	if doPlayerRemoveMoney(cid, 25) then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2385)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end
elseif talk_state == 102 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 30) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2406)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end
elseif talk_state == 103 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 85) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2376)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end
elseif talk_state == 104 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 85) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2388)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end
elseif talk_state == 105 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 25) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2467)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end	
elseif talk_state == 106 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 90) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2484)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end	
elseif talk_state == 107 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 60) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2482)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end	
elseif talk_state == 108 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 65) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2511)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end	
elseif talk_state == 109 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 400) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2456)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end	
elseif talk_state == 110 and msgcontains(msg, 'mok') then
	if doPlayerRemoveMoney(cid, 30) == true then
	npcHandler:say("Maruk rambo zambo!", 1)
	doPlayerAddItem(cid, 2544, 10)
	talk_state = 806
	else
	npcHandler:say("Maruk nixda!", 1)
	talk_state = 806
	end

if msgcontains(msg, 'potion') and msgcontains(msg, 'regain') and msgcontains(msg, 'vision') or msgcontains(msg, 'Potion') and msgcontains(msg, 'Regain') and msgcontains(msg, 'Vision') then
	npcHandler:say("I heard of a potion of regained vision ... but I can't remember how to make it! Maybe you can help me. Do you know something about it?", 1)
	talk_state = 2
			
elseif talk_state == 2 and msgcontains(msg, 'yes') or talk_state == 2 and msgcontains(msg, 'Yes') then
	npcHandler:say("So, did you bring the ingredients with you, stranger?", 1)
	talk_state = 3
elseif talk_state == 2 and msgcontains(msg, '') then
	npcHandler:say("Oh. Maybe someone else could do it, then.", 1)
	talk_state = 0
	
elseif talk_state == 3 and msgcontains(msg, 'yes') or talk_state == 3 and msgcontains(msg, 'Yes') then
	if doPlayerRemoveItem(cid, 2690, 1) == true and doPlayerRemoveItem(cid, 2692, 1) == true and doPlayerRemoveItem(cid, 2744, 1) == true and doPlayerRemoveItem(cid, 2693, 1) == true and doPlayerRemoveItem(cid, 2679, 1) == true then
	npcHandler:say("You seem to have them with you. Can you tell me, how many minutes I have to cook them?", 1)
	else
	npcHandler:say("It doesn't seem to me as if you have the correct ingredients with you, stranger!", 1)
	end
	talk_state = 4	

keywordHandler:addKeyword({'ikem'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ikem pashak porak, bata, dora. Ba goshak maruk?"})
keywordHandler:addKeyword({'goshak porak'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ikem pashak charcha, burka, burka bata, hakhak. Ba goshak maruk?"})
keywordHandler:addKeyword({'goshak bata'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ikem pashak aka bora, tulak bora, grofa. Ba goshak maruk?"})
keywordHandler:addKeyword({'goshak dora'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ikem pashak donga. Ba goshak maruk?"})
keywordHandler:addKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "huh?"})
keywordHandler:addKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "huh?"})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())