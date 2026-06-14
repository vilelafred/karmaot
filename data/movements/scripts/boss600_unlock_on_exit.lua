function onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return false
    end

    -- Ao pisar no teleporte de saída, garantimos a storage do atalho
    local storageKey = 60600
    if creature:getStorageValue(storageKey) < 1 then
        creature:setStorageValue(storageKey, 1)
        creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have unlocked the Boss Infernal Dreadlord shortcut.")
    end
    return true
end


