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

local config = {
   ["hydrana"] = {cost = 550, location = BOATPOS_GREENISLAND},
   ["dragon forest"] = {cost = 520, location = BOATPOS_DRAGONFOREST},  
   }
   
function creatureSayCallback(cid, type, msg)
  local player = Player(cid)
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
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
                if player:removeMoney(t.cost) then
                        npcHandler:say("Good bye ".. getPlayerName(cid) ..".", cid)
                        player:teleportTo(t.location)
                    else
                     npcHandler:say("I am sorry you have ".. getPlayerMoney(cid) .." gold coins and it costs ".. t.cost .." gold coins to travel.", cid)
                end
             end
         end
	end 
     return true
end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)


keywordHandler:addKeyword({'passenger'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "We would like to welcome you on board."})

local function addTravelKeyword(keyword, cost, destination, action)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. titleCase(keyword) .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = cost, discount = 'postman', destination = destination })
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('hydrana', 550, BOATPOS_GREENISLAND)
addTravelKeyword('dragon forest', 520, BOATPOS_DRAGONFOREST)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())