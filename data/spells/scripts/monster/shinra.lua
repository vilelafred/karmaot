local tarmonster = true -- Can we cast this spell on monsters. Default is true
local ptime = 8000 -- This is how long the spell will last on a Player. Default is 8 seconds = 8000
local mtime = 10000 -- This is how long the spell will last on a Monster. Default is 10 seconds = 10000

local pcombat = createCombatObject()
setCombatParam(pcombat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
setCombatParam(pcombat, COMBAT_PARAM_AGGRESSIVE, true)
local pcondition = createConditionObject(CONDITION_MUTED)
setConditionParam(pcondition, CONDITION_PARAM_TICKS, ptime)
setCombatCondition(pcombat, pcondition)

local mcombat = createCombatObject()
setCombatParam(mcombat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
setCombatParam(mcombat, COMBAT_PARAM_AGGRESSIVE, true)
local mcondition = createConditionObject(CONDITION_MUTED)
setConditionParam(mcondition, CONDITION_PARAM_TICKS, mtime)
setCombatCondition(mcombat, mcondition)

function onCastSpell(cid, var)
local creature = Creature(cid)
local tar = creature:getTarget()

    if tar:getCondition(CONDITION_MUTED) then
            creature:sendTextMessage(MESSAGE_STATUS_SMALL, "This creature is already muted")
        return false
    end
     if tar:isPlayer() == true then
        tar:say("^SILENCED^",TALKTYPE_MONSTER_SAY)
        doCombat(tar, pcombat, var)
        return true
     end
    if tar:isMonster() == true then
        if(tarmonster == true) then
        tar:say("^SILENCED^",TALKTYPE_MONSTER_SAY)
        doCombat(tar, mcombat, var)
        return true
        else
        creature:sendTextMessage(MESSAGE_STATUS_SMALL, "You can only use this spell on Players.")
        end
     end
end