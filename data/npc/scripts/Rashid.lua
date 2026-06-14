local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Eventos do NPC
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Configuração da loja
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- Lista de itens vendáveis
shopModule:addSellableItem({'dragon scale mail'}, 2492, 40000, 'dragon scale mail')
shopModule:addSellableItem({'dwarven armor'}, 2503, 30000, 'dwarven armor')
shopModule:addSellableItem({'golden armor'}, 2466, 20000, 'golden armor')
shopModule:addSellableItem({'leopard armor'}, 3968, 1000, 'leopard armor')
shopModule:addSellableItem({'magic plate armor'}, 2472, 90000, 'magic plate armor')
shopModule:addSellableItem({'golden legs'}, 2470, 70000, 'golden legs')
shopModule:addSellableItem({'bone shield'}, 2548, 1000, 'bone shield')
shopModule:addSellableItem({'dark shield'}, 2524, 1000, 'dark shield')
shopModule:addSellableItem({'demon shield'}, 2520, 30000, 'demon shield')
shopModule:addSellableItem({'medusa shield'}, 2536, 9000, 'medusa shield')
shopModule:addSellableItem({'scarab shield'}, 2540, 2000, 'scarab shield')
shopModule:addSellableItem({'mastermind shield'}, 2514, 50000, 'mastermind shield')
shopModule:addSellableItem({'beholder helmet'}, 3972, 7500, 'beholder helmet')
shopModule:addSellableItem({'devil helmet'}, 2462, 1000, 'devil helmet')
shopModule:addSellableItem({'crocodile boots'}, 3892, 1000, 'crocodile boots')
shopModule:addSellableItem({'steel boots'}, 2645, 30000, 'steel boots')
shopModule:addSellableItem({'daramanian mace'}, 2439, 110, 'daramanian mace')
shopModule:addSellableItem({'daramanian waraxe'}, 2440, 1000, 'daramanian waraxe')
shopModule:addSellableItem({'guardian halberd'}, 2427, 11000, 'guardian halberd')
shopModule:addSellableItem({'heavy machete'}, 2442, 90, 'heavy machete')
shopModule:addSellableItem({'silver dagger'}, 2402, 500, 'silver dagger')
shopModule:addSellableItem({'war axe'}, 2454, 9000, 'war axe')
shopModule:addSellableItem({'dragon slayer'}, 7418, 15000, 'dragon slayer')
shopModule:addSellableItem({'ancient amulet'}, 2142, 200, 'ancient amulet')
shopModule:addSellableItem({'crystal necklace'}, 2125, 400, 'crystal necklace')
shopModule:addSellableItem({'crystal ring'}, 2124, 250, 'crystal ring')
shopModule:addSellableItem({'demonbone amulet'}, 2136, 32000, 'demonbone amulet')
shopModule:addSellableItem({'emerald bangle'}, 2127, 800, 'emerald bangle')
shopModule:addSellableItem({'golden ring'}, 2179, 8000, 'golden ring')
shopModule:addSellableItem({'platinum amulet'}, 2172, 500, 'platinum amulet')
shopModule:addSellableItem({'ring of the sky'}, 2123, 30000, 'ring of the sky')
shopModule:addSellableItem({'ruby necklace'}, 2133, 2000, 'ruby necklace')
shopModule:addSellableItem({'scarab amulet'}, 2135, 200, 'scarab amulet')
shopModule:addSellableItem({'silver brooch'}, 2134, 150, 'silver brooch')
shopModule:addSellableItem({'doll'}, 2100, 200, 'doll')
shopModule:addSellableItem({'voodoo doll'}, 3955, 400, 'voodoo doll')


-- Função para controlar quem pode falar com o NPC
function greetCallback(cid)
	-- Storage da Postman Quest
	local STORAGE_POSTMAN_DOOR = 25003 -- Storage correta do servidor
	
	if getPlayerStorageValue(cid, STORAGE_POSTMAN_DOOR) == 5 then -- Tem a quest completa
		return true
	else -- Não tem a quest - aplicar restrição de dias
		local day = os.date("*t").wday
		local allowedDays = {
			[1] = true, -- Domingo
			[4] = true, -- Quarta-feira
			[6] = true, -- Sexta-feira
			[7] = true  -- Sábado
		}
		
		if allowedDays[day] then
			return true -- É dia permitido
		else
			npcHandler:say('I\'m sorry, you aren\'t an Arch Postman. I only trade with honoured members of the Tibian Postmaster\'s Guild on Wednesdays, Fridays, Saturdays, and Sundays.', cid)
			return false
		end
	end
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

-- Callback para falas padrão
function creatureSayCallback(cid, type, msg)
	if npcHandler.focus ~= cid then
		return false
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())