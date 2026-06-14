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
	
	if msgcontains(msg, 'brooch') then
		npcHandler:say('What? You want me to examine a brooch?')
		topic = 1	
	elseif msgcontains(msg, 'yes') and topic == 1 then
		if getPlayerItemCount(cid, 2318) >= 1 then
			npcHandler:say('You have recovered my brooch! I shall forever be in your debt, my friend!')
			doPlayerTakeItem(cid,2318,10)
			setPlayerStorageValue(cid,99999,1)
			topic = 2
		else
			topic = 0
			npcHandler:say('You no have broonch')
		end
	elseif msgcontains(msg, 'royal island') then
		npcHandler:say('I can sail you to the Royal Island for 150 gold. Is that okay for you?')
		topic = 3
	elseif msgcontains(msg, 'yes') and topic == 3 then
		if getPlayerMoney(cid) >= 150 then
			selfSay('Have a nice trip!')
			doPlayerRemoveMoney(cid, 150)
			doTeleportThing(cid, {x = 31837, y = 32461, z = 7})  
			doSendMagicEffect(getCreaturePosition(cid), 11)
			topic = 0
		else
			npcHandler:say('You don\'t have enough money.')
			topic = 0
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
