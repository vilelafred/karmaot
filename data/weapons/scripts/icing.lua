local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_BLOCKARMOR, 1)
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 44)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, 35)

-- Área 3x3 igual burst arrow
local area = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0}
})
setCombatArea(combat, area)

-- Fórmula com base no SKILL_DISTANCE
function onGetFormulaValues(cid, level, skill)
    local min = -((skill * 1.8) + (level * 1.4)) * 2.2
    local max = -((skill * 1.8) + (level * 1.4)) * 1.8
    return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onUseWeapon(cid, var)
    return doCombat(cid, combat, var)
end
