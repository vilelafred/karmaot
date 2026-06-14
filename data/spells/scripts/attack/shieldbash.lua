local checkWeaponSlots = {
    CONST_SLOT_LEFT,
    CONST_SLOT_RIGHT
}

local combat = Combat()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
    combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
    combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOCKHIT)

function stunAnimation(stunnedcreature, stunnedpos, counter)
    if counter ~= 0 and Creature(stunnedcreature) then
        stunnedpos:sendMagicEffect(CONST_ME_STUN)
        counter = counter - 1
        addEvent(stunAnimation, 500, stunnedcreature, stunnedpos, counter)
    end
    return true
end

function onCastSpell(creature, var)

    local stunDuration = 3000
    local shield = 0

    -- Check for shield
    for i = 1,#checkWeaponSlots do -- Check what weapon is being used
        if creature:getSlotItem(checkWeaponSlots[i]) ~= nil then
            local weaponLiteral = creature:getSlotItem(checkWeaponSlots[i]) -- weapon object
            local itemType = ItemType(weaponLiteral:getId()) -- itemtype object
            local weaponType = itemType:getWeaponType()
            if weaponType > 0 then
                if weaponType == WEAPON_SHIELD then
                    shield = 1
                end
            end
        end
    end

    -- No weapon
    if shield == 0 then
        creature:sendCancelMessage("This spell requires a shield.")
        creaturePos:sendMagicEffect(CONST_ME_POFF)
        return false
    end

    -- Check if target is Player
    local stunCreature = Creature(var.number)
    if stunCreature:isPlayer() then
        stunDuration = stunDuration / 2 -- Halve stunDuration if Player
    end

    -- Stun
    local stun = Condition(CONDITION_STUN)
    stun:setParameter(CONDITION_PARAM_TICKS, stunDuration)
    stunCreature:addCondition(stun)

    -- Mute
    local mute = Condition(CONDITION_MUTED)
    mute:setParameter(CONDITION_PARAM_TICKS, stunDuration)
    stunCreature:addCondition(mute)

    -- Add animation
    addEvent(stunAnimation, 0, stunCreature.uid, stunCreature:getPosition(), (stunDuration / 1000) * 2)

    -- Damage formula
    local skill = creature:getSkillLevel(SKILL_SHIELD)
    local skillTotal = skill * (skill / 2)
    local levelTotal = creature:getLevel() / 5
    local min, max = -(((skillTotal * 0.02) + 4) + (levelTotal)), -(((skillTotal * 0.04) + 9) + (levelTotal))
    combat:setFormula(COMBAT_FORMULA_SKILL, 0, min, 0, max)

    -- Execute Damage
    return combat:execute(creature, var)
end