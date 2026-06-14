dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

function greetCallback(cid)
	if getPlayerSex(cid) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, young man. Looking for a passage or some fish, ".. getPlayerName(cid) .."?")
		return true
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, young lady. Looking for a passage or some fish, ".. getPlayerName(cid) .."?")
		return true
	end	
end	

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
shopModule:addBuyableItem({'fish'}, 2667, 5)

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Pemaret, the fisherman."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm a fisherman and I take along people to Edron. You can also buy some fresh fish."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I love to sail on the seas of Tibia."})
keywordHandler:addKeyword({'sea'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I love to sail on the seas of Tibia."})
keywordHandler:addKeyword({'cormaya'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's a lovely and peaceful isle. Did you already visit the nice sandy beach?"})
keywordHandler:addKeyword({'isle'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's a lovely and peaceful isle. Did you already visit the nice sandy beach?"})
keywordHandler:addKeyword({'beach'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "There is a nice sandy beach in the west of Cormaya."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My boat is ready to bring you to Edron."})
keywordHandler:addKeyword({'boat'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My boat is ready to bring you to Edron."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My boat is ready to bring you to Edron."})

local travelNode = keywordHandler:addKeyword({'eremo'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Oh, you know the good old sage Eremo. I can bring you to his little island. Do you want me to do that?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 0, destination = BOATPOS_EREMO })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here.'})
	
local travelNode = keywordHandler:addKeyword({'edron'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to get to Edron for 20 gold?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 20, destination = BOATPOS_EDRON })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here.'})


function creatureSayCallback(cid, type, msg)
	local msgLower = msg:lower()
	if (npcHandler.focus ~= cid) and not msgcontains(msgLower, 'bring me to') then
		return false
	end

	local player = Player(cid)
    if msgcontains(msgLower, 'bring me to') then
        local bringExhaust = 159322
        local now = os.time()
        if getPlayerStorageValue(cid, bringExhaust) > now then
            local remaining = getPlayerStorageValue(cid, bringExhaust) - now
            npcHandler:say("You must wait " .. remaining .. " second(s) before using the 'bring me to' shortcut again.", cid)
            return true
        end
        setPlayerStorageValue(cid, bringExhaust, now + 20)
		local config = {
			["edron"] = {cost = 20, location = BOATPOS_EDRON},
			["eremo"] = {cost = 0, location = BOATPOS_EREMO}
		}
		for name, t in pairs(config) do
			if msgcontains(msgLower, name) then
				if player then
					local total = player:getMoney() + player:getBankBalance()
					if total < t.cost then
						npcHandler:say('I am sorry you have '.. total ..' gold coins and it costs '.. t.cost ..' gold coins to travel.', cid)
					else
						local fromInventory = math.min(player:getMoney(), t.cost)
						local fromBank = t.cost - fromInventory
						if fromInventory > 0 then player:removeMoney(fromInventory) end
						if fromBank > 0 then player:setBankBalance(player:getBankBalance() - fromBank) end

						local usedText = 'You have used'
						if fromInventory > 0 then usedText = usedText .. ' ' .. fromInventory .. ' gold coin(s) from your backpack' end
						if fromBank > 0 then
							if fromInventory > 0 then usedText = usedText .. ' and' end
							usedText = usedText .. ' ' .. fromBank .. ' gold coin(s) from your bank account'
						end
						usedText = usedText .. '. Your current bank balance is ' .. player:getBankBalance() .. ' gold coin(s).'
						player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

						npcHandler:say('Good bye ' .. getPlayerName(cid) .. '.', cid)
						player:teleportTo(t.location)
					end
				end
				break
			end
		end
		return true
	end

	return true
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())