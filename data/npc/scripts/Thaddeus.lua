local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Carrega as bibliotecas necessárias
dofile('data/lib/backpack_shop_module.lua')

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

local customSellList = {} -- salva manualmente os itens vendáveis

local function increasePrice(originalPrice)
    return math.ceil(originalPrice * 1.2)
end

local function addSellItem(keywords, itemId, price, displayName)
    shopModule:addSellableItem(keywords, itemId, price, displayName)
    table.insert(customSellList, {keywords = keywords, itemId = itemId, sellPrice = price})
end


addSellItem({'amulet of loss'}, 2173, increasePrice(30000), 'amulet of loss')
addSellItem({'old great shield'}, 2522, increasePrice(120000), 'old great shield')
addSellItem({'dragon scale legs'}, 2469, increasePrice(150000), 'dragon scale legs')
addSellItem({'dragon scale helmet'}, 2506, increasePrice(120000), 'dragon scale helmet')
addSellItem({'dragonsilver shield'}, 6156, increasePrice(12000), 'dragonsilver shield')
addSellItem({'red legs'}, 5810, increasePrice(11000), 'red legs')
addSellItem({'paladin armor'}, 7626, increasePrice(15000), 'paladin armor')
addSellItem({'red magician hat'}, 5796, increasePrice(11000), 'red magician hat')
addSellItem({'shadow sceptre'}, 7576, increasePrice(10000), 'shadow sceptre')
addSellItem({'compass'}, 8069, increasePrice(700), 'compass')
addSellItem({'old robe'}, 2655, increasePrice(700), 'old robe')
addSellItem({'red robe'}, 5780, increasePrice(80000), 'red robe')
addSellItem({'alpha scale mail'}, 5799, increasePrice(80000), 'alpha scale mail')
addSellItem({'royal crossbow'}, 7592, increasePrice(150000), 'royal crossbow')
addSellItem({'skullcracker armor'}, 7624, increasePrice(18000), 'skullcracker armor')
addSellItem({'glacier kilt'}, 7904, increasePrice(11000), 'glacier kilt')
addSellItem({'hammer of wrath'}, 2444, increasePrice(30000), 'hammer of wrath')
addSellItem({'demon horn'}, 5908, increasePrice(10000), 'demon horn')
addSellItem({'fiery shield'}, 7633, increasePrice(50000), 'fiery shield')
addSellItem({'rainbow shield'}, 7632, increasePrice(90000), 'rainbow shield')
addSellItem({'alpha scale armor'}, 6117, increasePrice(50000), 'alpha scale armor')
addSellItem({'robe of the underworld'}, 7625, increasePrice(60000), 'robe of the underworld')
addSellItem({'earthborn titan armor'}, 7617, increasePrice(60000), 'earthborn titan armor')
addSellItem({'nightmare blade'}, 7434, increasePrice(35000), 'nightmare blade')
addSellItem({'assassin dagger'}, 7420, increasePrice(20000), 'assassin dagger')
addSellItem({'magma coat'}, 6872, increasePrice(11000), 'magma coat')
addSellItem({'magma monocle'}, 6873, increasePrice(11000), 'magma monocle')
addSellItem({'talon'}, 2151, increasePrice(320), 'talon')
addSellItem({'dread helmet'}, 6173, increasePrice(11000), 'dread helmet')
addSellItem({'magma legs'}, 6869, increasePrice(11000), 'magma legs')
addSellItem({'magma boots'}, 6867, increasePrice(11000), 'magma boots')
addSellItem({'lightning boots'}, 6868, increasePrice(11000), 'lightning boots')
addSellItem({'lightning glasses'}, 6874, increasePrice(11000), 'lightning glasses')
addSellItem({'lightning armor'}, 6871, increasePrice(11000), 'lightning armor')
addSellItem({'lightning legs'}, 6870, increasePrice(11000), 'lightning legs')
addSellItem({'terra legs'}, 6863, increasePrice(11000), 'terra legs')
addSellItem({'terra hood'}, 6875, increasePrice(2500), 'terra hood')
addSellItem({'terra mantle'}, 6862, increasePrice(11000), 'terra mantle')
addSellItem({'terra amulet'}, 6865, increasePrice(1500), 'terra amulet')
addSellItem({'tempest shield'}, 2542, increasePrice(100000), 'tempest shield')
addSellItem({'sword of queen'}, 6183, increasePrice(120000), 'sword of queen')
addSellItem({'queen legs'}, 6178, increasePrice(50000), 'queen legs')
addSellItem({'queen helmet'}, 6177, increasePrice(100000), 'queen helmet')
addSellItem({'blue wing'}, 5966, increasePrice(1000), 'blue wing')
addSellItem({'blue vase'}, 2576, increasePrice(1000), 'blue vase')
addSellItem({'sapphire amulet'}, 2138, increasePrice(10000), 'sapphire amulet')
addSellItem({'blue scale'}, 5964, increasePrice(2000), 'blue scale')
addSellItem({'golden amulet'}, 2130, increasePrice(2000), 'golden amulet')
addSellItem({'yellow gem'}, 2154, increasePrice(900), 'yellow gem')
addSellItem({'golden fruits'}, 2137, increasePrice(3000), 'golden fruits')
addSellItem({'yellow scale'}, 5968, increasePrice(3000), 'yellow scale')
addSellItem({'white xscale'}, 5959, increasePrice(900), 'white xscale')
addSellItem({'golden egg'}, 5969, increasePrice(10000), 'golden egg')
addSellItem({'yellow wing'}, 5970, increasePrice(9000), 'yellow wing')
addSellItem({'dwarven armor'}, 2503, increasePrice(30000), 'dwarven armor')
addSellItem({'golden armor'}, 2466, increasePrice(20000), 'golden armor')
addSellItem({'leopard armor'}, 3968, increasePrice(1000), 'leopard armor')
addSellItem({'magic plate armor'}, 2472, increasePrice(90000), 'mpa')
addSellItem({'plate armor'}, 2463, increasePrice(400), 'plate armor')
addSellItem({'dragon slayer'}, 7418, increasePrice(15000), 'dragon slayer')
addSellItem({'golden legs'}, 2470, increasePrice(70000), 'golden legs')
addSellItem({'bone shield'}, 25480, increasePrice(8000), 'bone shield')
addSellItem({'dark shield'}, 252400, increasePrice(9000), 'dark shield')
addSellItem({'dread shield'}, 5781, increasePrice(30000), 'dread shield')
addSellItem({'dread armor'}, 6179, increasePrice(30000), 'dread armor')
addSellItem({'demon shield'}, 2520, increasePrice(30000), 'demon shield')
addSellItem({'medusa shield'}, 2536, increasePrice(9000), 'medusa shield')
addSellItem({'scarab shield'}, 2540, increasePrice(2000), 'scarab shield')
addSellItem({'mastermind shield'}, 2514, increasePrice(50000), 'mastermind shield')
addSellItem({'beholder helmet'}, 3972, increasePrice(7500), 'beholder helmet')
addSellItem({'devil helmet'}, 2462, increasePrice(1000), 'devil helmet')
addSellItem({'demon helmet'}, 2493, increasePrice(90000), 'demon helmet')
addSellItem({'demon armor'}, 2494, increasePrice(90000), 'demon armor')
addSellItem({'demon legs'}, 2495, increasePrice(150000), 'demon legs')
addSellItem({'black demon helmet'}, 5973, increasePrice(90000), 'black demon helmet')
addSellItem({'crocodile boots'}, 3892, increasePrice(1000), 'crocodile boots')
addSellItem({'traper boots'}, 2642000, increasePrice(30000), 'traper boots')
addSellItem({'steel boots'}, 2645, increasePrice(30000), 'steel boots')
addSellItem({'daramanian mace'}, 2439, increasePrice(110), 'daramanian mace')
addSellItem({'daramanian waraxe'}, 2440, increasePrice(1000), 'daramanian waraxe')
addSellItem({'guardian halberd'}, 2427, increasePrice(11000), 'guardian halberd')
addSellItem({'heavy machete'}, 2442, increasePrice(90), 'heavy machete')
addSellItem({'silver dagger'}, 2402, increasePrice(500), 'silver dagger')
addSellItem({'war axe'}, 2454, increasePrice(9000), 'war axe')
addSellItem({'ancient amulet'}, 2142, increasePrice(200), 'ancient amulet')
addSellItem({'crystal necklace'}, 2125, increasePrice(400), 'crystal necklace')
addSellItem({'crystal ring'}, 2124, increasePrice(250), 'crystal ring')
addSellItem({'demonbone amulet'}, 2136, increasePrice(32000), 'demonbone amulet')
addSellItem({'emerald bangle'}, 2127, increasePrice(800), 'emerald bangle')
addSellItem({'golden ring'}, 2179, increasePrice(8000), 'golden ring')
addSellItem({'platinum amulet'}, 2171, increasePrice(2500), 'platinum amulet')
addSellItem({'ring of the sky'}, 2123, increasePrice(30000), 'ring of the sky')
addSellItem({'ruby necklace'}, 2133, increasePrice(2000), 'ruby necklace')
addSellItem({'scarab amulet'}, 2135, increasePrice(200), 'scarab amulet')
addSellItem({'silver brooch'}, 2134, increasePrice(150),'silver brooch')
addSellItem({'doll'}, 2100, increasePrice(200), 'doll')
addSellItem({'voodoo doll'}, 3955, increasePrice(400), 'voodoo doll')
addSellItem({'serpent sword'}, 2409, increasePrice(900), 'serpent sword')
addSellItem({'dragon hammer'}, 2434, increasePrice(2000), 'dragon hammer')
addSellItem({'giant sword'}, 2393, increasePrice(17000), 'giant sword')
addSellItem({'poison dagger'}, 2411, increasePrice(50), 'poison dagger')
addSellItem({'scimitar'}, 2419, increasePrice(150), 'scimitar')
addSellItem({'skull staff'}, 2436, increasePrice(6000), 'skull staff')
addSellItem({'knight axe'}, 2430, increasePrice(2000), 'knight axe')
addSellItem({'tower shield'}, 2528, increasePrice(8000), 'tower shield')
addSellItem({'black shield'}, 2529, increasePrice(800), 'black shield')
addSellItem({'ancient shield'}, 2532, increasePrice(900), 'ancient shield')
addSellItem({'vampire shield'}, 2534, increasePrice(15000), 'vampire shield')
addSellItem({'warrior helmet'}, 2475, increasePrice(5000), 'warrior helmet')
addSellItem({'knight armor'}, 2476, increasePrice(5000), 'knight armor')
addSellItem({'knight legs'}, 2477, increasePrice(5000), 'knight legs')
addSellItem({'strange helmet'}, 2479, increasePrice(500), 'strange helmet')
addSellItem({'dark armor'}, 2489, increasePrice(400), 'dark armor')
addSellItem({'dark helmet'}, 2490, increasePrice(250), 'dark helmet')
addSellItem({'mystic turban'}, 2663, increasePrice(150), 'mystic turban')
addSellItem({'spike sword'}, 2383, increasePrice(1000), 'spike sword')
addSellItem({'fire sword'}, 2392, increasePrice(4000), 'fire sword')
addSellItem({'war hammer'}, 2391, increasePrice(1200), 'war hammer')
addSellItem({'ice rapier'}, 2396, increasePrice(1000), 'ice rapier')
addSellItem({'broad sword'}, 2413, increasePrice(500), 'broad sword')
addSellItem({'dragon lance'}, 2414, increasePrice(9000), 'dragon lance')
addSellItem({'obsidian lance'}, 2425, increasePrice(500), 'obsidian lance')
addSellItem({'fire axe'}, 2432, increasePrice(8000), 'fire axe')
addSellItem({'guardian shield'}, 2515, increasePrice(2000), 'guardian shield')
addSellItem({'dragon shield'}, 2516, increasePrice(4000), 'dragon shield')
addSellItem({'beholder shield'}, 2518, increasePrice(1200), 'beholder shield')
addSellItem({'crown shield', 'c shield'}, 2519, increasePrice(8000), 'crown shield')
addSellItem({'phoenix shield'}, 2539, increasePrice(16000), 'phoenix shield')
addSellItem({'noble armor'}, 2486, increasePrice(900), 'noble armor')
addSellItem({'crown armor'}, 2487, increasePrice(12000), 'crown armor')
addSellItem({'crown legs'}, 2488, increasePrice(12000), 'crown legs')
addSellItem({'crown helmet'}, 2491, increasePrice(2500), 'crown helmet')
addSellItem({'crusader helmet'}, 2497, increasePrice(6000), 'crusader helmet')
addSellItem({'royal helmet'}, 2498, increasePrice(30000), 'royal helmet')
addSellItem({'grey helmet'}, 5798, increasePrice(35000), 'grey helmet')
addSellItem({'blue robe'}, 2656, increasePrice(10000), 'blue robe')
addSellItem({'boots of haste'}, 2195, increasePrice(30000), 'boots of haste')
addSellItem({'dragon scale mail'}, 2492, increasePrice(40000), 'dragon scale mail')
addSellItem({'alpha scale armor'}, 6117, increasePrice(40000), 'alpha scale armor')
addSellItem({'magic lightwand'}, 2162, increasePrice(35), 'magic lightwand')
addSellItem({'elven amulet'}, 2198, increasePrice(100), 'elven amulet')
addSellItem({'garlic necklace'}, 2199, increasePrice(50), 'garlic necklace')
addSellItem({'bronze amulet'}, 2172, increasePrice(50), 'bronze amulet')
addSellItem({'mind stone'}, 2178, increasePrice(100), 'mind stone')
addSellItem({'life crystal'}, 2177, increasePrice(50), 'life crystal')
addSellItem({'orb'}, 2176, increasePrice(750), 'orb')
addSellItem({'wand of vortex'}, 2190, increasePrice(100), 'wand of vortex')
addSellItem({'wand of dragonbreath'}, 2191, increasePrice(200), 'wand of dragonbreath')
addSellItem({'wand of plague'}, 2188, increasePrice(1000), 'wand of plague')
addSellItem({'wand of cosmic energy'}, 2189, increasePrice(2000), 'wand of cosmic energy')
addSellItem({'wand of inferno'}, 2187, increasePrice(3000), 'wand of inferno')
addSellItem({'sunfire wand'}, 6086, increasePrice(5000), 'sunfire wand')
addSellItem({'silver amulet'}, 2170, increasePrice(50), 'silver amulet')
addSellItem({'strange talisman'}, 2161, increasePrice(30), 'strange talisman')
addSellItem({'protection amulet'}, 2200, increasePrice(100), 'protection amulet')
addSellItem({'dragon necklace'}, 2201, increasePrice(100), 'dragon necklace')
addSellItem({'mysterious fetish'}, 2194, increasePrice(50), 'mysterious fetish')
addSellItem({'ankh'}, 2193, increasePrice(100), 'ankh')
addSellItem({'snakebite rod'}, 2182, increasePrice(100), 'snakebite rod')
addSellItem({'moonlight rod'}, 2186, increasePrice(200), 'moonlight rod')
addSellItem({'volcanic rod'}, 2185, increasePrice(1000), 'volcanic rod')
addSellItem({'quagmire rod'}, 2181, increasePrice(2000), 'quagmire rod')
addSellItem({'tempest rod'}, 2183, increasePrice(3000), 'tempest rod')
addSellItem({'two handed sword'}, 2377, increasePrice(450), 'two handed sword')
addSellItem({'battle axe'}, 2378, increasePrice(80), 'battle axe')
addSellItem({'dagger'}, 2379, increasePrice(2), 'dagger')
addSellItem({'hand axe'}, 2380, increasePrice(4), 'hand axe')
addSellItem({'halberd'}, 2381, increasePrice(400), 'halberd')
addSellItem({'rapier'}, 2384, increasePrice(5), 'rapier')
addSellItem({'sabre'}, 2385, increasePrice(12), 'sabre')
addSellItem({'spear'}, 2389, increasePrice(3), 'spear')
addSellItem({'morning star'}, 2394, increasePrice(90), 'morning star')
addSellItem({'mace'}, 2398, increasePrice(30), 'mace')
addSellItem({'short sword'}, 2406, increasePrice(10), 'short sword')
addSellItem({'battle hammer'}, 2417, increasePrice(120), 'battle hammer')
addSellItem({'skull hammer'}, 6154, increasePrice(19000), 'skull hammer')
addSellItem({'sword'}, 2376, increasePrice(25), 'sword')
addSellItem({'scarab coin'}, 2159, increasePrice(100), 'scarab coin')
addSellItem({'white pearl'}, 2143, increasePrice(160), 'white pearl')
addSellItem({'black pearl'}, 2144, increasePrice(280), 'black pearl')
addSellItem({'small diamond'}, 2145, increasePrice(300), 'small diamond')
addSellItem({'small sapphire'}, 2146, increasePrice(250), 'small sapphire')
addSellItem({'small ruby'}, 2147, increasePrice(250), 'small ruby')
addSellItem({'small emerald'}, 2149, increasePrice(250), 'small emerald')
addSellItem({'small amethyst'}, 2150, increasePrice(200), 'small amethyst')
addSellItem({'swamp amulet'}, 6172, increasePrice(5000), 'swamp amulet')
addSellItem({'brass armor'}, 2465, increasePrice(150), 'brass armor')
addSellItem({'brass legs'}, 2478, increasePrice(49), 'brass legs')
addSellItem({'brass helmet'}, 2460, increasePrice(30), 'brass helmet')
addSellItem({'plate shield'}, 2510, increasePrice(45), 'plate shield')
addSellItem({'brass shield'}, 2511, increasePrice(25), 'brass shield')
addSellItem({'dark helmet'}, 2490, increasePrice(250), 'dark helmet')
addSellItem({'scale armor'}, 2483, increasePrice(75), 'scale armor')
addSellItem({'steel helmet'}, 2457, increasePrice(250), 'steel helmet')
addSellItem({'double'}, 2387, increasePrice(260), 'double axe')
addSellItem({'crossbow'}, 2455, increasePrice(120), 'crossbow')
addSellItem({'chain legs'}, 2648, increasePrice(80), 'chain legs')
addSellItem({'chain armor'}, 2464, increasePrice(70), 'chain armor')
addSellItem({'hatchet'}, 2388, increasePrice(25), 'hatchet')

