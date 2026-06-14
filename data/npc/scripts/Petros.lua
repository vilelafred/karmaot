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
 
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Petros"})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I take along people to Venore, Port Hope and Ankrahmun."})
keywordHandler:addKeyword({'ghost'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Oh, I don't believe in ghosts."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My boat is ready to bring you to Venore, Port Hope or Ankrahmun."})
keywordHandler:addKeyword({'boat'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My boat is ready to bring you to Venore, Port Hope or Ankrahmun."})

function creatureSayCallback(cid, type, msg)
	local msgLower = msg:lower()
	if npcHandler.focus ~= cid and not msgcontains(msgLower, 'bring me to') then
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
			["ankrahmun"] = {cost = 100, location = BOATPOS_ANKRAHMUN},
			["port hope"] = {cost = 170, location = BOATPOS_PORT},
			["venore"] = {cost = 60, location = BOATPOS_VENORE}
		}

		for name, t in pairs(config) do
			if msgcontains(msgLower, name) then
				if player then
					local totalMoney = player:getMoney() + player:getBankBalance()
					if totalMoney < t.cost then
						npcHandler:say("I am sorry you have " .. totalMoney .. " gold coins and it costs " .. t.cost .. " gold coins to travel.", cid)
					else
						local fromInventory = math.min(player:getMoney(), t.cost)
						local fromBank = t.cost - fromInventory
						if fromInventory > 0 then
							player:removeMoney(fromInventory)
						end
						if fromBank > 0 then
							player:setBankBalance(player:getBankBalance() - fromBank)
						end

						local usedText = "You have used"
						if fromInventory > 0 then
							usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
						end
						if fromBank > 0 then
							if fromInventory > 0 then
								usedText = usedText .. " and"
							end
							usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
						end
						usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
						player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                        npcHandler:releaseFocus(cid)
                        npcHandler:say("Good bye " .. getPlayerName(cid) .. ".", cid)
                        player:teleportTo(t.location)
                        npcHandler:resetNpc()
					end
				end
				break
			end
		end
		return true
	end

	return true
end

local function addTravelKeyword(keyword, cost, destination, action)
    local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. titleCase(keyword) .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman', onlyFocus = true})

    local function travelWithBank(cid, message, keywords, parameters, node)
        local player = Player(cid)
        if not player then
            return false
        end
        if npcHandler.focus ~= cid then
            return false
        end

		local parentParameters = node:getParent():getParameters()
		local finalCost = parentParameters.cost or cost
		if parentParameters.discount then
			finalCost = finalCost - StdModule.travelDiscount(player, parentParameters.discount)
			if finalCost < 0 then
				finalCost = 0
			end
		end

		if (player:getMoney() + player:getBankBalance()) < finalCost then
			npcHandler:say("You don't have enough money.", cid)
			return true
		end

		local fromInventory = math.min(player:getMoney(), finalCost)
		local fromBank = finalCost - fromInventory
		if fromInventory > 0 then
			player:removeMoney(fromInventory)
		end
		if fromBank > 0 then
			player:setBankBalance(player:getBankBalance() - fromBank)
		end

		local usedText = "You have used"
		if fromInventory > 0 then
			usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
		end
		if fromBank > 0 then
			if fromInventory > 0 then
				usedText = usedText .. " and"
			end
			usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
		end
		usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
		player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

        npcHandler:releaseFocus(cid)
        npcHandler:say(parameters and parameters.text or "Set the sails!", cid)

		local dest = parentParameters.destination or destination
		if type(dest) == 'function' then
			dest = dest(player)
		end
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(dest)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        npcHandler:resetNpc()
        return true
	end

		travelKeyword:addChildKeyword({'yes'}, travelWithBank, {npcHandler = npcHandler, premium = true, level = 0, cost = cost, discount = 'postman', destination = destination })
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('ankrahmun', 100, BOATPOS_ANKRAHMUN)
addTravelKeyword('port hope', 170, BOATPOS_PORT)
addTravelKeyword('venore', 60, BOATPOS_VENORE)


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())