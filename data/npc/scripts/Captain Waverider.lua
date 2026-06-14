dofile('data/npc/lib/greeting.lua')


local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end


function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	if msgcontains(msg, 'treasure island') or msgcontains(msg, 'island') then
	npcHandler:say('Hey mate! So you are looking for a passage to the treasure island for 80 gold?')
	talk_state = 1

	elseif msgcontains(msg,'yes') and talk_state == 1 then
	if 1 == 1 then
		if getCreatureCondition(cid, CONDITION_INFIGHT) ~= 1 then
			if getPlayerMoney(cid) >= 80 then
				selfSay('Have a nice trip!')
				doPlayerRemoveMoney(cid, 280)
				doTeleportThing(cid, {x = 32023, y = 32972, z = 7})
				doSendMagicEffect(getCreaturePosition(cid), 11)
				talk_state = 0
			else
				npcHandler:say('You don\'t have enough money.')
				talk_state = 0
			end
		else
			npcHandler:say('First get rid of those blood stains! You are not going to ruin my vehicle!')
			talk_state = 0
		end
	else
	npcHandler:say('Without the abbots permission I won\'t take sail you anywhere! Go and ask him for a passage first.')
	talk_state = 0
	end
end
		
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, daring adventurer. If you need a passage to {treasure island}, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
