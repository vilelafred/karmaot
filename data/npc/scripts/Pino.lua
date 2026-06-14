dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'transport'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'ride'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can fly you to Femor Hills or Darashia if you like. Where do you want to go?"})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's |TIME| right now."})

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
        -- aceita: bring me to darashia, bring me to femor hills, bring me to hills
		local targets = {
			{names = {"darashia"}, cfg = {cost = 40, location = CARPETPOS_DARASHIA}},
			{names = {"femor hills", "femor", "hills"}, cfg = {cost = 60, location = CARPETPOS_FEMOR}}
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

addTravelKeyword('hills', 60, CARPETPOS_FEMOR, 'Do you want to get a ride to the Femor Hills for 60 gold?')
addTravelKeyword('femor', 60, CARPETPOS_FEMOR, 'Do you want to get a ride to the Femor Hills for 60 gold?')
addTravelKeyword('darashia', 40, CARPETPOS_DARASHIA, 'Do you want to get a ride to Darashia on Darama for 40 gold?')
addTravelKeyword('darama', 40, CARPETPOS_DARASHIA, 'Do you want to get a ride to Darashia on Darama for 40 gold?')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())