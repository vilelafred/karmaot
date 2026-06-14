function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local pos = player:getPosition()

    -- Level check
    if player:getLevel() < 1100 then
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("You need to be at least level 1100 to use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Vocation check (5 = Master Sorcerer, 6 = Elder Druid)
    local vocId = player:getVocation():getId()
    if vocId ~= 5 and vocId ~= 6 then
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("Only Master Sorcerers and Elder Druids can use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Apply mana and visual feedback
    local manaAmount = math.random(1000, 1200)
    player:addMana(manaAmount)
    pos:sendMagicEffect(168)
    player:say("Feeling Unstoppable..", TALKTYPE_MONSTER_SAY)

    item:remove(1)
    return true
end
