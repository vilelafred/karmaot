local HORARIO_BOT_STORAGE = 1000
local ATIVO_BOT_STORAGE = 1002
local TRYS_BOT_STORAGE = 1003 -- Nueva storage para intentos restantes
local WARNINGS_STORAGE = 1005 -- Storage para warnings
local WARNINGS_RESET_TIME = 1006 -- Storage para la última vez que se reiniciaron los warnings
local MAX_WARNINGS = 3 -- Máximo de warnings antes de sanción
local RESET_DAYS = 3 -- Días para restablecer los warnings

-- Tabla para almacenar captchas temporalmente
local captchaStorage = {}

-- Genera un captcha aleatorio de hasta 6 caracteres (letras y números)
local function generateCaptcha()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local captcha = ""
    for i = 1, math.random(4, 6) do
        local index = math.random(1, #charset)
        captcha = captcha .. charset:sub(index, index)
    end
    return captcha
end

-- Función para resetear warnings si ha pasado el tiempo necesario
local function resetWarnings(player)
    local lastReset = player:getStorageValue(WARNINGS_RESET_TIME)
    if lastReset == -1 or os.time() >= (lastReset + (RESET_DAYS * 24 * 60 * 60)) then
        player:setStorageValue(WARNINGS_STORAGE, 0)
        player:setStorageValue(WARNINGS_RESET_TIME, os.time())
        --print("[Anti-Bot] Warnings reset for player:", player:getName())
    end
end

local function banPlayer(player, reason)
    local accountId = player:getAccountId()
    if accountId == 0 then
        --print("[Anti-Bot] Failed to ban player:", player:getName(), "Account ID not found.")
        return false
    end

    -- Verificar si ya está baneado
    local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
    if resultId then
        result.free(resultId)
        --print("[Anti-Bot] Player already banned:", player:getName())
        return false
    end

    -- Insertar ban en la base de datos
    local banDays = 7
    local timeNow = os.time()
    db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
        accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. (timeNow + (banDays * 86400)) .. ", 0)")

    -- Remover jugador si está en línea
    local target = Player(player:getId())
    if target then
        --print("[Anti-Bot] Player banned and removed:", target:getName())
        target:remove()
    else
        --print("[Anti-Bot] Player banned but not online:", player:getName())
    end

    -- Kickear otros jugadores de la misma cuenta si están en línea
    for _, nextPlayer in pairs(Game.getPlayers()) do
        if nextPlayer:getAccountId() == accountId then
            nextPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
            nextPlayer:remove()
        end
    end

    return true
end

-- Manejo de warnings
local function handleWarnings(player, reason)
    --print("[Anti-Bot] handleWarnings called for player:", player:getName(), "Reason:", reason)

    -- Evitar warnings y baneos para jugadores administrativos
    if player:getGroup():getAccess() then
        --print("[Anti-Bot] Skipping warnings and bans for administrative player:", player:getName())
        return true
    end

    resetWarnings(player)

    local warnings = player:getStorageValue(WARNINGS_STORAGE)
    if warnings < 0 then warnings = 0 end
    warnings = warnings + 1
    player:setStorageValue(WARNINGS_STORAGE, warnings)

    --print("[Anti-Bot] Warning added for player:", player:getName(), "Total warnings:", warnings)

    if warnings >= MAX_WARNINGS then
        --print("[Anti-Bot] Player banned for reaching max warnings:", player:getName())
        banPlayer(player, "Too many warnings: " .. reason)
        return false
    end

    player:sendTextMessage(
        MESSAGE_STATUS_WARNING,
        string.format(
            "[Anti-Bot] Warning! Reason: %s. You now have %d/%d warnings. Maximum allowed before ban.",
            reason, warnings, MAX_WARNINGS
        )
    )
    return true
end

