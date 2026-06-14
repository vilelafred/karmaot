function onUse(cid, item, fromPosition, itemEx, toPosition)
    local destination = {x = 33238, y = 32052, z = 11}
    local leverUID = 9999

    if item.uid ~= leverUID then
        return false
    end

    doTeleportThing(cid, destination)
    doSendMagicEffect(destination, CONST_ME_TELEPORT)
    doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have been teleported.")

    return true
end
