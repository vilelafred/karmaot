-- Spell Crit Handler
function onGetFormulaValues(player, level, maglevel)
    local critChance = player:getCustomAttribute("CritChance") or 0
    local baseMin = -(level / 5 + maglevel * 1.4 + 8)
    local baseMax = -(level / 5 + maglevel * 2.2 + 14)

    if math.random(1, 100) <= critChance then
        player:say("CRITICAL!", TALKTYPE_MONSTER_SAY)
        player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        print("[CRITICAL] " .. player:getName() .. " lançou uma spell crítica!")
        return baseMin * 2, baseMax * 2
    end

    return baseMin, baseMax
end