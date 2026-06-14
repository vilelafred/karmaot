local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SNOWBALL)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)

local condition = createConditionObject(CONDITION_ATTRIBUTES)
	setConditionParam(condition, CONDITION_PARAM_TICKS, 8000)
	setConditionParam(condition, CONDITION_PARAM_SKILL_DISTANCEPERCENT, 90)
	setConditionParam(condition, CONDITION_PARAM_SKILL_SHIELDPERCENT, 90)
	setConditionParam(condition, CONDITION_PARAM_SKILL_MELEEPERCENT, 90)
	setConditionParam(condition, CONDITION_PARAM_SKILL_FISTPERCENT, 90)
	setCombatCondition(combat, condition)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end