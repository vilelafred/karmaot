dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)



-- OTServ event handling functions
function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()							npcHandler:onThink()					end

function greetCallback(cid)
	if getPlayerLevel(cid) < 15 then
		--npcHandler:setMessage(MESSAGE_GREET, "I don't talk to little children!!")
		npcHandler:say("I don't talk to little children!!", 1)
		npcHandler:releaseFocus()
		npcHandler:resetNpc()
		return false		
	else
		if getPlayerVocation(cid) == 1 or getPlayerVocation(cid) == 5 then
			npcHandler:setMessage(MESSAGE_GREET, "It's good to see somebody who has chosen the path of wisdom. What do you want?")
		elseif getPlayerVocation(cid) == 2 or getPlayerVocation(cid) == 6 then
			npcHandler:setMessage(MESSAGE_GREET, "Hail, friend of nature! How may I help you?")
		elseif getPlayerVocation(cid) == 3 or getPlayerVocation(cid) == 7 then
			npcHandler:setMessage(MESSAGE_GREET, "Neither strong enough to be a knight nor wise enough to be a real mage. You like it easy, don't you? Why are you disturbing me?")
		elseif getPlayerVocation(cid) == 4 or getPlayerVocation(cid) == 8 then
			npcHandler:setMessage(MESSAGE_GREET, "Another creature who believes thinks physical strength is more important than wisdom! Why are you disturbing me?")
		end
		return true
	end	
end	

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Once I was the master of all mages, but now I only protect this crypt."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Skjaar the Mage, master of all spells."})
keywordHandler:addKeyword({'door'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "This door seals a crypt."})
keywordHandler:addKeyword({'crypt'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Here lies my master. Only his closest followers may enter."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm not here to help anybody. I only protect my master's crypt."})
keywordHandler:addKeyword({'mountain'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Hundreds of years my master's castle stood on the top of this mountain. Now there is a volcano."})
keywordHandler:addKeyword({'volcano'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can still feel the magical energy in the volcano."})
keywordHandler:addKeyword({'castle'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The castle was destroyed when my master tried to summon a nameless creature. All that is left is this volcano."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "To those who have lived for a thousand years time holds no more terror."})
keywordHandler:addKeyword({'master'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "If you are one of his followers, you need not ask about him, for you will know. And if you aren't, you are not worthy anyway!"})


function creatureSayCallback(cid, type, msg) msg = string.lower(msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	if getPlayerLevel(cid) <= 14 and msgcontains(msg, '') then
	npcHandler:say("Get lost you little freak!", 1)
	npcHandler:releaseFocus()
	npcHandler:resetNpc()	
	end
	
if msgcontains(msg, 'reward') or msgcontains(msg, 'quest') then
	npcHandler:say("hello adventurer! you are an unexpected visitor but i am very happy to know that there are people like you who care about the fate of rookgaard.", 1)
	npcHandler:say("I believe that to have arrived here, you must have found the solutions you were looking for for many years, right?..", 1)
	npcHandler:say("Is what you hold a minotaur contract?..", 1)
	talk_state = 1

elseif talk_state == 1 and msgcontains(msg, 'yes') or talk_state == 1 and msgcontains(msg, 'Yes') then
	npcHandler:say("Okay, but first I want to make sure you're bringing a temporary Minotaur peace deal to this island, okay?", 1)
	talk_state = 2
elseif talk_state == 1 and msgcontains(msg, 'no') then
	npcHandler:say("Then leave, unworthy worm!", 1)
	talk_state = 0	
elseif talk_state == 1 and msgcontains(msg, '') then
	npcHandler:say("You're not worthy if you cannot make up your mind. Leave!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()	
	
elseif talk_state == 2 and msgcontains(msg, 'yes') or talk_state == 2 and msgcontains(msg, 'Yes') then
	if doPlayerItem(cid,5853,1) == true then
	npcHandler:say("All right then. Here comes the first question. What was the name of Dago's favourite pet?", 1)
	talk_state = 3		
	else
	npcHandler:say("You don't even have the money to make a donation? Then go!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()		
	end
elseif talk_state == 2 and msgcontains(msg, 'no') then
	npcHandler:say("Then leave, unworthy worm!", 1)
	talk_state = 0	
elseif talk_state == 2 and msgcontains(msg, '') then
	npcHandler:say("You're not worthy if you cannot make up your mind. Leave!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()	
	
elseif talk_state == 3 and msgcontains(msg, 'redips') or talk_state == 2 and msgcontains(msg, 'Redips') then
	npcHandler:say("Perhaps you knew him after all. Tell me - how many fingers did he have when he died?", 1)
	talk_state = 4
elseif talk_state == 3 and msgcontains(msg, '') then
	npcHandler:say("You are wrong. Get lost!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()
	
elseif talk_state == 4 and msgcontains(msg, '7') or talk_state == 4 and msgcontains(msg, 'seven') or talk_state == 4 and msgcontains(msg, 'Seven') then
	npcHandler:say("Also true. But can you also tell me the colour of the deamons in which master specialized?", 1)
	talk_state = 5
elseif talk_state == 4 and msgcontains(msg, '') then
	npcHandler:say("You are wrong. Get lost!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()	
	
elseif talk_state == 5 and msgcontains(msg, 'black') or talk_state == 5 and msgcontains(msg, 'Black') then
	npcHandler:say("It seems you are worthy after all. Do you want the key to the crypt?", 1)
	talk_state = 6
elseif talk_state == 5 and msgcontains(msg, '') then
	npcHandler:say("You are wrong. Get lost!", 1)
	talk_state = 0
	npcHandler:releaseFocus()
	npcHandler:resetNpc()	
	
elseif talk_state == 6 and msgcontains(msg, 'yes') or talk_state == 6 and msgcontains(msg, 'Yes') then
	doPlayerAddItem(cid, 2089, 1)
	npcHandler:say("Here you are.", 1)
	talk_state = 0
	
elseif talk_state == 6 and msgcontains(msg, '') then
	npcHandler:say("It is always a wise decision to leave the dead alone.", 1)
	talk_state = 0	
	
elseif msgcontains(msg, "idiot") then
	doSendMagicEffect(getCreaturePosition(getNpcCid(  )), 13)
	doSendMagicEffect(getPlayerPosition(cid), 15)
	doCreatureAddHealth(cid, -getCreatureHealth(cid) +1)
	npcHandler:say("Take this for your words!", 1)
	npcHandler:releaseFocus()
	npcHandler:resetNpc()
	talk_state = 0
	
elseif msgcontains(msg, "asshole") then
	doSendMagicEffect(getCreaturePosition(getNpcCid(  )), 13)
	doSendMagicEffect(getPlayerPosition(cid), 15)
	doCreatureAddHealth(cid, -getCreatureHealth(cid) +1)
	npcHandler:say("Take this for your words!", 1)
	npcHandler:releaseFocus()
	npcHandler:resetNpc()
	talk_state = 0
	
elseif msgcontains(msg, "fuck") then
	doSendMagicEffect(getCreaturePosition(getNpcCid(  )), 13)
	doSendMagicEffect(getPlayerPosition(cid), 15)
	doCreatureAddHealth(cid, -getCreatureHealth(cid) +1)
	npcHandler:say("Take this for your words!", 1)
	npcHandler:releaseFocus()
	npcHandler:resetNpc()
	talk_state = 0
	
end		
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())