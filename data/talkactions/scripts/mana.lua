function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: /mana <player_name>, <amount>\nExemplo: /mana Teste Knight, -1000 (dreno)\nExemplo: /mana Teste Knight, 1000 (restaurar)")
        return false
    end

    local params = param:split(',')
    if not params[2] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: /mana <player_name>, <amount>\nExemplo: /mana Teste Knight, -1000 (dreno)\nExemplo: /mana Teste Knight, 1000 (restaurar)")
        return false
    end

    local targetName = params[1]:trim()
    local amount = tonumber(params[2]:trim())

    if not amount then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Amount must be a number!\nExemplo: /mana Teste Knight, -1000")
        return false
    end

    local target = Player(targetName)
    if not target then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Player '" .. targetName .. "' is not online.")
        return false
    end

    if amount > 0 then
        -- Restaurar mana (valor positivo)
        target:addMana(amount)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Restored " .. amount .. " MP to " .. target:getName() .. ".")
        target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were restored " .. amount .. " MP by " .. player:getName() .. ".")
        target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    else
        -- Drenar mana (valor negativo)
        local drain = math.abs(amount)
        doTargetCombatMana(0, target, -drain, -drain, CONST_ME_PURPLEENERGY)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Drained " .. drain .. " MP from " .. target:getName() .. ".")
        target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You lost " .. drain .. " MP due to " .. player:getName() .. ".")
    end

    return false
end
