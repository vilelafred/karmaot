function onUse(cid, item, frompos, item2, topos)
    local requiredLevel = 20
    local cooldownStorage = 11542
    local dummyStoragePrefix = 11552  -- Prefixo para storages individuais de cada dummy
    local dummyCreatureID = getPlayerStorageValue(cid, "dummyCreatureID")
    local dummyStorage = dummyStoragePrefix + getPlayerGUID(cid)  -- Corrigido para usar getPlayerGUID

    if getPlayerLevel(cid) < requiredLevel then
        doPlayerSendCancel(cid, "You need to be at least level " .. requiredLevel .. " to use this item.")
        return true
    end

    local dummyPosition = getCreaturePosition(cid)

    -- Verifica se a posição do jogador é uma Protection Zone
    if getTilePzInfo(dummyPosition) then
        doPlayerSendCancel(cid, "You cannot create or remove a dummy in a Protection Zone.")
        return true
    end

    if dummyCreatureID and isCreature(dummyCreatureID) then
        -- Dummy presente, verificar se o jogador é o mesmo que comprou o item
        local lastUsageTime = getPlayerStorageValue(cid, cooldownStorage) or 0
        local elapsedTime = os.time() - lastUsageTime

        if elapsedTime < 15 then
            local remainingTime = 15 - elapsedTime
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You can only remove the dummy again in " .. remainingTime .. " seconds.")
            return true
        end

        doRemoveCreature(dummyCreatureID)
        setPlayerStorageValue(cid, "dummyCreatureID", 0)
        doRemoveItem(item.uid, 1)  -- Remover o item ao usar
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Dummy removed.")
        doSendMagicEffect(dummyPosition, 11)  -- Adiciona o efeito mágico após remover o dummy
        setPlayerStorageValue(cid, cooldownStorage, os.time())

    else
        local lastUsageTime = getPlayerStorageValue(cid, cooldownStorage) or 0
        local elapsedTime = os.time() - lastUsageTime

        if elapsedTime < 15 then
            local remainingTime = 15 - elapsedTime
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You can only create a dummy again in " .. remainingTime .. " seconds.")
            return true
        end

        local totalCooldownTime = 2 * 60 * 60  -- 2 horas em segundos
        local lastDummyCreationTime = getPlayerStorageValue(cid, dummyStorage) or 0
        local timeSinceLastCreation = os.time() - lastDummyCreationTime

        if timeSinceLastCreation < totalCooldownTime then
            local remainingCooldown = totalCooldownTime - timeSinceLastCreation
            local remainingHours = math.floor(remainingCooldown / 3600)
            local remainingMinutes = math.floor((remainingCooldown % 3600) / 60)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You can only create a new Training Dummy after " .. remainingHours .. " hours and " .. remainingMinutes .. " minutes.")
            return true
        end

        local dummyCreature = doSummonCreature("Dummy", dummyPosition)

        if dummyCreature ~= 0 then
            setPlayerStorageValue(cid, "dummyCreatureID", dummyCreature)
            doCreatureSay(cid, "Dummy, GO!", TALKTYPE_ORANGE_1)
            doSendMagicEffect(dummyPosition, 2)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Dummy summoned.")
            setPlayerStorageValue(cid, cooldownStorage, os.time())
            setPlayerStorageValue(cid, dummyStorage, os.time())  -- Armazena o tempo da criação da dummy
            addEvent(function()
                setPlayerStorageValue(cid, cooldownStorage, 0)  -- Reseta o cooldown
            end, 15000)  -- Agendando o próximo uso após 15 segundos
            doRemoveItem(item.uid, 1)  -- Remover o item ao usar
        else
            print("Error creating dummy creature.")
        end
    end

    return true
end
