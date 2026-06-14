function onSay(cid, words, param, channel)

    if getPlayerStorageValue(cid, 95029) > os.time() then
        doPlayerSendCancel(cid, "You are exhausted.")
        return false
    else
        setPlayerStorageValue(cid, 95029, os.time() + 2)
    end

    local stoRuby = 95030
    local levelPlayer = getPlayerLevel(cid)

    function msgFailedRuby()
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need a rooker vocation and the minimum level is 5.")
        doSendMagicEffect(getCreaturePosition(cid), 3)
        return false
    end

    local playerVoc = getPlayerVocation(cid)

    if playerVoc == 0 and levelPlayer >= 5 then
        if getPlayerStorageValue(cid, stoRuby) == 1 then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUBY] Command has been disabled.")
            setPlayerStorageValue(cid, stoRuby, 0)
            doSendMagicEffect(getCreaturePosition(cid), 14)
            return false
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUBY] Command activated! When you are sleeping you will be make rooker rubys.")
            setPlayerStorageValue(cid, stoRuby, 1)
            doSendMagicEffect(getCreaturePosition(cid), 15)
            return false
        end
    else
        msgFailedRuby()
        return false
    end
end
