local config = {
    bossName = "Zugurosh",
    portalPosition = Position(33234, 31337, 10),
    teleportTo = Position(33234, 31337, 10),
    portalId = 1387,
    portalDuration = 180,
    actionId = 1002
}

print("[DEBUG] ZuguroshDeathFinal script carregado!")

function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    print("[DEBUG] Evento onDeath chamado para: " .. (creature and creature:getName() or "creature inválido"))
    
    if not creature then
        print("[DEBUG] Creature é nil")
        return true
    end
    
    if creature:getName():lower() ~= config.bossName:lower() then
        print("[DEBUG] Nome do monstro não é Zugurosh: " .. creature:getName())
        return true
    end

    print("[DEBUG] Zugurosh morto! Criando portal...")

    local tile = Tile(config.portalPosition)
    if not tile then
        print("[ZuguroshDeath] Invalid tile at portal position: " .. config.portalPosition)
        return true
    end

    local portal = Game.createItem(config.portalId, 1, config.portalPosition)
    if not portal then
        print("[ZuguroshDeath] Failed to create portal with ID " .. config.portalId)
        return true
    end

    portal:setActionId(config.actionId)
    config.portalPosition:sendMagicEffect(CONST_ME_TELEPORT)
    print("[ZuguroshDeath] Portal criado com sucesso.")

    for _, spectator in pairs(Game.getSpectators(config.portalPosition, false, true, 7, 7, 7, 7)) do
        if spectator:isPlayer() then
            spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated Zugurosh! Teleport will close in 3 minutes.")
        end
    end

    addEvent(function()
        local removeTile = Tile(config.portalPosition)
        if not removeTile then
            print("[ZuguroshDeath] Falha ao remover portal: tile inválido.")
            return
        end

        local items = removeTile:getItems() or {}
        for _, i in pairs(items) do
            if i:getId() == config.portalId then
                i:remove()
                config.portalPosition:sendMagicEffect(CONST_ME_POFF)
                print("[ZuguroshDeath] Portal removido com sucesso.")
                return
            end
        end

        print("[ZuguroshDeath] Nenhum portal encontrado para remover (pode já ter sido usado).")
    end, config.portalDuration * 1000)

    return true
end 