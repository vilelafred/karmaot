dofile(getDataDir() .. 'npc/scripts/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

function greetCallback(cid)
if getCreatureHealth(cid) <= 39 then
	npcHandler:setMessage(MESSAGE_GREET, "You are looking really bad, ".. getPlayerName(cid) ..". Let me heal your wounds.")
	doCreatureAddHealth(cid, -getCreatureHealth(cid)+40)
	doSendMagicEffect(getPlayerPosition(cid), 12)
	talk_state = 0
	return true
	else
	npcHandler:setMessage(MESSAGE_GREET, "Welcome, child of nature.")
	return true
	end
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am a guardian of nature. Also I am the keeper of the embrace of tibia, one of the five blessings."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Humphrey."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Now, it is |TIME|. Ask Gorn for a watch, if you need one."})

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end

if msgcontains(msg, 'heal') then
if getCreatureHealth(cid) <= 39 then
	npcHandler:say("You are looking really bad. Let me heal your wounds.", 1)
	doCreatureAddHealth(cid, -getCreatureHealth(cid)+40)
	doSendMagicEffect(getPlayerPosition(cid), 12)
	talk_state = 0
	return true
	else
	npcHandler:say("You aren't looking really bad. Sorry, I can't help you.", 1)
	return true
	end
	talk_state = 0
end		
	if(npcHandler.focus ~= cid) then
		return false
	end	
	
if msgcontains(msg, 'bless') then
	npcHandler:say("There are five different blessings available in five sacred places. These blessings are: the spiritual shielding, the spark of the phoenix, the embrace of tibia, the fire of the suns and the wisdom of solitude.", 1)
	talk_state = 0

elseif msgcontains(msg, 'embrace') or msgcontains(msg, 'of tibia') then
	npcHandler:say("I will give to you the embrace of tibia, but you will have to make a sacrifice. Are you prepared to pay 10.000 gold for the blessing?", 1)
	talk_state = 1394


elseif talk_state == 1394 and msgcontains(msg, 'yes') then
	if doPlayerRemoveMoney(cid, 10000) == true then
		if doPlayerAddBless(cid, 2) == true then
		npcHandler:say("So receive the embrace of tibia, pilgrim.", 1)
		doSendMagicEffect(getPlayerPosition(cid), 13)
		setPlayerStorageValue(cid, 30006, 1)
		talk_state = 0		
		else
		doPlayerAddMoney(cid, 10000)
		npcHandler:say("You already possess this blessing.", 1)
		talk_state = 0			
		end
	else
	npcHandler:say("Oh. You do not have enough money.", 1)
	talk_state = 0	
	end
	
	
	elseif msgcontains(msg, 'spark') or msgcontains(msg, 'phoenix') then
	npcHandler:say("The spark of the phoenix is given by me and by the great pyromancer in the nearby firetemple. Do you wish to receive my part of the blessing of the phoenix?", 1)
	talk_state = 1395


elseif talk_state == 1395 and msgcontains(msg, 'yes') then
	if getPlayerStorageValue(cid, 1339) <= 0 then
	setPlayerStorageValue(cid, 1339, 1)
	npcHandler:say("So receive the blessing of the live-giving earth, pilgrim.", 1)
	doSendMagicEffect(getPlayerPosition(cid), 13)
	talk_state = 0		
	else
	npcHandler:say("You already possess my blessing.", 1)
	talk_state = 0			
	end
	
elseif talk_state == 1396 and msgcontains(msg, '') then
	npcHandler:say("Ok. If you don't want it ... .", 1)
	talk_state = 0
	
	elseif msgcontains(msg, 'spiritual') or msgcontains(msg, 'shielding') then
	npcHandler:say("Here in the whiteflower temple you may receive the blessing of spiritual shielding. But we must ask of you to sacrifice 10.000 gold. Are you still interested?", 1)
	talk_state = 1394


elseif talk_state == 1396 and msgcontains(msg, 'yes') then
	if doPlayerRemoveMoney(cid, 10000) == true then
		if doPlayerAddBless(cid, 1) == true then
		npcHandler:say("So receive the shielding of your spirit, pilgrim.", 1)
		doSendMagicEffect(getPlayerPosition(cid), 13)
		setPlayerStorageValue(cid, 30006, 1)
		talk_state = 0		
		else
		doPlayerAddMoney(cid, 10000)
		npcHandler:say("You already possess this blessing.", 1)
		talk_state = 0			
		end
	else
	npcHandler:say("Oh. You do not have enough money.", 1)
	talk_state = 0	
	end

elseif msgcontains(msg, 'wisdom') or msgcontains(msg, 'solitude') then
		npcHandler:say("I can provide you with the wisdom of solitude. But you will have to sacrifice 10.000 gold to receive it. Are you still interested?", 1)
		talk_state = 1397


	elseif talk_state == 1397 and msgcontains(msg, 'yes') then
		if doPlayerRemoveMoney(cid, 10000) == true then
			if doPlayerAddBless(cid, 4) == true then
				npcHandler:say("So receive the wisdom of solitude, pilgrim", 1)
				doSendMagicEffect(getPlayerPosition(cid), 13)
				setPlayerStorageValue(cid, 30006, 1)
				talk_state = 0		
			else
				doPlayerAddMoney(cid, 10000)
				npcHandler:say("You already possess this blessing.", 1)
				talk_state = 0			
			end
		else
			npcHandler:say("Oh. You do not have enough money.", 1)
			talk_state = 0	
		end
		
		elseif msgcontains(msg, 'embrace') or msgcontains(msg, 'of tibia') then
	npcHandler:say("I will give to you the embrace of tibia, but you will have to make a sacrifice. Are you prepared to pay 10.000 gold for the blessing?", 1)
	talk_state = 1398


elseif talk_state == 1398 and msgcontains(msg, 'yes') then
	if doPlayerRemoveMoney(cid, 10000) == true then
		if doPlayerAddBless(cid, 2) == true then
		npcHandler:say("So receive the embrace of tibia, pilgrim.", 1)
		doSendMagicEffect(getPlayerPosition(cid), 13)
		setPlayerStorageValue(cid, 30006, 1)
		talk_state = 0		
		else
		doPlayerAddMoney(cid, 10000)
		npcHandler:say("You already possess this blessing.", 1)
		talk_state = 0			
		end
	else
	npcHandler:say("Oh. You do not have enough money.", 1)
	talk_state = 0	
	end
	
elseif talk_state == 1398 and msgcontains(msg, '') then
	npcHandler:say("Ok. Suits me.", 1)
	talk_state = 0	
	
elseif talk_state == 1394 and msgcontains(msg, '') then
	npcHandler:say("Ok. Suits me.", 1)
	talk_state = 0	
	
elseif msgcontains(msg, 'phoenix') then
	npcHandler:say("The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon.", 1)
	talk_state = 0
	
elseif msgcontains(msg, 'embrace') then
	npcHandler:say("The druids north of Carlin will provide you with the embrace of tibia.", 1)
	talk_state = 0
	
elseif msgcontains(msg, 'suns') then
	npcHandler:say("You can ask for the blessing of the two suns in the suntower near Ab'Dendriel.", 1)
	talk_state = 0
	
elseif msgcontains(msg, 'wisdom') then
	npcHandler:say("Talk to the hermit Eremo on the isle of Cormaya about this blessing.", 1)
	talk_state = 0
	
elseif msgcontains(msg, 'spiritual') then
	npcHandler:say("You can ask for the blessing of spiritual shielding the whiteflower temple south of Thais.", 1)
	talk_state = 0
end	
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())