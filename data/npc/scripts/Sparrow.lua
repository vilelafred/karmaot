local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Storage para o Weekly Pass
local STORAGE_KARMA_BOAT_PASS = 45678
-- Preços
local SINGLE_TRIP_COST = 2000000  -- 2kk
local WEEKLY_PASS_COST = 14000000 -- 14kk
local WEEKLY_PASS_DURATION = 7 * 24 * 60 * 60 -- 7 dias em segundos

function onCreatureAppear(cid)	npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)	npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg) end
function onThink()	npcHandler:onThink() end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'My name is not of your concern.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'That\'s only my business, not yours.'})

-- Função auxiliar para verificar se o player tem passe ativo
local function hasActivePass(player)
	local passExpiry = player:getStorageValue(STORAGE_KARMA_BOAT_PASS)
	if passExpiry > 0 and passExpiry > os.time() then
		return true, passExpiry
	end
	return false, 0
end

-- Função auxiliar para formatar tempo restante
local function formatTimeRemaining(seconds)
	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	
	if days > 0 then
		return string.format("%d day%s, %d hour%s", days, days > 1 and "s" or "", hours, hours > 1 and "s" or "")
	elseif hours > 0 then
		return string.format("%d hour%s, %d minute%s", hours, hours > 1 and "s" or "", minutes, minutes > 1 and "s" or "")
	else
		return string.format("%d minute%s", minutes, minutes > 1 and "s" or "")
	end
end

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end
	
	local player = Player(cid)
	if not player then
		return false
	end
	
	if msgcontains(msg, 'brooch') then
		npcHandler:say('What? You want me to examine a brooch?')
		topic = 1	
	elseif msgcontains(msg, 'yes') and topic == 1 then
		if getPlayerItemCount(cid, 2318) >= 1 then
			npcHandler:say('You have recovered my brooch! I shall forever be in your debt, my friend!')
			doPlayerTakeItem(cid,2318,10)
			setPlayerStorageValue(cid,99999,1)
			topic = 2
		else
			topic = 0
			npcHandler:say('You no have broonch')
		end
		
	-- WEEKLY PASS - Verificar status do passe
	elseif msgcontains(msg, 'pass') or msgcontains(msg, 'weekly') then
		local playerLevel = player:getLevel()
		local hasPass, expiry = hasActivePass(player)
		
		if hasPass then
			local timeLeft = expiry - os.time()
			local timeStr = formatTimeRemaining(timeLeft)
			npcHandler:say(string.format('Your Weekly Pass is active! Time remaining: %s. You can travel unlimited times for free during this period.', timeStr))
			topic = 0
		elseif playerLevel >= 1000 then
			npcHandler:say('The Weekly Pass is only available for adventurers below level 1000. You, mighty one, must pay per journey.')
			topic = 0
		else
			npcHandler:say(string.format('Ahoy! For young sailors like yourself (below level 1000), I offer a Weekly Pass for 14kk. It grants unlimited trips to the Karma Boat for 7 days. Interested?'))
			topic = 4
		end
		
	-- WEEKLY PASS - Comprar
	elseif msgcontains(msg, 'yes') and topic == 4 then
		local playerLevel = player:getLevel()
		
		if playerLevel >= 1000 then
			npcHandler:say('The Weekly Pass is only for sailors below level 1000.')
			topic = 0
		elseif player:removeTotalMoney(WEEKLY_PASS_COST) then
			local expiryTime = os.time() + WEEKLY_PASS_DURATION
			player:setStorageValue(STORAGE_KARMA_BOAT_PASS, expiryTime)
			npcHandler:say('Excellent! Your Weekly Pass is now active for 7 days. Sail as many times as you wish, mate! Just say "karma boat" whenever you want to travel.')
			topic = 0
		else
			npcHandler:say('Sorry mate, you need 14kk to purchase the Weekly Pass. Come back when you have the coin.')
			topic = 0
		end
		
	-- KARMA BOAT - Viajar
	elseif msgcontains(msg, 'karma boat') then
		local playerLevel = player:getLevel()
		local hasPass, expiry = hasActivePass(player)
		
		-- Players com Weekly Pass ativo (e level < 1000) viajam grátis
		if hasPass and playerLevel < 1000 then
			local timeLeft = expiry - os.time()
			local timeStr = formatTimeRemaining(timeLeft)
			npcHandler:say(string.format('Your Weekly Pass is active (%s remaining). Ready to sail for free?', timeStr))
			topic = 5 -- Topic para viagem grátis
		else
			-- Cobrança normal
			npcHandler:say('Only a twice Jasmin Coin per passage, but the treasures you will find are worth far more. Lets go?')
			topic = 3
		end
		
	-- VIAGEM GRÁTIS (com pass)
	elseif msgcontains(msg, 'yes') and topic == 5 then
		local hasPass = hasActivePass(player)
		if hasPass then
			selfSay('Your coin sings to the sea. Welcome to the Karma Boat!')
			doTeleportThing(cid, {x = 32297, y = 32211, z = 6})
			doSendMagicEffect(getCreaturePosition(cid), 11)
			topic = 0
		else
			npcHandler:say('Your Weekly Pass has expired. You need to pay for the trip now.')
			topic = 0
		end
		
	-- VIAGEM PAGA (sem pass)
	elseif msgcontains(msg, 'yes') and topic == 3 then
		if player:removeTotalMoney(SINGLE_TRIP_COST) then
			selfSay('Your coin sings to the sea. Welcome to the Karma Boat!')
			doTeleportThing(cid, {x = 32297, y = 32211, z = 6})
			doSendMagicEffect(getCreaturePosition(cid), 11)
			topic = 0
		else
			local playerLevel = player:getLevel()
			if playerLevel < 1000 then
				npcHandler:say('Sorry mate, but the sea wont move for free. Come back when you have got the coin, or ask me about the "weekly pass" for unlimited trips!')
			else
				npcHandler:say('Sorry mate, but the sea wont move for free. Come back when you have got a Jasmin Coin.')
			end
			topic = 0
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
