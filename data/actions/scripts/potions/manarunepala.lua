function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local pos = player:getPosition()

    -- Level check
    if player:getLevel() < 500 then
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("You need to be at least level 500 to use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Vocation check (5 = Master Sorcerer, 6 = Elder Druid)
    local vocId = player:getVocation():getId()
    if vocId ~= 3 and vocId ~= 7 then
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("Only Royal Paladins can use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Apply mana and visual feedback
    local manaAmount = math.random(300, 500)
    player:addMana(manaAmount)
    pos:sendMagicEffect(50)
    player:say("Ahuhauah...", TALKTYPE_MONSTER_SAY)

    item:remove(1)
    return true
end
