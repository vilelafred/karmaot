function onUse(player, item, fromPosition, target, toPosition, isHotkey)

    local manaAmount = math.random(80, 170)
    player:addMana(manaAmount)

    local ppos = player:getPosition()
    ppos:sendMagicEffect(CONST_ME_MAGIC_BLUE)

    player:say("Aaaah...", TALKTYPE_MONSTER_SAY)
    item:remove(1)

    return true
end