function greetCallback(cid)
	if getPlayerStorageValue(cid, STORAGE_POSTMAN_DOOR) == 5 then
		return true
	else
		npcHandler:say("I'm sorry, you aren't an Arch Postman. I only trade with honoured members of the Tibian Postmaster's Guild.", cid)
		return false
	end
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

-- Usando funções nativas do TFS modificado para trabalhar apenas com itens da backpack

function creatureSayCallback(cid, type, msg)
	if npcHandler.focus ~= cid then
		return false
	end

	msg = msg:lower()

	if msg == "sell all items" then
		npcHandler:say("Are you sure you want to sell all your sellable items? Say 'yes' to confirm.", cid)
		npcHandler.talkStart = os.time()
		npcHandler.waitingForConfirmation = true
		return true
	end

	if msg == "yes" and npcHandler.waitingForConfirmation and npcHandler.talkStart and (os.time() - npcHandler.talkStart) <= 30 then
		local totalGold = 0
		local soldItems = {}

		for i = 1, #customSellList do
			local itemInfo = customSellList[i]
			local keywords = itemInfo.keywords
			local itemId = itemInfo.itemId
			local sellPrice = itemInfo.sellPrice

			local player = Player(cid)
			local count = player:getBackpackItemCount(itemId)
			if count > 0 then
				local totalPrice = sellPrice * count
				local ret = doPlayerSellBackpackItem(cid, itemId, count, totalPrice)
				if ret == LUA_NO_ERROR then
					totalGold = totalGold + totalPrice
					table.insert(soldItems, count .. "x " .. keywords[1])
				end
			end
		end

		if totalGold > 0 then
			npcHandler:say("I have bought the following items from you:\n" ..
				table.concat(soldItems, ", ") .. ".\nYou received a total of " .. totalGold .. " gold coins.", cid)
		else
			npcHandler:say("You have no sellable items in your backpack.", cid)
		end
		
		npcHandler.talkStart = nil
		npcHandler.waitingForConfirmation = false
		return true
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
