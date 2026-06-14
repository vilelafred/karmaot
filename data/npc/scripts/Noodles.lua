dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

npcHandler:setMessage(MESSAGE_GREET, '<sniff> Woof! <sniff>')
npcHandler:setMessage(MESSAGE_PLACEDINQUEUE, 'Grrr! Woof!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Woof?? <sniff> <sniff>')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Woof! <wiggle>')

keywordHandler:addKeyword({'cat','queen','eloise'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'GRRRRRRR! WOOOOOOF! WOOOOOF! WOOOOOF!'})	
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Meeep! Meeep!'})
--keywordHandler:addKeyword({'th'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = '<sniff>'})
keywordHandler:addKeyword({'ar'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Woof!'})
keywordHandler:addKeyword({'bo'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = '<wiggle>'})
--keywordHandler:addKeyword({'an'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Grrrr!'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Woof! Woof!'})
keywordHandler:addKeyword({'how are you','king','tibianus'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Wooooof! <wiggle> <wiggle> <wiggle>'})

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	-- The Postman Missions Quest
	if(msgcontains(msg, "banana skin") or msgcontains(msg, "sniff banana skin")) then
		if(getPlayerStorageValue(cid, 233) == 7) then
			if(getPlayerItemCount(cid, 2219) >= 1) then
				npcHandler:say("<sniff><sniff> ", cid)
				npcHandlerfocus = 1
			end
		end
	elseif(msgcontains(msg, "dirty fur") or msgcontains(msg, "sniff dirty fur")) then
		if(getPlayerStorageValue(cid, 250) == 20) then
			if(getPlayerItemCount(cid, 2220) >= 1) then
				npcHandler:say("<sniff><sniff> ", cid)
				npcHandlerfocus = 2
			end
		end
	elseif(msgcontains(msg, "mouldy cheese") or msgcontains(msg, "sniff mouldy cheese")) then
		if(getPlayerStorageValue(cid, 250) == 21) then
			if(getPlayerItemCount(cid, 2235) >= 1) then
				npcHandler:say("<sniff><sniff> ", cid)
				npcHandlerfocus = 3
			end
		end
	elseif(msgcontains(msg, "yes") or msgcontains(msg, "do you like that")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("Woof!", cid)
			setPlayerStorageValue(cid, 250, 20)
			npcHandlerfocus = 0
		elseif(npcHandlerfocus == 2) then
			npcHandler:say("Woof!", cid)
			setPlayerStorageValue(cid, 250, 21)
			npcHandlerfocus = 0
		elseif(npcHandlerfocus == 3) then
			npcHandler:say("Meeep! Grrrrr! <spits> ", cid)
			setPlayerStorageValue(cid,233,8)
			npcHandlerfocus = 0
		end
	end

	return true
end	
	
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())