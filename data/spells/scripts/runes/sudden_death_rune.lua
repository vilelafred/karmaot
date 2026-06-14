local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -1.42, -29, -1.85, 0)

function onCastSpell(cid, var)
    local playerVoc = getPlayerVocation(cid)

    -- Bloqueia Knight e Elite Knight (vocações 4 e 8)
    if playerVoc == 4 or playerVoc == 8 then
        doPlayerSendCancel(cid, "Knights are not allowed to use Sudden Death runes.")
        doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
        return false
    end

    return doCombat(cid, combat, var)
end
