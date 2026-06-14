-- Apply per-element resistances from items.xml as Conditions when equipping/unequipping

local combatTypes = {
    COMBAT_PHYSICALDAMAGE,
    COMBAT_ENERGYDAMAGE,
    COMBAT_EARTHDAMAGE,
    COMBAT_FIREDAMAGE,
    COMBAT_ICEDAMAGE,
    COMBAT_HOLYDAMAGE,
    COMBAT_DEATHDAMAGE
}

local paramByCombat = {
    [COMBAT_PHYSICALDAMAGE] = CONDITION_PARAM_COMBAT_PHYSICALDAMAGE,
    [COMBAT_ENERGYDAMAGE]  = CONDITION_PARAM_COMBAT_ENERGYDAMAGE,
    [COMBAT_EARTHDAMAGE]   = CONDITION_PARAM_COMBAT_EARTHDAMAGE,
    [COMBAT_FIREDAMAGE]    = CONDITION_PARAM_COMBAT_FIREDAMAGE,
    [COMBAT_ICEDAMAGE]     = CONDITION_PARAM_COMBAT_ICEDAMAGE,
    [COMBAT_HOLYDAMAGE]    = CONDITION_PARAM_COMBAT_HOLYDAMAGE,
    [COMBAT_DEATHDAMAGE]   = CONDITION_PARAM_COMBAT_DEATHDAMAGE,
}

local function conditionKey(slot, combat)
    return 80000 + (slot * 100) + combat
end

local function applyItemResistsInSlot(player, slot)
    -- remove old conditions for this slot
    for _, c in ipairs(combatTypes) do
        local key = conditionKey(slot, c)
        local cond = player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT, key)
        if cond then player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT, key) end
    end

    local item = player:getSlotItem(slot)
    if not item then return end

    local itemType = item:getType()
    for _, c in ipairs(combatTypes) do
        local percent = itemType:getAbsorbPercent(c)
        if percent and percent ~= 0 then
            local cond = Condition(CONDITION_ATTRIBUTES)
            cond:setParameter(CONDITION_PARAM_TICKS, -1)
            cond:setParameter(CONDITION_PARAM_SUBID, conditionKey(slot, c))
            cond:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
            local param = paramByCombat[c]
            if param then
                cond:setParameter(param, percent)
            end
            player:addCondition(cond)
        end
    end
end

local movement = MoveEvent()

function movement.onEquip(player, item, slot, isCheck)
    applyItemResistsInSlot(player, slot)
    return true
end

function movement.onDeEquip(player, item, slot)
    applyItemResistsInSlot(player, slot)
    return true
end

movement:type("equip")
movement:id(0)
movement:register()


