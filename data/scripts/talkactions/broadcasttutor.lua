-- Tutor Broadcast (somente TUTOR) — TFS 1.5 (Nekiro)
-- Comando: /tb <mensagem>
-- Adiciona automaticamente o prefixo "[Tutor Broadcast] " (sem duplicar)

local talk = TalkAction("/tb")
talk:separator(" ")

local AT_TUTOR = rawget(_G, "ACCOUNT_TYPE_TUTOR") or 2
local PREFIX   = "[Tutor Broadcast] "

local function hasPrefix(s)
    local trimmed = s:gsub("^%s+", "")
    return trimmed:sub(1, #PREFIX):lower() == PREFIX:lower()
end

local function doTutorBroadcast(fromPlayer, msg)
    local list = Game.getPlayers() or {}
    for _, target in ipairs(list) do
        target:sendPrivateMessage(fromPlayer, msg, TALKTYPE_BROADCAST) -- vermelho
    end
end

function talk.onSay(player, words, param)
    if player:getAccountType() ~= AT_TUTOR then
        player:sendCancelMessage("Only Tutors can use this command.")
        return false
    end

    local msg = tostring(param or ""):gsub("^%s+", "")
    if not msg:match("%S") then
        player:sendCancelMessage("Usage: " .. words .. " <message>")
        return false
    end

    -- adiciona prefixo se o tutor não tiver escrito manualmente
    local finalMsg = hasPrefix(msg) and msg or (PREFIX .. msg)

    print(string.format('[Tutor Broadcast] %s: "%s"', player:getName(), finalMsg))
    doTutorBroadcast(player, finalMsg)
    return false
end

talk:register()
