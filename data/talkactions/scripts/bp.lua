-- Script: add_bp.lua
-- Place this script in the 'data/scripts/custom' folder of your server

function onSay(player, words, param)
    if words:lower() == "!bp" then
        local cost = 50
        local exhaustedTime = 3 -- in seconds

        if player:getMoney() >= cost then
            if player:getStorageValue(1001) <= os.time() then
                player:removeMoney(cost)
                
                -- Choose a random backpack ID between 1998 and 2004
                local backpackID = math.random(1998, 2004)
                
                player:addItem(backpackID, 1)
                player:setStorageValue(1001, os.time() + exhaustedTime)
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You bought a backpack for " .. cost .. " gps.")
            else
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are exhausted. Wait " .. exhaustedTime .. " seconds to buy another backpack.")
            end
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You do not have enough money to buy a backpack.")
        end
        return false
    end
    return true
end
