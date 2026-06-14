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
		npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Sir ".. getPlayerName(cid) ..".")
		return true
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Madam ".. getPlayerName(cid) ..".")
		return true
	end	
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Captain Fearless from the Royal Tibia Line."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "We can transport everything you want."})
keywordHandler:addKeyword({'passanger'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "We would like to welcome you on board."})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Where do you want to go? To Thais, Carlin, Ab'Dendriel, Port Hope, Edron, Darashia or Ankrahmun?"})
keywordHandler:addKeyword({'ice'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'senja'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'folda'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'vega'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'ghost'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "There's a legend of a ghostship cruising between Venore and Darashia. Many captains are afraid to sail this route. Hah, but not me!"})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "This is Venore. Where do you want to go?"})

local function addTravelKeyword(keyword, cost, destination, action)
    local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. titleCase(keyword) .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman', onlyFocus = true})

    local function travelWithBank(cid, message, keywords, parameters, node)
        local player = Player(cid)
        if not player then return false end
        if npcHandler.focus ~= cid then return false end

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
		if fromBank > 0 then if fromInventory > 0 then usedText = usedText .. " and" end; usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account" end
		usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
		player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

        npcHandler:releaseFocus(cid)
        npcHandler:say(parameters and parameters.text or "Set the sails!", cid)
		local dest = parentParameters.destination or destination
		if type(dest) == 'function' then dest = dest(player) end
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(dest)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        npcHandler:resetNpc()
        return true
	end

		travelKeyword:addChildKeyword({'yes'}, travelWithBank, {npcHandler = npcHandler, premium = true, level = 0, cost = cost, discount = 'postman', destination = destination })
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('ab\'dendriel', 90, BOATPOS_AB)
addTravelKeyword('ankrahmun', 150, BOATPOS_ANKRAHMUN)
addTravelKeyword('carlin', 130, BOATPOS_CARLIN)
addTravelKeyword('edron', 40, BOATPOS_EDRON)
addTravelKeyword('port hope', 160, BOATPOS_PORT)
addTravelKeyword('thais', 170, BOATPOS_THAIS)
addTravelKeyword('darashia', 60, BOATPOS_DARASHIA)

function creatureSayCallback(cid, type, msg)
    local lower = msg:lower()
    if (npcHandler.focus ~= cid) and not msgcontains(lower, 'bring me to') then
        return false
    end
	local config = {
   ["ankrahmun"] = {cost = 150, location = BOATPOS_ANKRAHMUN},
   ["ab'dendriel"] = {cost = 90, location = BOATPOS_AB},
   ["thais"] = {cost = 170, location = BOATPOS_THAIS},
   ["carlin"] = {cost = 130, location = BOATPOS_CARLIN},
   ["port hope"] = {cost = 160, location = BOATPOS_PORT},
   ["darashia"] = {cost = 60, location = BOATPOS_DARASHIA},
   ["edron"] = {cost = 40, location = BOATPOS_EDRON}
   }

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local player = Player(cid)
	    local tm = config[msg:lower()]
    if msgcontains(msg, "bring me to") then
        local bringExhaust = 159322
        local now = os.time()
        if getPlayerStorageValue(cid, bringExhaust) > now then
            local remaining = getPlayerStorageValue(cid, bringExhaust) - now
            npcHandler:say("You must wait " .. remaining .. " second(s) before using the 'bring me to' shortcut again.", cid)
            return true
        end
        setPlayerStorageValue(cid, bringExhaust, now + 20)
         for mes, t in pairs(config) do
            if msgcontains(msg, mes) then
               if player then
                   local totalMoney = player:getMoney() + player:getBankBalance()
                   if totalMoney < t.cost then
                       npcHandler:say("I am sorry you have ".. totalMoney .." gold coins and it costs ".. t.cost .." gold coins to travel.", cid)
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

                       npcHandler:say("Good bye ".. getPlayerName(cid) ..".", cid)
                       player:teleportTo(t.location)
                   end
               end
             end
         end
	end 
	return true	
end
	
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())