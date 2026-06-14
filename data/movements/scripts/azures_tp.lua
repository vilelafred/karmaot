function onStepIn(cid, item, position, fromPosition)
    if not isPlayer(cid) then
        return true
    end

    -- Apenas permita o teleporte se houver um portal (item 1387) na tile
    local tile = Tile(position)
    local hasPortal = false
    if tile then
        local items = tile:getItems() or {}
        for _, it in pairs(items) do
            if it:getId() == 1387 then
                hasPortal = true
                break
            end
        end
    end

    if not hasPortal then
        return true
    end

    -- Mensagem em cima do teleport (cor laranja)
    doCreatureSay(cid, "This portal will close in 30 seconds!", TALKTYPE_MONSTER_SAY, false, cid, position)

    -- Teleporta o player
    doTeleportThing(cid, Position(1320, 1104, 7))
    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
    return true
end
