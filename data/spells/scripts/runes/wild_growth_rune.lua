local combat = Combat()
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setParameter(COMBAT_PARAM_CREATEITEM, 1499)

-- Druid (2) e Elder Druid (6)
local allowedVocations = {
    [2] = true,  -- Druid
    [6] = true,  -- Elder Druid
}

function onCastSpell(creature, variant, isHotkey)
    if creature:isPlayer() then
        local vocId = creature:getVocation():getId()
        if not allowedVocations[vocId] then
            creature:sendCancelMessage("Only Druids and Elder Druids can use this rune.")
            creature:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end
    end
    return combat:execute(creature, variant)
end
