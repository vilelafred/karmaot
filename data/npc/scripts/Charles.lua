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
	npcHandler:setMessage(MESSAGE_GREET, "Ahoi.")
	return true
end	

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
 
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am the captain of the Poodle, the proudest ship on all oceans."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's Charles."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "His majesty himself was present at the day the Poodle was launched."})
keywordHandler:addKeyword({'jungle'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's a fascinating forest, full of exotic life. If it weren't for my duties, I would spend some time just exploring this jungle."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "We live in a fascinating world with even more fascinating oceans. And all its major harbours are known to me."})
keywordHandler:addKeyword({'kazordoon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "An inland town of dwarves, somewhere in the middle of nowhere."})
keywordHandler:addKeyword({'dwarves'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's fun to see a seasoned dwarven fighter turnining into a shivering green something as soon as we get a mild breeze on sea."})
keywordHandler:addKeyword({'dwarfs'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It's fun to see a seasoned dwarven fighter turnining into a shivering green something as soon as we get a mild breeze on sea."})
keywordHandler:addKeyword({"ab'dendriel"}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My visits there were interesting and I learnt a lot about the elves and their city. I can only recommend a visit there and if it is only to admire the amazing architectural style in which the city was built."})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Elves are very special creatures. They keep in touch with nature almost like druids. Although I don't really understand their way of life, I think we could learn one or two things of them."})
keywordHandler:addKeyword({'elfs'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Elves are very special creatures. They keep in touch with nature almost like druids. Although I don't really understand their way of life, I think we could learn one or two things of them."})
keywordHandler:addKeyword({'darama'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I sailed around the whole continent once and I have seen many of its wonders. For sure there are more waiting to be discovered."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "He is that for the land what giant sea serpents are for the sea."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You better ask some knight about it."})
keywordHandler:addKeyword({'apes'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I would love to catch a living exemplar and bring it to Thais so the king could see it."})
keywordHandler:addKeyword({'lizard'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "They have a small settlement in the southeast of the jungle next to the coast. It looks somewhat primitive but there is evidence it was erected only recently."})
keywordHandler:addKeyword({'dworcs'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "They attacked us when we set our feet on the south shore of the continent. They are poison using savages, nothing more."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is precisely |TIME|."})

function creatureSayCallback(cid, type, msg)
	local msgLower = msg:lower()
	if(npcHandler.focus ~= cid) and not msgcontains(msgLower, 'bring me to') then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, 'major') and npcHandler.focus == cid or msgcontains(msg, 'harbour') and npcHandler.focus == cid then
		npcHandler:say("Well the harbours of thais, venore, carlin, edron, darashia and ankrahmun. Do you have any questions about one of those harbours?", 1)
		talk_state = 921
	elseif talk_state == 921 and msgcontains(msg, 'venore') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("The Venorans build fine ships. Enough said about them.", 1)
		talk_state = 0		
	elseif talk_state == 921 and msgcontains(msg, 'thais') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("Thais is the proud capital of the largest kingdom in the known world.", 1)
		talk_state = 0
	elseif talk_state == 921 and msgcontains(msg, 'carlin') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("Rebellious women might be amusing for a while, but it is time for them to stop this nonsense and return to the kingdom.", 1)
		talk_state = 0
	elseif talk_state == 921 and msgcontains(msg, 'edron') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("The coastline of Edron is treacherous and it takes some skills to sail a ship safely into the harbour.", 1)
		talk_state = 0
	elseif talk_state == 921 and msgcontains(msg, 'darashia') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("An unremarkable little town with a small harbour and quiet people.", 1)
		talk_state = 0
	elseif talk_state == 921 and msgcontains(msg, 'ankrahmun') and npcHandler.focus == cid and npcHandler.focus == cid then
		npcHandler:say("The city is surely worth a look although its inhabitants are somewhat strange and their customs oddish.", 1)
		talk_state = 0		
	end

	-- direct travel command: bring me to <city>
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
			["ankrahmun"] = {cost = 110, location = BOATPOS_ANKRAHMUN},
			["darashia"] = {cost = 180, location = BOATPOS_DARASHIA},
			["edron"] = {cost = 150, location = BOATPOS_EDRON},
			["thais"] = {cost = 160, location = BOATPOS_THAIS},
			["venore"] = {cost = 160, location = BOATPOS_VENORE}
		}

		for name, t in pairs(config) do
			if msgcontains(msgLower, name) then
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

					-- info message about payment source and remaining bank balance
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
				break
			end
		end
		return true
	end

	return true
end

	
local function addTravelKeyword(keyword, cost, destination, action)

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. titleCase(keyword) .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})

	local function travelWithBank(cid, message, keywords, parameters, node)
		local player = Player(cid)
		if not player then
			return true
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

		-- info message about payment source and remaining bank balance
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
		return true
	end

		travelKeyword:addChildKeyword({'yes'}, travelWithBank, {npcHandler = npcHandler, premium = true, level = 0, cost = cost, discount = 'postman', destination = destination })
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('ankrahmun', 110, BOATPOS_ANKRAHMUN)
addTravelKeyword('darashia', 180, BOATPOS_DARASHIA)
addTravelKeyword('edron', 150, BOATPOS_EDRON)
addTravelKeyword('thais', 160, BOATPOS_THAIS)
addTravelKeyword('venore', 160, BOATPOS_VENORE)


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
