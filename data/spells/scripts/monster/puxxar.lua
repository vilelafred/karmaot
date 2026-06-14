local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 12)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -75.0, 0, -100.0, 0)

local arr = {{1}, {1}, {1}, {1}, {1}, {1}, {3}}

local area = createCombatArea(arr)
setCombatArea(combat, area)

function onTarget(cid, target)
   if isMonster(target) or isPlayer(target) then
      local distance = getDistanceBetween(getThingPos(cid), getThingPos(target))
      distance = math.max(1, distance + 3)
      local min = distance * 300 - math.random(50)
      local max = min + math.random(getPlayerLevel(cid))
      local teleportpos = getPosByDir(getThingPos(cid), getCreatureLookDir(cid), distance)
      doTeleportThing(target, teleportpos, false)
      doTargetCombatHealth(cid, target, COMBAT_PHYSICALDAMAGE, -min, -max, 255)
  end
end 

setCombatCallback(combat, CALLBACK_PARAM_TARGETCREATURE, "onTarget")

function onCastSpell(cid, var)
local pos1 = {x = getPlayerPosition(cid).x + 1, y = getPlayerPosition(cid).y + 1, z = getPlayerPosition(cid).z}
doSendMagicEffect(pos1, 54)
return doCombat(cid, combat, var)

end