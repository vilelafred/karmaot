local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)      
    npcHandler:onCreatureAppear(cid)         
end

function onCreatureDisappear(cid)      
    npcHandler:onCreatureDisappear(cid)         
end

function onCreatureSay(cid, type, msg)      
    npcHandler:onCreatureSay(cid, type, msg)      
end

function onThink()       
    npcHandler:onThink()         
end

local config = {
    [1] = {fee = 20, name = 'beginner', storage = 123},
    [2] = {fee = 40, name = 'intermediate', storage = 123},
}

local function creatureSayCallback(cid, type, msg)
    local player = Player(cid)
    local storage = 123
    local firstArenaCompleted, secondArenaCompleted = 1234, 12345
    local canEnterArena = 123457
    local currentArena = config[player:getStorageValue(storage)] 

    if not npcHandler:isInRange(cid) then
        return false
    end

    npcHandler.topic = npcHandler.topic or {}

    if msgcontains(msg, 'arena') then
        if player:getStorageValue(storage) < 1 then
            player:setStorageValue(storage, 1)
        end

        if player:getStorageValue(firstArenaCompleted) == 1 and player:getStorageValue(secondArenaCompleted) == 1 then
            npcHandler:say('You\'ve already completed all arenas.', cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getStorageValue(canEnterArena) > 0 and player:getStorageValue(firstArenaCompleted) ~= 1 and player:getStorageValue(secondArenaCompleted) ~= 1 then
            npcHandler:say('You are able to enter the arena, go and beat it!', cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getStorageValue(canEnterArena) and player:getStorageValue(firstArenaCompleted) == 1 then
            player:setStorageValue(storage, 2)
            currentArena = config[player:getStorageValue(storage)]
        end

        npcHandler:say('So you want to enter the '.. currentArena.name ..' arena? The fee is '.. currentArena.fee ..' gold pieces. Do you really want to participate and pay the fee?', cid)
        npcHandler.topic[cid] = player:getStorageValue(storage)
    elseif msgcontains(msg, 'yes') then
        if player:removeMoney(currentArena.fee) then
            player:setStorageValue(canEnterArena, player:getStorageValue(storage))
            npcHandler:say('As you wish! You can enter the teleporter now.', cid)
        else
            npcHandler:say('You do not have enough money.', cid)
        end
    end

    return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello! Do you want to enter the {arena}?')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
