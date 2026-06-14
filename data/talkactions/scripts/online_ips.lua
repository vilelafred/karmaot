local maxPlayersPerMessage = 15

function onSay(player, words, param)
    local players = Game.getPlayers()
    local lines = {}

    for _, target in ipairs(players) do
        local ip = target:getIp()
        local ipStr = ip ~= 0 and Game.convertIpToString(ip) or "0.0.0.0"
        -- Monta: Name [Level] - IP
        lines[#lines + 1] = ("%s [%d] - %s"):format(target:getName(), target:getLevel(), ipStr)
    end

    table.sort(lines)

    local total = #lines
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, ("%d players online."):format(total))

    -- Envia em blocos, cada linha quebrada com \n
    for i = 1, total, maxPlayersPerMessage do
        local j = math.min(i + maxPlayersPerMessage - 1, total)
        local msg = table.concat(lines, "\n", i, j)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
    end

    return false
end


