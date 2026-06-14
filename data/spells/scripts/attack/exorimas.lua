local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 35) -- Efeito visual
setCombatParam(combat, COMBAT_PARAM_USECHARGES, true)

-- Área circular (5x5 com centro)
local area = createCombatArea({
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
})
setCombatArea(combat, area)

-- Fórmula de dano
function getSpellDamage(cid, weaponSkill, weaponAttack, attackStrength)
    local hit = (getPlayerLevel(cid) * 1.5 + weaponSkill * 1.1 + weaponAttack * 1.1 + (getPlayerMagLevel(cid) + 1) / 3) * 1.61
    local damage = -math.random(hit * 0.9, hit)
    return damage, damage
end

setCombatCallback(combat, CALLBACK_PARAM_SKILLVALUE, "getSpellDamage")

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
