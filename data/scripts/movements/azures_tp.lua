local teleportAction = MoveEvent()

function teleportAction.onStepIn(creature, item, position, fromPosition)
    if creature:isPlayer() then
        -- Mensagem em cima do teleport (cor laranja)
        creature:say("This portal will close in 30 seconds!", TALKTYPE_MONSTER_SAY, false, creature, position)

        -- Teleporta o player
        creature:teleportTo(Position(1320, 1104, 7))
        creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end
    return true
end

teleportAction:aid(8612)
teleportAction:register()
