local light = createConditionObject(CONDITION_LIGHT)
setConditionParam(light, CONDITION_PARAM_LIGHT_LEVEL, 10)
setConditionParam(light, CONDITION_PARAM_LIGHT_COLOR, 215)
setConditionParam(light, CONDITION_PARAM_TICKS, -1)

function onEquip(cid, item, slot)
    if (item.itemid == 6747) then
        doAddCondition(cid, light)
        return true
    end
end

function onDeEquip(cid, item, slot)
    if (item.itemid == 6747) then
        if hasCondition(cid, CONDITION_LIGHT) then
		doRemoveCondition(cid, CONDITION_LIGHT)
        end
    end
    return true
end