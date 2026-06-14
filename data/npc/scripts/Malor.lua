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
	
if(msgcontains(msg, "mission")) then	
		if (getPlayerStorageValue(cid, 1020) == 8) then
			npcHandlerfocus = 1
			npcHandler:say("I guess this is the first time I entrust a human with a mission. And such an important mission, too. But well, we live in hard times, and I am a bit short of adequate staff. ...", cid)
			addEvent(message1, 3000, pos)
		elseif (getPlayerStorageValue(cid, 1020) == 11) then
			npcHandlerfocus = 2
			npcHandler:say("Have you found Fa'hradin's lamp and placed it in Malor's personal chambers?", cid)
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("Well, listen. We are trying to acquire the ultimate weapon to defeat Gabel: Fa'hradin's lamp! ...",cid)
			npcHandlerfocus = 0
			setPlayerStorageValue(cid, 1020, 9)
			addEvent(message3, 5000, pos)
		elseif(npcHandlerfocus == 2) then
			npcHandler:say("Well well, human. So you really have made it - you have smuggled the modified lamp into Gabel's bedroom! ...",cid)
			npcHandlerfocus = 0
			setPlayerStorageValue(cid, 1020, 12)
			setPlayerStorageValue(cid, 25905, 1)
			addEvent(message7, 5000, pos)
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Besides, Baa'leal told me you have distinguished yourself well in previous missions, so I think you might be the right person for the job. ...",cid)
addEvent(message2, 5000, pos)
end
function message2(cid, type, msg)
npcHandler:say("But think carefully, human, for this mission will bring you close to certain death. Are you prepared to embark on this mission?", cid)
end

function message3(cid, type, msg)
npcHandler:say("At the moment it is still in the possession of that good old friend of mine, the Orc King, who kindly released me from it. ...", cid)
addEvent(message4, 5000, pos)
end
function message4(cid, type, msg)
npcHandler:say("However, for some reason he is not as friendly as he used to be. You better watch out, human, because I don't think you will get the lamp without a fight. ...", cid)
addEvent(message5, 5000, pos)
end
function message5(cid, type, msg)
npcHandler:say("Once you have found the lamp you must enter Ashta'daramai again. Sneak into Gabel's personal chambers and exchange his sleeping lamp with Fa'hradin's lamp! ...", cid)
addEvent(message6, 5000, pos)
end
function message6(cid, type, msg)
npcHandler:say("If you succeed, the war could be over one night later!", cid)
end

function message7(cid, type, msg)
npcHandler:say("I never thought I would say this to a human, but I must confess I am impressed. ...", cid)
addEvent(message8, 5000, pos)
end
function message8(cid, type, msg)
npcHandler:say("Perhaps I have underestimated you and your kind after all. ...", cid)
addEvent(message9, 5000, pos)
end
function message9(cid, type, msg)
npcHandler:say("I guess I will take this as a lesson to keep in mind when I meet you on the battlefield. ...", cid)
addEvent(message10, 5000, pos)
end
function message10(cid, type, msg)
npcHandler:say("But that's in the future. For now, I will confine myself to give you the permission to trade with my people whenever you want to. ...", cid)
addEvent(message11, 5000, pos)
end
function message11(cid, type, msg)
npcHandler:say("Farewell, human!", cid)
npcHandler:releaseFocus()
npcHandler:resetNpc()
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())