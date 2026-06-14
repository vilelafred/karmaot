dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if (npcHandler.focus ~= cid) then
        return false
    end

    if msgcontains(msg, 'travel') or msgcontains(msg, 'travel') then
        npcHandler:say('Friends of Karma are my friends too! Are you looking for a passage to {Turtle} for 120 gold, or would you like to go to {Blood} for 150 gold?')
        talk_state = 1

    elseif msgcontains(msg, 'turtle') and talk_state == 1 then
        if getCreatureCondition(cid, CONDITION_INFIGHT) ~= 1 then
            if getPlayerMoney(cid) >= 120 then
                npcHandler:say('Have a nice trip to Turtle Island!')
                doPlayerRemoveMoney(cid, 120)
                doTeleportThing(cid, {x = 32250, y = 32963, z = 7})
                doSendMagicEffect(getCreaturePosition(cid), 11)
                talk_state = 0
            else
                npcHandler:say('You don\'t have enough money for Turtle Island.')
                talk_state = 0
            end
        else
            npcHandler:say('First get rid of those blood stains! You are not going to ruin my vehicle!')
            talk_state = 0
        end

    elseif msgcontains(msg, 'blood') and talk_state == 1 then
        if getCreatureCondition(cid, CONDITION_INFIGHT) ~= 1 then
            if getPlayerMoney(cid) >= 150 then
                npcHandler:say('Have a nice trip to Blood Island!')
                doPlayerRemoveMoney(cid, 150)
                doTeleportThing(cid, {x = 32382, y = 33041, z = 7})
                doSendMagicEffect(getCreaturePosition(cid), 11)
                talk_state = 0
            else
                npcHandler:say('You don\'t have enough money for Blood Island.')
                talk_state = 0
            end
        else
            npcHandler:say('First get rid of those blood stains! You are not going to ruin my vehicle!')
            talk_state = 0
        end

    else
        npcHandler:say('I can only take you to Turtle Island or Blood Island. Please, be polite ask me "TRAVEL" first and choose one.')
        talk_state = 0
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
