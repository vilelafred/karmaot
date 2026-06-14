local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Config
local TOKEN_ID = 5823

local OFFERS = {
	book     = { title = 'Book of Training',     cost = 500,   rewardId = 6155 },
	fluid    = { title = 'Fluid of Training',    cost = 700,  rewardId = 6149 },
	dummy    = { title = 'Ferumbras Dummy Kit',  cost = 100,   rewardId = 3909 },
	rashid   = { title = 'Rashid Scroll',        cost = 500,  rewardId = 6835 },
	thaddeus = { title = 'Thaddeus Scroll',      cost = 1000,  rewardId = 6850 },
	teddy    = { title = 'Teddy Bear',           cost = 500,  rewardId = 2112 },
	-- Novas ofertas
	santadoll    = { title = 'Santa Doll',           cost = 1000, rewardId = 6842 },
	expscroll    = { title = 'Exp Scroll',           cost = 500,  rewardId = 6837 },
	santahat     = { title = 'Santa Hat',            cost = 1000, rewardId = 6845 },
	oldgolden    = { title = 'Old Golden Helmet',    cost = 5000, rewardId = 6624 },
	pandateddy   = { title = 'Panda Teddy',          cost = 500,  rewardId = 5080 },
	santabackpack= { title = 'Santa Backpack',       cost = 100,  rewardId = 5895 }
}

local function sayOffer(cid)
	npcHandler:say(
		"My holiday deals paid with Christmas Tokens:\n" ..
		"- book: Book of Training for 500 tokens\n" ..
		"- fluid: Fluid of Training for 700 tokens\n" ..
		"- dummy: Ferumbras Dummy Kit for 100 tokens\n" ..
		"- rashid: Rashid Scroll for 500 tokens\n" ..
		"- thaddeus: Thaddeus Scroll for 1000 tokens\n" ..
		"- teddy: Teddy Bear for 500 tokens\n" ..
		"- santadoll: Santa Doll for 1000 tokens\n" ..
		"- expscroll: Exp Scroll for 500 tokens\n" ..
		"- santahat: Santa Hat for 1000 tokens\n" ..
		"- oldgolden: Old Golden Helmet for 5000 tokens\n" ..
		"- pandateddy: Panda Teddy for 500 tokens\n" ..
		"- santabackpack: Santa Backpack for 100 tokens\n" ..
		"Say 'trade <key>' to proceed. Example: trade book",
		cid
	)
end

local function trade(cid, key)
	local offer = OFFERS[key]
	if not offer then
		npcHandler:say("I don't recognize that deal. Say 'offer' to see keys.", cid)
		return true
	end

	if getPlayerItemCount(cid, TOKEN_ID) < offer.cost then
		npcHandler:say("You don't have enough Christmas Tokens.", cid)
		return true
	end

	-- remove tokens first
	if not doPlayerRemoveItem(cid, TOKEN_ID, offer.cost) then
		npcHandler:say("I couldn't take your tokens. Make sure they are in your backpack.", cid)
		return true
	end

	-- try to add reward
	local item = doPlayerAddItem(cid, offer.rewardId, 1)
	if not item then
		-- refund on failure
		doPlayerAddItem(cid, TOKEN_ID, offer.cost)
		npcHandler:say("Not enough space or capacity. Clear some space and try again.", cid)
		return true
	end

	npcHandler:say("Done! Enjoy your " .. offer.title .. ".", cid)
	return true
end

local function greetCallback(cid)
	npcHandler:say("Ho ho ho! Merry greetings, |PLAYERNAME|. Ask me about 'offer'.", cid)
	return true
end

local function creatureSayCallback(cid, type, msg)
	if npcHandler.focus ~= cid then
		return false
	end

	msg = msg:lower()

	if msg == 'offer' or msg == 'list' then
		sayOffer(cid)
		return true
	end

	local key = msg:match('^trade%s+([%w%-_]+)$')
	if key then
		trade(cid, key)
		return true
	end

	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())