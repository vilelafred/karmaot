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
		if (getPlayerStorageValue(cid, 1030) == 2) then
			npcHandlerfocus = 1
			npcHandler:say("My collection of recipes is almost complete. There are only but a few that are missing. ...", cid)
			addEvent(message1, 5000, pos)
        end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("Fine! Even though I know so many recipes, I'm looking for the description of some dwarven meals. ...",cid)
			npcHandlerfocus = 2
			addEvent(message2, 5000, pos)
		elseif(npcHandlerfocus == 3) then
			if (getPlayerItemCount(cid, 2347) >= 1) then
			setPlayerStorageValue(cid, 1030, 3)
			doPlayerRemoveItem(cid,2347,1)
			doPlayerAddItem(cid,2146,3)
            npcHandler:say("The book! You have it! Let me see! <browses the book> ...", cid)
			addEvent(message3, 5000, pos)
			npcHandlerfocus = 0
			else
			npcHandler:say("Too bad. I must have this book.", cid)
			npcHandlerfocus = 0
			end
		end
	elseif(msgcontains(msg, "cookbook")) then	
		if(npcHandlerfocus == 2) then
            npcHandler:say("Do you have the cookbook of the dwarven kitchen with you? Can I have it?", cid)
			npcHandlerfocus = 3
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Hmmm... now that we talk about it. There is something you could help me with. Are you interested?",cid)
end

function message2(cid, type, msg)
npcHandler:say("So, if you could bring me a cookbook of the dwarven kitchen I will reward you well.",cid)
end

function message3(cid, type, msg)
npcHandler:say("Dragon Egg Omelette, Dwarven beer sauce... it's all there. This is great! Here is your well-deserved reward. ...",cid)
addEvent(message4, 5000, pos)
end
function message4(cid, type, msg)
npcHandler:say("Incidentally, I have talked to Fa'hradin about you during dinner. I think he might have some work for you. Why don't you talk to him about it?",cid)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())