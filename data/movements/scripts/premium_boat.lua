-- by Nottinghster

function onStepIn(cid, item, pos)
    if isPremium(cid) == false then
        pos.y = pos.y - 1
        doTeleportThing(cid, pos)
        doSendMagicEffect(getPlayerPosition(cid), 3)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You need to become a premium account.")
    else
        doPlayerSendCancel(cid, "")
    end
    
    return true
end
