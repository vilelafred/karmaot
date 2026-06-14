local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)	npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)	npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'My name is not of your concern.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'That\'s only my business, not yours.'})

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	if msgcontains(msg, 'avalon shield') then
		npcHandler:say('What? You want me to examine a avalon shield?')
		topic = 1	
	elseif msgcontains(msg, 'yes') and topic == 1 then
		if getPlayerItemCount(cid, 5090) >= 1 then
			npcHandler:say('You have recovered avalon ring! I shall forever be in your debt, my friend!')
			doPlayerTakeItem(cid,5090,1)
			setPlayerStorageValue(cid,99998,1)
			topic = 2
		else
			topic = 0
			npcHandler:say('You no have avalon shield')
		end
	elseif msgcontains(msg, 'passage') then
		if getPlayerStorageValue(cid, 99998) == 1 then			
			npcHandler:say('Since you are my friend now I will sail you to the isle of the kings for free. Is that okay for you?')
			topic = 3
		else
			npcHandler:say('You are not my friend.')
			topic = 0
		end
	elseif msgcontains(msg, 'yes') and topic == 3 then
		if getPlayerStorageValue(cid,99998) == 1 then
			npcHandler:say('Have a nice trip!')
			doTeleportThing(cid, {x=32446,y=31831,z=7})
			doSendMagicEffect(getCreaturePosition(cid), 10)
			topic = 0
		else
			npcHandler:say('You can\'t travel without my permission')
			topic = 0
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
