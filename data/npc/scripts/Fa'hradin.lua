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
		if (getPlayerStorageValue(cid, 1030) == 3) then
			npcHandler:say("I have heard some good things about you from Bo'ques. But I don't know. ...", cid)
			addEvent(message1, 5000, pos)
			setPlayerStorageValue(cid, 1030, 4)
		elseif (getPlayerStorageValue(cid, 1030) == 6) then
			npcHandler:say("Did you already retrieve the spyreport?", cid)
			npcHandlerfocus = 1
        end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			if (getPlayerItemCount(cid, 2345) >= 1) then
			setPlayerStorageValue(cid, 1030, 7)
			doPlayerRemoveItem(cid,2345,1)
            npcHandler:say("You really have made it? You have the report? How come you did not get slaughtered? I must say I'm impressed. Your race will never cease to surprise me. ...",cid)
			addEvent(message9, 5000, pos)
			else
			npcHandler:say("Too bad. I must have this book.", cid)
			npcHandlerfocus = 0
			end
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Well, all right. I do have a job for you. ...",cid)
addEvent(message2, 5000, pos)
end
function message2(cid, type, msg)
npcHandler:say("In order to stay informed about our enemy's doings, we have managed to plant a spy in Mal'ouquah. ...",cid)
addEvent(message3, 5000, pos)
end
function message3(cid, type, msg)
npcHandler:say("He has kept the Efreet and Malor under surveillance for quite some time. ...",cid)
addEvent(message4, 5000, pos)
end
function message4(cid, type, msg)
npcHandler:say("But unfortunately, I have lost contact with him months ago. ...",cid)
addEvent(message5, 5000, pos)
end
function message5(cid, type, msg)
npcHandler:say("I do not fear for his safety because his cover is foolproof, but I cannot contact him either. This is where you come in. ...",cid)
addEvent(message6, 5000, pos)
end
function message6(cid, type, msg)
npcHandler:say(" I need you to infiltrate Mal'ouqhah, contact our man there and get his latest spyreport. The password is PIEDPIPER. Remember it well! ...",cid)
addEvent(message7, 5000, pos)
end
function message7(cid, type, msg)
npcHandler:say("I do not have to add that this is a dangerous mission, do I? If you are discovered expect to be attacked! So goodluck, human!",cid)
addEvent(message8, 5000, pos)
end
function message8(cid, type, msg)
npcHandler:say("Farewell, human. I will always remember you. Unless I forget you, of course.",cid)
npcHandler:releaseFocus()
npcHandler:resetNpc()
end

function message9(cid, type, msg)
npcHandler:say("Well, let's see. ...",cid)
addEvent(message10, 5000, pos)
end
function message10(cid, type, msg)
npcHandler:say("I think I need to talk to Gabel about this. I am sure he will know what to do. Perhaps you should have aword with him, too.",cid)
addEvent(message11, 5000, pos)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())