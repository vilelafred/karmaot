-- nekiro/data/scripts/karma_ticket_log.lua

local karmaTicket = Action()

function karmaTicket.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Informações do player
    local playerName = player:getName()
    local accountId = player:getAccountId()
    local playerIp = player:getIp()
    local playerLevel = player:getLevel()
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    -- LOG COMPLETO
    local logMessage = string.format(
        "[KARMA TICKET] %s | Player: %s (Account: %d, Level: %d, IP: %s) usou Karma Ticket +100 points",
        timestamp, playerName, accountId, playerLevel, convertIpToString(playerIp)
    )
    
    -- Salvar no console do servidor
    print(logMessage)
    
    -- Salvar em arquivo de log
    local file = io.open("data/logs/karma_ticket_usage.log", "a")
    if file then
        file:write(logMessage .. "\n")
        file:close()
    end
    
    -- Dar os 100 premium points
    player:addPremiumPoints(100)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received 100 premium points!")
    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
    
    -- Remover o item
    item:remove(1)
    return true
end

karmaTicket:id(6836)
karmaTicket:register()