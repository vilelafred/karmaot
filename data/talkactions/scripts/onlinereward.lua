local STORAGE_OPT_IN = 73107

function onSay(player, words, param)
    local current = player:getStorageValue(STORAGE_OPT_IN)
    local enable = true

    param = param and param:lower() or ""
    if param == "on" then
        enable = true
    elseif param == "off" then
        enable = false
    else
        -- toggle se não houver param
        enable = (current ~= 1)
    end

    player:setStorageValue(STORAGE_OPT_IN, enable and 1 or 0)
    if enable then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Online-time rewards enabled. You will receive Christmas Tokens while online.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Online-time rewards disabled.")
    end
    return false
end


