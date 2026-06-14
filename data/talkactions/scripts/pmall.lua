function onSay(player, words, param)
    if not player:hasFlag(PlayerFlag_CanBroadcast) then
        return true
    end

    param = param and param:trim() or ""
    if param == "" then
        player:sendCancelMessage("Usage: /pmall <message>")
        return false
    end

    local sent = 0
    for _, target in ipairs(Game.getPlayers()) do
        if target ~= player then
            target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, param)
            sent = sent + 1
        end
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, "PM sent to " .. sent .. " player(s).")
    return false
end


