local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 40) -- Efeito visual
setCombatParam(combat, COMBAT_PARAM_USECHARGES, true)

-- Área 9x9 (maior que Gran Mas San)
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

-- Fórmula com 55% do dano original
function getPaladinSpellDamageArea(cid, level, maglevel)
    local base = (level * 2.2 + maglevel * 3.5)
    local min = -math.floor(base * 0.8)  -- 2.0 * 0.55
    local max = -math.floor(base * 1.0) -- 2.4 * 0.55
    return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "getPaladinSpellDamageArea")

function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end

