local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)        npcHandler:onCreatureDisappear(cid)            end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                        npcHandler:onThink()                        end


function greetCallback(cid)
	if getPlayerStorageValue(cid,3058) == -1 then
		selfSay('Arrrrgh! A dirty paleskin! Kill them my guards!')
		pos = getCreaturePosition(getNpcCid())

		local northEast = {x=pos.x+1,y=pos.y-1,z=pos.z}
		local northWest = {x=pos.x-1,y=pos.y-1,z=pos.z}
		local southEast = {x=pos.x+1,y=pos.y+1,z=pos.z}
		local southWest = {x=pos.x-1,y=pos.y+1,z=pos.z}
		local East = {x=pos.x+1,y=pos.y,z=pos.z}
		local West = {x=pos.x-1,y=pos.y,z=pos.z}
		local South = {x=pos.x,y=pos.y+1,z=pos.z}
		local North = {x=pos.x,y=pos.y-1,z=pos.z}

		doSummonCreature('Orc Warlord', northWest)
		doSummonCreature('Orc Warlord', West)
		doSummonCreature('Orc Leader', southWest)
		doSummonCreature('Orc Leader', South)
		doSummonCreature('Orc Leader', southEast)
		doSummonCreature('Slime', East)
		doSummonCreature('Slime', northEast)
		doSummonCreature('Slime', North)
		setPlayerStorageValue(cid,3058,1)
	else
		return true
	end
end
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	if(msgcontains(msg, "lamp")) then	
		if (getPlayerStorageValue(cid, 1020) == 9) then
			npcHandler:say("I can sense your evil intentions to imprison a djinn! You are longing for the lamp, which I still possess. ...",cid)
			npcHandlerfocus = 1
			addEvent(message1, 5000, pos)
		elseif (getPlayerStorageValue(cid, 1030) == 8) then -- outra quest
			npcHandler:say("I can sense your evil intentions to imprison a djinn! You are longing for the lamp, which I still possess. ...",cid)
			npcHandlerfocus = 2
			addEvent(message2, 5000, pos)
		end
	elseif(msgcontains(msg, "malor")) then
		if(npcHandlerfocus == 1) then
			npcHandler:say("I was waiting for this day! Take the lamp and let Malor feel my wrath!",cid)
			npcHandlerfocus = 0
			doPlayerAddItem(cid,2344,1)
			setPlayerStorageValue(cid, 1020, 10)
		elseif(npcHandlerfocus == 2) then -- outra quest
			npcHandler:say("I was waiting for this day! Take the lamp and let Malor feel my wrath!",cid)
			npcHandlerfocus = 0
			doPlayerAddItem(cid,2344,1)
			setPlayerStorageValue(cid, 1030, 9)
			addEvent(message11, 5000, pos)
		end
	end

	return true
end	

function message1(cid, type, msg)
npcHandler:say("Who do you want to trap in this cursed lamp?",cid)
end
function message2(cid, type, msg)
npcHandler:say("Who do you want to trap in this cursed lamp?", cid)
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())