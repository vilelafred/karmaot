dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    local msgLower = msg:lower()
    if (npcHandler.focus ~= cid) and not msgcontains(msgLower, 'bring me to') then
        return false
    end

    local player = Player(cid)

    -- allow direct command: "bring me to thais/svargrond" with bank+bp
    if msgcontains(msgLower, 'bring me to') then
        local bringExhaust = 159322
        local now = os.time()
        if getPlayerStorageValue(cid, bringExhaust) > now then
            local remaining = getPlayerStorageValue(cid, bringExhaust) - now
            npcHandler:say("You must wait " .. remaining .. " second(s) before using the 'bring me to' shortcut again.", cid)
            return true
        end
        setPlayerStorageValue(cid, bringExhaust, now + 20)
        if msgcontains(msgLower, 'thais') then
            local cost = 280
            if player then
                local totalMoney = player:getMoney() + player:getBankBalance()
                if totalMoney < cost then
                    npcHandler:say("You don't have enough money for Thais.")
                else
                    local fromInventory = math.min(player:getMoney(), cost)
                    local fromBank = cost - fromInventory
                    if fromInventory > 0 then
                        player:removeMoney(fromInventory)
                    end
                    if fromBank > 0 then
                        player:setBankBalance(player:getBankBalance() - fromBank)
                    end

                    local usedText = "You have used"
                    if fromInventory > 0 then
                        usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
                    end
                    if fromBank > 0 then
                        if fromInventory > 0 then
                            usedText = usedText .. " and"
                        end
                        usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
                    end
                    usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
                    player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                    npcHandler:say('Have a nice trip to Thais!')
                    player:getPosition():sendMagicEffect(11)
                    player:teleportTo({x = 32312, y = 32210, z = 6})
                    player:getPosition():sendMagicEffect(11)
                    talk_state = 0
                end
            else
                npcHandler:say("You don't have enough money for Thais.")
            end
            return true
        elseif msgcontains(msgLower, 'svargrond') then
            local cost = 380
            if player then
                local totalMoney = player:getMoney() + player:getBankBalance()
                if totalMoney < cost then
                    npcHandler:say("You don't have enough money for Svargrond.")
                else
                    local fromInventory = math.min(player:getMoney(), cost)
                    local fromBank = cost - fromInventory
                    if fromInventory > 0 then
                        player:removeMoney(fromInventory)
                    end
                    if fromBank > 0 then
                        player:setBankBalance(player:getBankBalance() - fromBank)
                    end

                    local usedText = "You have used"
                    if fromInventory > 0 then
                        usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
                    end
                    if fromBank > 0 then
                        if fromInventory > 0 then
                            usedText = usedText .. " and"
                        end
                        usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
                    end
                    usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
                    player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                    npcHandler:say('Have a nice trip to Svargrond!')
                    player:getPosition():sendMagicEffect(11)
                    player:teleportTo({x = 32386, y = 30604, z = 6})
                    player:getPosition():sendMagicEffect(11)
                    talk_state = 0
                end
            else
                npcHandler:say("You don't have enough money for Svargrond.")
            end
            return true
        end
    end

    if msgcontains(msgLower, 'travel') then
        npcHandler:say('Friends of Karma are my friends too! Are you looking for a passage back to Thais for 280 gold, or would you like to go to Svargrond for 380 gold?')
        talk_state = 1

    elseif msgcontains(msgLower, 'thais') and (talk_state == 1 or talk_state == nil or talk_state == 0) then
        npcHandler:say('Do you want to go to Thais for 280 gold coins?')
        talk_state = 11

    elseif msgcontains(msgLower, 'svargrond') and (talk_state == 1 or talk_state == nil or talk_state == 0) then
        npcHandler:say('Do you want to go to Svargrond for 380 gold coins?')
        talk_state = 12

    elseif msgcontains(msgLower, 'yes') and talk_state == 11 then
        local cost = 280
        if player then
            local totalMoney = player:getMoney() + player:getBankBalance()
            if totalMoney < cost then
                npcHandler:say('You don\'t have enough money for Thais.')
            else
                local fromInventory = math.min(player:getMoney(), cost)
                local fromBank = cost - fromInventory
                if fromInventory > 0 then
                    player:removeMoney(fromInventory)
                end
                if fromBank > 0 then
                    player:setBankBalance(player:getBankBalance() - fromBank)
                end

                local usedText = "You have used"
                if fromInventory > 0 then
                    usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
                end
                if fromBank > 0 then
                    if fromInventory > 0 then
                        usedText = usedText .. " and"
                    end
                    usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
                end
                usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
                player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                npcHandler:say('Have a nice trip to Thais!')
                player:getPosition():sendMagicEffect(11)
                player:teleportTo({x = 32312, y = 32210, z = 6})
                player:getPosition():sendMagicEffect(11)
            end
        end
        talk_state = 0

    elseif msgcontains(msgLower, 'yes') and talk_state == 12 then
        local cost = 380
        if player then
            local totalMoney = player:getMoney() + player:getBankBalance()
            if totalMoney < cost then
                npcHandler:say('You don\'t have enough money for Svargrond.')
            else
                local fromInventory = math.min(player:getMoney(), cost)
                local fromBank = cost - fromInventory
                if fromInventory > 0 then
                    player:removeMoney(fromInventory)
                end
                if fromBank > 0 then
                    player:setBankBalance(player:getBankBalance() - fromBank)
                end

                local usedText = "You have used"
                if fromInventory > 0 then
                    usedText = usedText .. " " .. fromInventory .. " gold coin(s) from your backpack"
                end
                if fromBank > 0 then
                    if fromInventory > 0 then
                        usedText = usedText .. " and"
                    end
                    usedText = usedText .. " " .. fromBank .. " gold coin(s) from your bank account"
                end
                usedText = usedText .. ". Your current bank balance is " .. player:getBankBalance() .. " gold coin(s)."
                player:sendTextMessage(MESSAGE_INFO_DESCR, usedText)

                npcHandler:say('Have a nice trip to Svargrond!')
                player:getPosition():sendMagicEffect(11)
                player:teleportTo({x = 32386, y = 30604, z = 6})
                player:getPosition():sendMagicEffect(11)
            end
        end
        talk_state = 0

    elseif msgcontains(msgLower, 'no') and (talk_state == 11 or talk_state == 12) then
        npcHandler:say('Maybe another time.')
        talk_state = 0

    else
        npcHandler:say('I can only take you to Thais or Svargrond. Please, be polite ask me "TRAVEL" first and choose one.')
        talk_state = 0
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
