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
	
	if(msgcontains(msg, "mission")) then	
		if (getPlayerStorageValue(cid, 1020) == 2) then
			npcHandlerfocus = 1
			npcHandler:say("Each mission and operation is a crucial step towards our victory! ...")
			addEvent(message1, 3000, pos)
		elseif (getPlayerStorageValue(cid, 1020) == 4) then
			npcHandlerfocus = 2
			npcHandler:say("Did you find the thief of our supplies?")	
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("Well ... All right. You may only be a human, but you do seem to have the right spirit. ...",cid)
			addEvent(message3, 3000, pos)
			setPlayerStorageValue(cid, 1020, 3)
			npcHandlerfocus = 0
		elseif(npcHandlerfocus == 2) then
			npcHandlerfocus = 3
			npcHandler:say("Finally! What is his name then?")	
		end
	elseif(msgcontains(msg, "partos")) then
		if(npcHandlerfocus == 3) then
			npcHandlerfocus = 4
			npcHandler:say("You found the thief! Excellent work, soldier! You are doing well - for a human, that is. Here - take this as a reward. ...")
			npcHandler:say("Since you have proven to be a capable soldier, we have another mission for you. ... Baa'leal: If you are interested go to Alesar and ask him about it.")
		end
	elseif(msgcontains(msg, "hail malor")) then
		if(npcHandlerfocus == 4) then
			npcHandlerfocus = 0
			setPlayerStorageValue(cid, 1020, 5)
			npcHandler:say("Hail to our great leader!")
		end
	end
	return true
end

function message1(cid, type, msg)
npcHandler:say("Now that we speak of it ...")
addEvent(message2, 3000, pos)
end
function message2(cid, type, msg)
npcHandler:say("Since you are no djinn, there is something you could help us with. Are you interested, human?")
end

function message3(cid, type, msg)
npcHandler:say("Listen! Since our base of operations is set in this isolated spot we depend on supplies from outside. These supplies are crucial for us to win the war. ...")
addEvent(message4, 3000, pos)
end
function message4(cid, type, msg)
npcHandler:say("Unfortunately, it has happened that some of our supplies have disappeared on their way to this fortress. At first we thought it was the Marid, but intelligence reports suggest a different explanation. ...",cid)
addEvent(message5, 3000, pos)
end
function message5(cid, type, msg)
npcHandler:say("We now believe that a human was behind the theft! ...",cid)
addEvent(message6, 3000, pos)
end
function message6(cid, type, msg)
npcHandler:say("His identity is still unknown but we have been told that the thief fled to the human settlement called Carlin. I want you to find him and report back to me. Nobody messes with the Efreet and lives to tell the tale! ...",cid)
addEvent(message7, 3000, pos)
end
function message7(cid, type, msg)
npcHandler:say("Now go! Travel to the northern city Carlin! Keep your eyes open and look around for something that might give you a clue!",cid)
end

function message8(cid, type, msg)
npcHandler:say("Listen! Since our base of operations is set in this isolated spot we depend on supplies from outside. These supplies are crucial for us to win the war. ...")
addEvent(message9, 5000, pos)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())