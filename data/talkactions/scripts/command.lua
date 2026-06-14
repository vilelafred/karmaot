-- Script: commands.lua
-- Place this script in the 'data/scripts/custom' folder of your server

local COMMAND_COOLDOWN = 3 -- Tempo de espera em segundos

function onSay(player, words, param)
    local lastCommandTime = player:getStorageValue(1002) -- Armazenamento para controlar o cooldown

    if os.time() - lastCommandTime >= COMMAND_COOLDOWN then
        if words:lower() == "!commands" then
            local message = "Available Commands:\n"
            message = message .. "!emote - Turn ON/OFF emote spells text\n"
            message = message .. "!share - Turn ON/OFF shared exp\n"
            message = message .. "!buyhouse - Face a door house to buy it\n"
            message = message .. "!leavehouse - All your items go to your depot\n"
            message = message .. "!kills - Check your current frags\n"
            message = message .. "!serverinfo - Check server rates\n"
            message = message .. "!bonus - Check remaining time of bonus exp scrolls\n"
            message = message .. "/pos - Check your position on the map.\n"
            message = message .. "!autoloot - Informations about auto-looting system.\n\n"
            message = message .. "Auto-Loot Commands:\n"
            message = message .. "!autoloot add, itemName - Add item to auto loot by name\n"
            message = message .. "!autoloot remove, itemName - Remove item from auto loot by name\n"
            message = message .. "!autoloot list - List your current auto loot items\n\n"
            message = message .. "!bp - Use this command to buy a random color backpack for 50gps."

            local letterItem = player:addItem(1952, 1) -- Pode ser necessário ajustar o ID do item da carta
            if letterItem then
                letterItem:setAttribute(ITEM_ATTRIBUTE_TEXT, message)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have received a letter with server commands.")
            else
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Error creating letter. Please contact an administrator.")
            end

            player:setStorageValue(1002, os.time()) -- Atualiza o tempo do último comando
            return false
        end
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Please wait " .. COMMAND_COOLDOWN .. " seconds before using this command again.")
    end

    return true
end
