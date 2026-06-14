dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am here to provide one of the five blessings."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "My name is Norf."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Now, it is |TIME|. Ask Gorn for a watch, if you need one."})

function creatureSayCallback(cid, type, msg)
	if(npcHandler.focus ~= cid) then
		return false
	end

	if msgcontains(msg, 'heal') then
		if getCreatureHealth(cid) <= 39 then
			npcHandler:say("You are looking really bad. Let me heal your wounds.", 1)
			doCreatureAddHealth(cid, -getCreatureHealth(cid)+40)
			doSendMagicEffect(getPlayerPosition(cid), 12)
			talk_state = 0
			return true
		else
			npcHandler:say("You aren't looking really bad. Sorry, I can't help you.", 1)
			talk_state = 0
			return true
		end
	end

	-- Multiple ways to ask for blessings
	if msgcontains(msg, 'bless') or msgcontains(msg, 'blessing') or msgcontains(msg, 'all') or msgcontains(msg, 'full') or msgcontains(msg, 'complete') then
		local level = getPlayerLevel(cid)
		local price = 0
		
		if level <= 100 then
			price = 100000
		elseif level <= 200 then
			price = 200000
		elseif level <= 300 then
			price = 300000
		elseif level <= 499 then
			price = 400000
		elseif level <= 600 then
			price = 500000
		elseif level <= 700 then
			price = 600000
		elseif level <= 800 then
			price = 700000
		else
			price = 800000
		end
		
		npcHandler:say("Do you want ALL BLESS for " .. price .. " gold coins?", 1)
		talk_state = 1394
		return true
	end

	if talk_state == 1394 and msgcontains(msg, 'yes') then
		local level = getPlayerLevel(cid)
		local price = 0
		
		if level <= 100 then
			price = 100000
		elseif level <= 200 then
			price = 200000
		elseif level <= 300 then
			price = 300000
		elseif level <= 499 then
			price = 400000
		elseif level <= 600 then
			price = 500000
		elseif level <= 700 then
			price = 600000
		elseif level <= 800 then
			price = 700000
		else
			price = 800000
		end
		local playerName = getPlayerName(cid)

		-- Debug log
		print("DEBUG: Player " .. playerName .. " requested all blessings from Monge")

		-- Verificação se o jogador já tem todas as blessings
		local hasAllBlessings = true
		local currentBlessings = {}
		
		for i = 1, 5 do
			local hasBlessing = getPlayerBlessing(cid, i)
			currentBlessings[i] = hasBlessing
			if not hasBlessing then
				hasAllBlessings = false
			end
			print("DEBUG: Player " .. playerName .. " - Blessing " .. i .. " = " .. tostring(hasBlessing))
		end

		if hasAllBlessings then
			npcHandler:say("You already possess all blessings.", 1)
			print("DEBUG: Player " .. playerName .. " already has all blessings")
			talk_state = 0
			return true
		end

        -- Aceita pagamento usando dinheiro da mochila e/ou banco
        local player = Player(cid)
        if player and player:removeTotalMoney(price) then
			-- Add all blessings
			local blessingsAdded = 0
			for i = 1, 5 do
				if not currentBlessings[i] then
					if doPlayerAddBlessing(cid, i) then
						blessingsAdded = blessingsAdded + 1
						print("DEBUG: Blessing " .. i .. " added for " .. playerName)
					else
						print("DEBUG: Error adding blessing " .. i .. " for " .. playerName)
					end
				end
			end

			-- Count total blessings after adding
			local totalBlessings = 0
			for i = 1, 5 do
				if getPlayerBlessing(cid, i) then
					totalBlessings = totalBlessings + 1
				end
			end

			npcHandler:say("Now you have all Bless in this world. (" .. totalBlessings .. "/5)", 1)
			doSendMagicEffect(getPlayerPosition(cid), 13)
			setPlayerStorageValue(cid, 30006, 1)
			print("DEBUG: " .. blessingsAdded .. " blessings added for " .. playerName .. " - Total: " .. totalBlessings .. "/5")
			talk_state = 0
		else
			npcHandler:say("Oh. You do not have enough money.", 1)
			print("DEBUG: Player " .. playerName .. " doesn't have enough money")
			talk_state = 0
		end

	elseif talk_state == 1394 and msgcontains(msg, '') then
		npcHandler:say("Ok. Suits me.", 1)
		talk_state = 0

	elseif msgcontains(msg, 'phoenix') then
		npcHandler:say("The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon.", 1)
		talk_state = 0

	elseif msgcontains(msg, 'embrace') then
		npcHandler:say("The druids north of Carlin will provide you with the embrace of tibia.", 1)
		talk_state = 0

	elseif msgcontains(msg, 'suns') then
		npcHandler:say("You can ask for the blessing of the two suns in the suntower near Ab'Dendriel.", 1)
		talk_state = 0

	elseif msgcontains(msg, 'wisdom') then
		npcHandler:say("Talk to the hermit Eremo on the isle of Cormaya about this blessing.", 1)
		talk_state = 0

	elseif msgcontains(msg, 'spiritual') then
		npcHandler:say("You can ask for the blessing of spiritual shielding the whiteflower temple south of Thais.", 1)
		talk_state = 0
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
