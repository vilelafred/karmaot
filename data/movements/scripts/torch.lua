local light = createConditionObject(CONDITION_LIGHT)
setConditionParam(light, CONDITION_PARAM_LIGHT_LEVEL, 10)
setConditionParam(light, CONDITION_PARAM_LIGHT_COLOR, 215)
setConditionParam(light, CONDITION_PARAM_TICKS, 2147483647)  -- Usando um valor muito grande para garantir uma duração praticamente infinita

function onEquip(cid, item, slot)
    if (item.itemid == 7723) then
        doAddCondition(cid, light)
        return true
    end
end

function onDeEquip(cid, item, slot)
    if (item.itemid == 7723) then
        local condition = getCreatureCondition(cid, CONDITION_LIGHT)
        if condition then
            doRemoveCondition(cid, CONDITION_LIGHT)
        end
    end
    return true
end
