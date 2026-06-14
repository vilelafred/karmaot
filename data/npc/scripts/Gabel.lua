local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)	npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)	npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

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
	
	if(msgcontains(msg, "mission")) then	
		if (getPlayerStorageValue(cid, 1030) == 7) then
			npcHandler:say("Sooo. Fa'hradin has told me about your extraordinary exploit, and I must say I am impressed. ...", cid)
			npcHandlerfocus = 1
			addEvent(message1, 5000, pos)
		elseif (getPlayerStorageValue(cid, 1030) == 10) then
			npcHandler:say("Have you found Fa'hradin's lamp and placed it in Malor's personal chambers?", cid)
			npcHandlerfocus = 2
        end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			setPlayerStorageValue(cid, 1030, 8)
			npcHandler:say("All right. Listen! Thanks to Rata'mari's report we now know what Malor is up to: he wants to do to me what I have done to him - he wants to imprison me in Fa'hradin's lamp! ...", cid)
			addEvent(message5, 5000, pos)
		elseif(npcHandlerfocus == 2) then
			setPlayerStorageValue(cid, 1030, 11)
			setPlayerStorageValue(cid, 25904, 1)
			npcHandler:say("Daraman shall bless you and all humans! You have done us all a huge service! Soon, this awful war will be over! ...", cid)
			addEvent(message9, 5000, pos)
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Your fragile human form belies your courage and your fighting spirit. ...",cid)
addEvent(message2, 5000, pos)
end
function message2(cid, type, msg)
npcHandler:say("I hardly dare to ask you because you have already done so much for us, but there is a task to be done, and I cannot think of anybody else who would be better suited to fulfill it than you. ...",cid)
addEvent(message3, 5000, pos)
end
function message3(cid, type, msg)
npcHandler:say("Think carefully, human, for this mission will bring you into real danger. Are you prepared to do us that final favour?",cid)
addEvent(message4, 5000, pos)
end
function message4(cid, type, msg)
npcHandler:say("But unfortunately, I have lost contact with him months ago. ...",cid)
end

function message5(cid, type, msg)
npcHandler:say("Of course, that won't happen. Now, we know his plans. ...",cid)
addEvent(message6, 5000, pos)
end
function message6(cid, type, msg)
npcHandler:say("But I am aiming at something different. We have learnt one important thing: At this point of time, Malor does not have the lamp yet, which means it is still where he left it. We need that lamp! If we get it back we can imprison him again! ...",cid)
addEvent(message7, 5000, pos)
end
function message7(cid, type, msg)
npcHandler:say("From all we know the lamp is still in the Orc King's possession! Therefore I want to ask you to enter thewell guarded halls over at Ulderek's Rock and find the lamp. ...",cid)
addEvent(message8, 5000, pos)
end
function message8(cid, type, msg)
npcHandler:say("Once you have acquired the lamp you must enter Mal'ouquah again. Sneak into Malor's personal chambersand exchange his sleeping lamp with Fa'hradin's lamp! ...",cid)
addEvent(message9, 5000, pos)
end
function message9(cid, type, msg)
npcHandler:say("If you succeed, the war could be over one night later! I and all djinn will be in your debt forever! May Daraman watch over you!",cid)
npcHandler:releaseFocus()
npcHandler:resetNpc()
end

function message9(cid, type, msg)
npcHandler:say("Know, that from now on you are considered one of us and are welcome to trade with Haroun and Nah'bob whenever you want to!",cid)
addEvent(message10, 5000, pos)
end
function message10(cid, type, msg)
npcHandler:say("Farewell, stranger. May Uman open your minds and your hearts to Daraman's wisdom!",cid)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())