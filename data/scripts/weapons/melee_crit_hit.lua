-- Melee Crit & HitChance Handler
function onGetWeaponDamage(player, target, weapon, attack, element, origin)
    if not player or not target or not weapon then
        return attack
    end

    local critChance = weapon:getCustomAttribute("CritChance") or 0
    local hitChance = weapon:getCustomAttribute("HitChance") or 100

    -- HIT CHANCE
    if math.random(1, 100) > hitChance then
        player:say("MISS!", TALKTYPE_MONSTER_SAY)
        target:getPosition():sendMagicEffect(CONST_ME_POFF)
        print("[MISS] " .. player:getName() .. " errou o hit com chance de " .. hitChance .. "%")
        return attack -- Mantém o dano original mesmo com miss
    end

    -- CRITICAL CHANCE
    if math.random(1, 100) <= critChance then
        attack = attack * 2
        player:say("CRITICAL!", TALKTYPE_MONSTER_SAY)
        target:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        print("[CRITICAL] " .. player:getName() .. " causou um crítico de " .. attack .. " de dano.")
    end

    return attack
end