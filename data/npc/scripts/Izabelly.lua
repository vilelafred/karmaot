dofile('npc/scripts/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)         npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)      npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                     npcHandler:onThink() end

-- Greeting
function greetCallback(cid)
    if getCreatureHealth(cid) <= 39 then
        npcHandler:setMessage(MESSAGE_GREET, "You are looking really bad, " .. getPlayerName(cid) .. ". Let me heal your wounds.")
        doCreatureAddHealth(cid, -getCreatureHealth(cid) + 40)
        doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_BLUE)
    else
        npcHandler:setMessage(MESSAGE_GREET, "Welcome, child of nature.")
    end
    npcHandler.topic[cid] = 0
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

-- Blessing cost
local blessCost = 20000

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then return false end
    local player = Player(cid)
    msg = msg:lower()

    -- Heal command
    if msgcontains(msg, "heal") then
        if player:getHealth() <= 39 then
            npcHandler:say("You are looking really bad. Let me heal your wounds.", cid)
            player:addHealth(40 - player:getHealth())
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        else
            npcHandler:say("You aren't looking really bad. Sorry, I can't help you.", cid)
        end
        return true
    end

    -- Blessings
    if msgcontains(msg, "bless") then
        npcHandler:say("There are five different blessings: spiritual shielding, spark of the phoenix, embrace of tibia, fire of the suns and wisdom of solitude.", cid)
        return true

    elseif msgcontains(msg, "embrace") or msgcontains(msg, "of tibia") then
        npcHandler:say("I will give you the Embrace of Tibia for 20,000 gold. Do you accept?", cid)
        npcHandler.topic[cid] = 1
        return true

    elseif msgcontains(msg, "spark") or msgcontains(msg, "phoenix") then
        npcHandler:say("Do you wish to receive my part of the blessing of the phoenix?", cid)
        npcHandler.topic[cid] = 2
        return true

    elseif msgcontains(msg, "spiritual") or msgcontains(msg, "shielding") then
        npcHandler:say("Do you want the spiritual shielding for 20,000 gold?", cid)
        npcHandler.topic[cid] = 3
        return true

    elseif msgcontains(msg, "wisdom") or msgcontains(msg, "solitude") then
        npcHandler:say("Do you wish to receive the wisdom of solitude for 20,000 gold?", cid)
        npcHandler.topic[cid] = 4
        return true

    -- Confirmations
    elseif msgcontains(msg, "yes") then
        local topic = npcHandler.topic[cid]
        if topic == 1 then
            if player:hasBlessing(2) then
                npcHandler:say("You already possess this blessing.", cid)
            elseif player:removeMoney(blessCost) then
                player:addBlessing(2)
                npcHandler:say("So receive the Embrace of Tibia.", cid)
                player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
            else
                npcHandler:say("You do not have enough money.", cid)
            end

        elseif topic == 2 then
            if player:getStorageValue(1339) <= 0 then
                player:setStorageValue(1339, 1)
                npcHandler:say("So receive the blessing of the live-giving earth.", cid)
                player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
            else
                npcHandler:say("You already possess my blessing.", cid)
            end

        elseif topic == 3 then
            if player:hasBlessing(1) then
                npcHandler:say("You already possess this blessing.", cid)
            elseif player:removeMoney(blessCost) then
                player:addBlessing(1)
                npcHandler:say("So receive the spiritual shielding.", cid)
                player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
            else
                npcHandler:say("You do not have enough money.", cid)
            end

        elseif topic == 4 then
            if player:hasBlessing(4) then
                npcHandler:say("You already possess this blessing.", cid)
            elseif player:removeMoney(blessCost) then
                player:addBlessing(4)
                npcHandler:say("So receive the wisdom of solitude.", cid)
                player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
            else
                npcHandler:say("You do not have enough money.", cid)
            end
        end
        npcHandler.topic[cid] = 0
        return true
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
