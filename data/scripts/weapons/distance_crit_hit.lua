-- Distance Crit & HitChance Handler
function onGetPlayerSkillDamage(player, target, skill, attack, element, origin)
    local weapon = player:getSlotItem(CONST_SLOT_LEFT) or player:getSlotItem(CONST_SLOT_RIGHT)
    if not weapon then return attack end

    local critChance = weapon:getCustomAttribute("CritChance") or 0
    local hitChance = weapon:getCustomAttribute("HitChance") or 100

    if math.random(1, 100) > hitChance then
        player:say("MISS!", TALKTYPE_MONSTER_SAY)
        target:getPosition():sendMagicEffect(CONST_ME_POFF)
        print("[MISS] " .. player:getName() .. " errou o hit à distância com chance de " .. hitChance .. "%")
        return attack
    end

    if math.random(1, 100) <= critChance then
        attack = attack * 2
        player:say("CRITICAL!", TALKTYPE_MONSTER_SAY)
        target:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
        print("[CRITICAL] " .. player:getName() .. " causou um crítico de " .. attack .. " de dano à distância.")
    end

    return attack
end