-- Verifica si el tiempo del captcha ha expirado
local function checkCaptchaTimeout(playerId)
    local player = Player(playerId)
    if not player then return end

    if player:getStorageValue(ATIVO_BOT_STORAGE) ~= 1 then return end

    local expirationTime = player:getStorageValue(HORARIO_BOT_STORAGE)
    if os.time() >= expirationTime then
        handleWarnings(player, "Failed Anti-Bot captcha (timeout).")
        player:setStorageValue(ATIVO_BOT_STORAGE, 0)
        captchaStorage[playerId] = nil
        player:sendExtendedOpcode(168, "stop")
    end
end

-- Genera un nuevo captcha Anti-Bot
local function verifyBot(player)
    local captcha = generateCaptcha()
    local playerId = player:getId()

    captchaStorage[playerId] = captcha

    player:setStorageValue(ATIVO_BOT_STORAGE, 1)
    player:setStorageValue(TRYS_BOT_STORAGE, 3)
    player:setStorageValue(HORARIO_BOT_STORAGE, os.time() + 120)

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Anti-Bot] Please solve the captcha.")
    player:sendExtendedOpcode(167, captcha .. ",120")

    addEvent(checkCaptchaTimeout, 120 * 1000, playerId)
    return true
end

-- Talkaction para enviar Anti-Bot a un jugador
local antibotCommand = TalkAction("/antibot")

function antibotCommand.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have access to this command.")
        return false
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /antibot <player_name>")
        return false
    end

    local target = Player(param)
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player not found.")
        return false
    end

    if target:getGroup():getAccess() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot use Anti-Bot on administrative players.")
        return false
    end

    if target:getStorageValue(ATIVO_BOT_STORAGE) == 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Anti-Bot is already active for this player.")
        return false
    end

    verifyBot(target)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Anti-Bot activated for " .. target:getName())
    target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Anti-Bot verification started. Check your screen.")
    return true
end

antibotCommand:separator(" ")
antibotCommand:register()

-- Talkaction para responder al Anti-Bot
local answerCommand = TalkAction("!antibot")

function answerCommand.onSay(player, words, param)
    if player:getStorageValue(ATIVO_BOT_STORAGE) ~= 1 or os.time() > player:getStorageValue(HORARIO_BOT_STORAGE) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have any Anti-Bot verification right now.")
        return false
    end

    local respondeu = param:trim()
    local playerId = player:getId()
    local resposta = captchaStorage[playerId]

    if not resposta or respondeu ~= resposta then
        local trys = player:getStorageValue(TRYS_BOT_STORAGE) - 1
        player:setStorageValue(TRYS_BOT_STORAGE, trys)

        if trys <= 0 then
            handleWarnings(player, "Failed Anti-Bot captcha (3 failed attempts).")
            player:setStorageValue(ATIVO_BOT_STORAGE, 0)
            captchaStorage[playerId] = nil
            player:sendExtendedOpcode(168, "stop")
            return false
        end

        player:sendTextMessage(MESSAGE_STATUS_WARNING, string.format(
            "[Anti-Bot] Wrong captcha. You have %d attempt%s left.",
            trys,
            trys == 1 and "" or "s"
        ))
        player:sendExtendedOpcode(168, "wrong")
        return false
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Anti-Bot System] Verification complete. Enjoy your game!")
    player:setStorageValue(ATIVO_BOT_STORAGE, 0)
    player:setStorageValue(TRYS_BOT_STORAGE, 0)
    captchaStorage[playerId] = nil
    player:sendExtendedOpcode(168, "stop")
    return false
end

answerCommand:separator(" ")
answerCommand:register()

-- Evento para prevenir logout durante Anti-Bot
local AntiBotDisableLogout = CreatureEvent("AntiBotDisableLogout")

function AntiBotDisableLogout.onLogout(player)
    if player:getStorageValue(ATIVO_BOT_STORAGE) == 1 then
        player:sendCancelMessage("You cannot logout while you are in the Anti-Bot event.")
        return false
    end
    return true
end

AntiBotDisableLogout:type("logout")
AntiBotDisableLogout:register()