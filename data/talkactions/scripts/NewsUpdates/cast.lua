function onSay(player, words, param)
local split = param:split(",")
if param == "on" or split[1] == "on" then
local pass = split[2] and split[2]:gsub("%s+", "", 1) or nil
    if player:startLiveCast(pass) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have started casting your gameplay. Commands: !cast off - !cast spectators")
    else
        player:sendCancelMessage("You're already casting your gameplay.")
    end
elseif param == "off" then
    if player:stopLiveCast() then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have stopped casting your gameplay.")
    else
        player:sendCancelMessage("You're not casting your gameplay.")
    end
elseif param == "spectators" then
    local spectators, anonymous = player:getSpectators()
    if spectators then
        local message = ""
        if #spectators > 0 then
        message = "Known Spectators:\n"
        for i=1, #spectators do
        if not i == 1 then
        message = message .. ", "
        end
        message = message .. "" .. spectators[i]
        if i == #spectators then
        message = message .. ".\n"
        end
        end
        end        
        message = message .. "Anonymous Spectators : "..anonymous
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
    else
        player:sendCancelMessage("You're not casting your gameplay.")
    end
    end
    return false
end