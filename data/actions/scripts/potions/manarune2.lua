function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local pos = player:getPosition()

    -- Vocation and level requirements
    local vocId = player:getVocation():getId()
    local requiredLevel
    if vocId == 5 or vocId == 6 then
        requiredLevel = 500 -- Master Sorcerer / Elder Druid
    elseif vocId == 4 or vocId == 8 then
        requiredLevel = 800 -- Knight / Elite Knight
    else
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("Only MS/ED and Knight/Elite Knight can use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    if player:getLevel() < requiredLevel then
        pos:sendMagicEffect(CONST_ME_POFF)
        player:say("You need to be at least level " .. requiredLevel .. " to use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Apply mana and visual feedback
    local manaAmount = math.random(350, 500)
    player:addMana(manaAmount)
    pos:sendMagicEffect(CONST_ME_MAGIC_RED)
    player:say("Muhahah...", TALKTYPE_MONSTER_SAY)

    item:remove(1)
    return true
end
