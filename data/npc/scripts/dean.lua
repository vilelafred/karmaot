dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local talk_state = 0
local current_dest = nil

function creatureSayCallback(cid, type, msg)
    if npcHandler.focus ~= cid then return false end

    msg = msg:lower()

    if msgcontains(msg, 'alva') then
        npcHandler:say("Friends of Karma are my friends too! So you are looking for a passage to Alva for 280 gold?", cid)
        talk_state = 1
        current_dest = {x = 33307, y = 32074, z = 6}

    elseif msgcontains(msg, 'alzude') then
        npcHandler:say("Ah, the hidden path to Alzude? I can take you there for 280 gold. Interested?", cid)
        talk_state = 1
        current_dest = {x = 31999, y = 31288, z = 7}

    elseif msgcontains(msg, 'yes') and talk_state == 1 and current_dest then
        local player = Player(cid)
        local cost = 280
        if player then
            local totalMoney = player:getMoney() + player:getBankBalance()
            if totalMoney >= cost then
                local fromInventory = math.min(player:getMoney(), cost)
                local fromBank = cost - fromInventory
                if fromInventory > 0 then
                    player:removeMoney(fromInventory)
                end
                if fromBank > 0 then
                    player:setBankBalance(player:getBankBalance() - fromBank)
                end

                local usedText = "You have used"
                if fromInventory > 0 then usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack" end
                if fromBank > 0 then if fromInventory > 0 then usedText = usedText .. " and" end; usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account" end
                usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
                player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                npcHandler:say("Have a nice trip!", cid)
                doTeleportThing(cid, current_dest)
                doSendMagicEffect(current_dest, CONST_ME_TELEPORT)
            else
                npcHandler:say("You don't have enough money.", cid)
            end
        end
        talk_state = 0
        current_dest = nil
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
