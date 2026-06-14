local config = {
    bossName = "Azerus",
    portalPosition = Position(1325, 1064, 10),
    teleportTo = Position(1320, 1104, 7),
    portalId = 1387,
    portalDuration = 30,
    storageDone = 59124
}

print("[DEBUG] AzerusDeath script carregado!")

function onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    print("[DEBUG] Evento onDeath chamado para: " .. (creature and creature:getName() or "creature inválido"))
    
    if not creature then
        print("[DEBUG] Creature é nil")
        return true
    end
    
    if creature:getName():lower() ~= config.bossName:lower() then
        print("[DEBUG] Nome do monstro não é Azerus: " .. creature:getName())
        return true
    end

    print("[DEBUG] Azerus morto! Criando portal...")

    local tile = Tile(config.portalPosition)
    if not tile then
        print("[AzerusDeath] Invalid tile at portal position: " .. config.portalPosition)
        return true
    end

    local portal = Game.createItem(config.portalId, 1, config.portalPosition)
    if not portal then
        print("[AzerusDeath] Failed to create portal with ID " .. config.portalId)
        return true
    end

    portal:setActionId(8612)
    config.portalPosition:sendMagicEffect(CONST_ME_TELEPORT)
    print("[AzerusDeath] Portal criado com sucesso.")

    for _, spectator in pairs(Game.getSpectators(config.portalPosition, false, true, 7, 7, 7, 7)) do
        if spectator:isPlayer() then
            spectator:setStorageValue(config.storageDone, 1)
            spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have defeated Azerus and may not face him again.")
        end
    end

    addEvent(function()
        local removeTile = Tile(config.portalPosition)
        if not removeTile then
            print("[AzerusDeath] Falha ao remover portal: tile inválido.")
            return
        end

        local items = removeTile:getItems() or {}
        for _, i in pairs(items) do
            if i:getId() == config.portalId then
                i:remove()
                config.portalPosition:sendMagicEffect(CONST_ME_POFF)
                print("[AzerusDeath] Portal removido com sucesso.")
                return
            end
        end

        print("[AzerusDeath] Nenhum portal encontrado para remover (pode já ter sido usado).")
    end, config.portalDuration * 1000)

    return true
end
