dofile('data/npc/lib/npcsystem/npcsystem.lua')

local config = {
    bet = {
        min = 50000,
        max = 6000000,
        win = 150,      -- 150% de retorno no high/low (ganha 50%)
        winNum = 300,   -- 300% se acertar número exato (ganha 200%)
    },
    playerPosition = Position(32350, 32219, 5),
    dicerCounter   = Position(32349, 32218, 5),
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end

function onThink()
    npcHandler:onThink()
    local tile = Tile(config.playerPosition)
    if tile then
        local player = tile:getTopCreature()
        if not player then
            npcHandler.focuses = {}
            npcHandler:updateFocus()
        end
    end
end

local function getCoinValue(id)
    if id == 2160 then return 10000 end
    if id == 2152 then return 100 end
    if id == 2148 then return 1 end
    return 0
end

local function getBetValue()
    local value = 0
    local tile = Tile(config.dicerCounter)
    if not tile then return nil end

    local items = tile:getItems()
    if not items or #items == 0 then return nil end

    local tempMoney = {}
    for _, item in pairs(items) do
        if table.contains({2160, 2152, 2148}, item:getId()) then
            value = value + getCoinValue(item:getId()) * item:getCount()
            table.insert(tempMoney, item)
        end
    end

    if value >= config.bet.min and value <= config.bet.max then
        for _, item in pairs(tempMoney) do
            item:remove()
        end
        return value
    end
    return nil
end

local function createMoney(money)
    local stack = {}
    local remaining = money

    local crystals = math.floor(remaining / 10000)
    remaining = remaining - crystals * 10000
    while crystals > 0 do
        local count = math.min(100, crystals)
        table.insert(stack, {2160, count})
        crystals = crystals - count
    end

    local platinums = math.floor(remaining / 100)
    if platinums > 0 then
        table.insert(stack, {2152, platinums})
        remaining = remaining - platinums * 100
    end

    if remaining > 0 then
        table.insert(stack, {2148, remaining})
    end

    return stack
end

local function greetCallback(cid)
    local player = Player(cid)
    if player:getPosition() ~= config.playerPosition then
        npcHandler:say("Step in front of me to play, boss.", cid)
        return false
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    if npcHandler.focus ~= cid then return false end

    local player = Player(cid)
    if player:getPosition() ~= config.playerPosition then
        npcHandler:unGreet(cid)
        return false
    end

    local thisNpc = Npc(getNpcCid())
    if table.contains({"low", "high", "h", "l", "1", "2", "3", "4", "5", "6"}, msg) then
        local bet = getBetValue()
        if not bet then
            npcHandler:say("Your bet must be between ".. config.bet.min .." and ".. config.bet.max .." gold.", cid)
            return true
        end

        local number = math.random(1, 6)
        thisNpc:say(thisNpc:getName() .. " rolled a ".. number .. ".", TALKTYPE_MONSTER_SAY)
        thisNpc:getPosition():sendMagicEffect(CONST_ME_CRAPS)

        local function payPlayer(amount)
            for _, coin in pairs(createMoney(amount)) do
                player:addItem(coin[1], coin[2])
            end
        end

        if table.contains({"low", "l"}, msg) then
            if number <= 3 then
                local won = math.floor(bet * (config.bet.win / 100))
                npcHandler:say("You won ".. won .." gold coins!", cid)
                config.dicerCounter:sendMagicEffect(math.random(29, 31))
                payPlayer(won)
            else
                npcHandler:say("You lost, try again!", cid)
            end

        elseif table.contains({"high", "h"}, msg) then
            if number >= 4 then
                local won = math.floor(bet * (config.bet.win / 100))
                npcHandler:say("You won ".. won .." gold coins!", cid)
                config.dicerCounter:sendMagicEffect(math.random(29, 31))
                payPlayer(won)
            else
                npcHandler:say("No luck this time.", cid)
            end

        elseif tonumber(msg) == number then
            local won = math.floor(bet * (config.bet.winNum / 100))
            npcHandler:say("JACKPOT! You hit the number and won ".. won .." gold!", cid)
            config.dicerCounter:sendMagicEffect(CONST_ME_GIFT_WRAPS)
            payPlayer(won)
        else
            npcHandler:say("Wrong number. Better luck next time!", cid)
        end
    end
    return true
end

-- Mensagens temáticas do Karma Casino
npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Karma Casino, |PLAYERNAME|. Only the bold play here. Put your gold on the {counter}, then say {high}, {low}, or a number from 1 to 6. Payouts: 1.5x (High/Low) 3x (Exact number).")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back when luck calls.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "The dice are always rolling...")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
