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
 
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "As should be quite obvious, I am operating a steamship."})
keywordHandler:addKeyword({'work'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "As should be quite obvious, I am operating a steamship."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Gurbasch Firejuggler, son of the machine, of the Molten Rock."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Tibia? Just don't ask."})
keywordHandler:addKeyword({'steamship'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is indeed something we dwarfs may be proud of: a ship operating by steam power."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "It is indeed something we dwarfs may be proud of: a ship operating by steam power."})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Captain"})
keywordHandler:addKeyword({'technomancer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "A technomancer wields power over incredible machines, as his knowledge is his magic."})
keywordHandler:addKeyword({'inventors'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You know, elves may be intelligent, but they are too lazy to invent. Really."})
keywordHandler:addKeyword({'inventions'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "You know, elves may be intelligent, but they are too lazy to invent. Really."})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am not a vendor."})
keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am not a vendor."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = ""})
keywordHandler:addKeyword({"ab'dendriel"}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'senja'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'folda'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'vega'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'ice'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'darama'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "How do you expect me to go there? Fly? Hm, wait... no, sorry."})
keywordHandler:addKeyword({'cormaya'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Hey, we ARE at Cormaya! Must be the cavemadness..."})
keywordHandler:addKeyword({'beer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ah, you got some? Nah, beer only tastes fine in Kazordoon. If you have brought it from there, it tastes foul now, I guess."})
keywordHandler:addKeyword({'beer'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "We are an old and proud race, although we posess the best inventions."})
keywordHandler:addKeyword({'brodrosch'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "He is my brother working the Kazordoon steamship."})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Have one elf onboard a ship, and you are doomed."})
keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Have one elf onboard a ship, and you are doomed."})

local function addTravelKeyword(keyword, cost, destination, action)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to go to Kazordoon? And try the beer there? |TRAVELCOST|?', cost = cost, discount = 'postman'})

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

addTravelKeyword('passage', 160, STEAMPOS_KAZORDOON)
addTravelKeyword('kazordoon', 160, STEAMPOS_KAZORDOON)


function creatureSayCallback(cid, type, msg)
	local lower = msg:lower()
	if (npcHandler.focus ~= cid) and not msgcontains(lower, 'bring me to') then
		return false
	end
	local player = Player(cid)
    if msgcontains(lower, 'bring me to') then
        local bringExhaust = 159322
        local now = os.time()
        if getPlayerStorageValue(cid, bringExhaust) > now then
            local remaining = getPlayerStorageValue(cid, bringExhaust) - now
            npcHandler:say("You must wait " .. remaining .. " second(s) before using the 'bring me to' shortcut again.", cid)
            return true
        end
        setPlayerStorageValue(cid, bringExhaust, now + 20)
		local t = {cost = 160, location = STEAMPOS_KAZORDOON}
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
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())