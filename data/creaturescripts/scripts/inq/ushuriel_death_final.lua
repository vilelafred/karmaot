local config = {
    bossName = "Ushuriel",
    portalPosition = Position(33264, 31340, 10),
    teleportTo = Position(33264, 31340, 10),
    portalId = 1387,
    portalDuration = 180,
    actionId = 1001
}

print("[DEBUG] UshurielDeathFinal script carregado!")

function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    print("[DEBUG] Evento onDeath chamado para: " .. (creature and creature:getName() or "creature inválido"))
    
    if not creature then
        print("[DEBUG] Creature é nil")
        return true
    end
    
    if creature:getName():lower() ~= config.bossName:lower() then
        print("[DEBUG] Nome do monstro não é Ushuriel: " .. creature:getName())
        return true
    end

    print("[DEBUG] Ushuriel morto! Criando portal...")

    local tile = Tile(config.portalPosition)
    if not tile then
        print("[UshurielDeath] Invalid tile at portal position: " .. config.portalPosition)
        return true
    end

    local portal = Game.createItem(config.portalId, 1, config.portalPosition)
    if not portal then
        print("[UshurielDeath] Failed to create portal with ID " .. config.portalId)
        return true
    end

    portal:setActionId(config.actionId)
    config.portalPosition:sendMagicEffect(CONST_ME_TELEPORT)
    print("[UshurielDeath] Portal criado com sucesso.")

    for _, spectator in pairs(Game.getSpectators(config.portalPosition, false, true, 7, 7, 7, 7)) do
        if spectator:isPlayer() then
            spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated Ushuriel! Teleport will close in 3 minutes.")
        end
    end

    addEvent(function()
        local removeTile = Tile(config.portalPosition)
        if not removeTile then
            print("[UshurielDeath] Falha ao remover portal: tile inválido.")
            return
        end

        local items = removeTile:getItems() or {}
        for _, i in pairs(items) do
            if i:getId() == config.portalId then
                i:remove()
                config.portalPosition:sendMagicEffect(CONST_ME_POFF)
                print("[UshurielDeath] Portal removido com sucesso.")
                return
            end
        end

        print("[UshurielDeath] Nenhum portal encontrado para remover (pode já ter sido usado).")
    end, config.portalDuration * 1000)

    return true
end 