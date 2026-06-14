function onStepIn(cid, item, position, fromPosition)
    if isPlayer(cid) then
        -- Mensagem em cima do teleport (cor laranja)
        doCreatureSay(cid, "This portal will close in 3 minutes!", TALKTYPE_MONSTER_SAY, false, cid, position)

        -- Teleporta o player
        doTeleportThing(cid, Position(33172, 31275, 10))
        doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
    end
    return true
end 