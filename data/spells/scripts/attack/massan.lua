local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 40) -- Efeito visual
setCombatParam(combat, COMBAT_PARAM_USECHARGES, true)

-- Área circular (5x5 com centro)
local area = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0},
})
setCombatArea(combat, area)

-- Fórmula só com Level e ML (reduzida em 20%)
function getPaladinSpellDamage(cid, level, maglevel)
    local base = (level * 2.2 + maglevel * 3.5)
    local min = -math.floor(base * 1.2)  -- 2.0 * 0.8
    local max = -math.floor(base * 1.52) -- 2.4 * 0.8
    return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "getPaladinSpellDamage")

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end
