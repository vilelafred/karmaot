dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
 
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am known as Uzon Ibn Kalith."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am a licensed Darashian carpetpilot. I can bring you to Darashia or Edron."})
keywordHandler:addKeyword({'caliph'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'kazzan'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'daraman'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Oh, there is so much to tell about Daraman. You better travel to Darama to learn about his teachings."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I would never transport this one."})
keywordHandler:addKeyword({'derfia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "So you heared about haunted Drefia? Many adventures travel there to test their skills against the undead: vampires, mummies, and ghosts."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Some people claim it is hidden somewhere under the endless sands of the devourer desert in Darama."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Thais is noisy and overcroweded. That's why I like Darashia more."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I have seen almost every place on the continent."})
keywordHandler:addKeyword({'continent'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I could retell the tales of my travels for hours. Sadly another flight is scheduled soon."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Just another Thais but with women to lead them."})
keywordHandler:addKeyword({'flying'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You can buy flying carpets only in Darashia."})
keywordHandler:addKeyword({'fly'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I transport travellers to the continent of Darama for a small fee. So many want to see the wonders of the desert and learn the secrets of Darama."})
keywordHandler:addKeyword({'new'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'rumors'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Darashia on Darama or Edron if you like. Where do you want to go?"})
keywordHandler:addKeyword({'transport'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Darashia on Darama or Edron if you like. Where do you want to go?"})
keywordHandler:addKeyword({'ride'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Darashia on Darama or Edron if you like. Where do you want to go?"})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Darashia on Darama or Edron if you like. Where do you want to go?"})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's |TIME| right now. The next flight is scheduled soon."})

local function addTravelKeyword(keyword, cost, destination, text, action)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text, cost = cost, discount = 'postman'})

	local function travelWithBank(cid, message, keywords, parameters, node)
		local player = Player(cid)
		if not player then return true end

		local parentParameters = node:getParent():getParameters()
		local finalCost = parentParameters.cost or cost
		if parentParameters.discount then
			finalCost = finalCost - StdModule.travelDiscount(player, parentParameters.discount)
			if finalCost < 0 then finalCost = 0 end
		end

		if (player:getMoney() + player:getBankBalance()) < finalCost then
			npcHandler:say("You don't have enough money.", cid)
			return true
		end

		local fromInventory = math.min(player:getMoney(), finalCost)
		local fromBank = finalCost - fromInventory
		if fromInventory > 0 then player:removeMoney(fromInventory) end
		if fromBank > 0 then player:setBankBalance(player:getBankBalance() - fromBank) end

		local usedText = "You have used"
		if fromInventory > 0 then usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack" end
		if fromBank > 0 then
			if fromInventory > 0 then usedText = usedText .. " and" end
			usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
		end
		usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
		player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

		npcHandler:releaseFocus(cid)
		npcHandler:say(parameters and parameters.text or "Set the sails!", cid)
		local dest = parentParameters.destination or destination
		if type(dest) == 'function' then dest = dest(player) end
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(dest)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

		travelKeyword:addChildKeyword({'yes'}, travelWithBank, {npcHandler = npcHandler, premium = true, level = 0, cost = cost, discount = 'postman', destination = destination })
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

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
		local targets = {
			{names = {"edron"}, cfg = {cost = 60, location = CARPETPOS_EDRON}},
			{names = {"darashia", "darama"}, cfg = {cost = 60, location = CARPETPOS_DARASHIA}}
		}
		for _, entry in ipairs(targets) do
			for _, name in ipairs(entry.names) do
				if msgcontains(msgLower, name) then
					local t = entry.cfg
					local total = player:getMoney() + player:getBankBalance()
					if total < t.cost then
						npcHandler:say('I am sorry you have ' .. total .. ' gold coins and it costs ' .. t.cost .. ' gold coins to travel.', cid)
						return true
					end
					local fromInventory = math.min(player:getMoney(), t.cost)
					local fromBank = t.cost - fromInventory
					if fromInventory > 0 then player:removeMoney(fromInventory) end
					if fromBank > 0 then player:setBankBalance(player:getBankBalance() - fromBank) end
					local usedText = 'You have used'
					if fromInventory > 0 then usedText = usedText .. ' ' .. fromInventory .. ' gold coin(s) from your backpack' end
					if fromBank > 0 then if fromInventory > 0 then usedText = usedText .. ' and' end; usedText = usedText .. ' ' .. fromBank .. ' gold coin(s) from your bank account' end
					usedText = usedText .. '. Your current bank balance is ' .. player:getBankBalance() .. ' gold coin(s).'
					player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)
					npcHandler:say('Good bye ' .. getPlayerName(cid) .. '.', cid)
					player:teleportTo(t.location)
					return true
				end
			end
		end
	end
	return true
end

addTravelKeyword('edron', 60, CARPETPOS_EDRON, 'Do you want to get a ride to Edron for 60 gold?')
addTravelKeyword('darashia', 60, CARPETPOS_DARASHIA, 'Do you want to get a ride to Darashia on Darama for 60 gold?')
addTravelKeyword('darama', 60, CARPETPOS_DARASHIA, 'Do you want to get a ride to Darashia on Darama for 60 gold?')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())