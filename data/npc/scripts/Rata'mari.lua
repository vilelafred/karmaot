dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	if(msgcontains(msg, "spy report")) then	
		if (getPlayerStorageValue(cid, 1030) == 4) then
			npcHandler:say("You have come for the report? Great! I have been working hard on it during the last months. And nobody came to pick it up. I thought everybody had forgotten about me! ...", cid)
			addEvent(message1, 5000, pos)
			setPlayerStorageValue(cid, 1030, 5)
		elseif (getPlayerStorageValue(cid, 1030) == 5) then
			npcHandler:say("Ok, have you brought me the cheese, I've asked for?", cid)
			npcHandlerfocus = 1
        end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("Meep! Meep! Great! Here is the spyreport for you!",cid)
			setPlayerStorageValue(cid, 1030, 6)
			doPlayerRemoveItem(cid,2696,1)
			doPlayerAddItem(cid,2345,1)
			addEvent(message5, 5000, pos)
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Do you have any idea how difficult it is to hold a pen when you have claws instead of hands? ...",cid)
addEvent(message2, 5000, pos)
end
function message2(cid, type, msg)
npcHandler:say("But - you know - now I have worked so hard on this report I somehow don't want to part with it. Atleast not without some decent payment. ...",cid)
addEvent(message3, 5000, pos)
end
function message3(cid, type, msg)
npcHandler:say(" All right - listen - I know Fa'hradin would not approve of this, but I can't help it. I need some cheese! I need it now! ...",cid)
addEvent(message4, 5000, pos)
end
function message4(cid, type, msg)
npcHandler:say("And I will not give the report to you until you get me some! Meep!",cid)
end

function message5(cid, type, msg)
npcHandler:say("Meep!",cid)
npcHandlerfocus = 0
npcHandler:releaseFocus()
npcHandler:resetNpc()
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())