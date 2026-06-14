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
	
	-- The Postman Missions Quest	
local npcPos = getCreaturePosition(getNpcCid())
	
	if(msgcontains(msg, "bill")) then
		if(npcHandlerfocus == 5) then
			npcHandler:say("A bill? Oh boy so you are delivering another bill to poor me? ", cid)
			npcHandlerfocus = 6
		end
	elseif(msgcontains(msg, "yes") and getPlayerItemCount(cid, 1952) >= 1) then
		if(npcHandlerfocus == 6) then
			npcHandler:say("Ok, ok, I'll take it. I guess I have no other choice anyways. And now leave me alone in my misery please. ", cid)
			npcHandler:say("Still I am better in vanishing!", cid)			
			npcHandlerfocus = 0
			doPlayerRemoveItem(cid, 1952, 1)
			setPlayerStorageValue(cid, 229, 3)
		end
	elseif(msgcontains(msg, "hat")) then
		if(getPlayerStorageValue(cid, 229) == 1 and getPlayerStorageValue(cid, 1111250) < 1) then
			npcHandler:say("What? My hat?? Theres... nothing special about it! ", cid)
			npcHandlerfocus = 2
		elseif(npcHandlerfocus == 2) then
			npcHandler:say("Stop bugging me about that hat, do you listen? ", cid)
			npcHandlerfocus = 3
		elseif(npcHandlerfocus == 3) then
			npcHandler:say("Hey! Don't touch that hat! Leave it alone!!! Don't do this!!!! ", cid)
			npcHandlerfocus = 4
		elseif(npcHandlerfocus == 4) then
			npcHandler:say("Noooooo! Argh, ok, ok, I guess I can't deny it anymore, I am David Brassacres, the magnificent, so what do you want? ", cid)
doSummonCreature("Rabbit", {x=npcPos.x-1,y=npcPos.y,z=npcPos.z})
	  doSummonCreature("Rabbit", {x=npcPos.x+1,y=npcPos.y,z=npcPos.z})
	  doSummonCreature("Rabbit", {x=npcPos.x,y=npcPos.y+1,z=npcPos.z})
	  doSummonCreature("Rabbit", {x=npcPos.x,y=npcPos.y-1,z=npcPos.z})
			npcHandlerfocus = 5
			setPlayerStorageValue(cid, 1111250, 1)
		end
	end
	return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())