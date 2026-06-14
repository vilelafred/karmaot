local config = {
    ['exp'] = {name = "experience", timeKey = 17589},
    ['skill'] = {name = "skill", timeKey = 17590},
    ['magic'] = {name = "magic", timeKey = 17591}
}

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return hours .. "h " .. minutes .. "m " .. secs .. "s"
end

function onSay(player, words, param)
    if not param or param:trim() == "" then
        player:sendCancelMessage("Use: !checkrate exp | skill | magic")
        return false
    end

    local skillName = param:lower():trim()
    local info = config[skillName]

    if not info then
        player:sendCancelMessage("Use: !checkrate exp | skill | magic")
        return false
    end

    local boostEndsAt = getGlobalStorageValue(info.timeKey)
    local now = os.time()

    if boostEndsAt <= 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum registro encontrado para " .. info.name .. " boost.")
        return false
    end

    if boostEndsAt > now then
        local remaining = boostEndsAt - now
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Boost de " .. info.name .. " ATIVO por mais: " .. formatTime(remaining))
    else
        local expiredSince = now - boostEndsAt
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Boost de " .. info.name .. " EXPIRADO há: " .. formatTime(expiredSince))
    end

    return false
end
