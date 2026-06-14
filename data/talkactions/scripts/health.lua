function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: /health <player_name>, <amount>\nExemplo: /health Teste Knight, -1000 (dano)\nExemplo: /health Teste Knight, 1000 (cura)")
        return false
    end

    local params = param:split(',')
    if not params[2] then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: /health <player_name>, <amount>\nExemplo: /health Teste Knight, -1000 (dano)\nExemplo: /health Teste Knight, 1000 (cura)")
        return false
    end

    local targetName = params[1]:trim()
    local amount = tonumber(params[2]:trim())
    
    if not amount then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Amount must be a number!\nExemplo: /health Teste Knight, -1000")
        return false
    end

    local target = Player(targetName)
    if not target then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Player '" .. targetName .. "' is not online.")
        return false
    end

    local currentHealth = target:getHealth()
    local maxHealth = target:getMaxHealth()
    
    if amount > 0 then
        -- Cura (valor positivo)
        target:addHealth(amount)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Healed " .. target:getName() .. " for " .. amount .. " HP.")
        target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were healed for " .. amount .. " HP by " .. player:getName() .. ".")
        target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    else
        -- Dano (valor negativo)
        local damage = math.abs(amount)
        doTargetCombatHealth(0, target:getId(), COMBAT_PHYSICALDAMAGE, -damage, -damage, CONST_ME_EXPLOSIONHIT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Dealt " .. damage .. " damage to " .. target:getName() .. ".")
        target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. damage .. " damage from " .. player:getName() .. ".")
    end

    return false
end
