function onSay(cid, words, param)
    local lookType = tonumber(param)
    if not lookType then
        doPlayerSendCancel(cid, "Uso correto: !setoutfit [looktype id]")
        return true
    end

    local outfit = getCreatureOutfit(cid)
    outfit.lookType = lookType
    doCreatureChangeOutfit(cid, outfit)

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Outfit alterado para ID: " .. lookType)
    return true
end
