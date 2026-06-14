function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Usar machete no arbusto (2782 -> 2781)
    if target.itemid == 2782 then
        target:transform(2781)
        target:decay()
        return true
    end

    -- Usar machete no item 1499 (destruir com efeito poff)
    if target.itemid == 1499 then
        target:remove()
        toPosition:sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- Demais usos
    return destroyItem(player, target, toPosition)
end
