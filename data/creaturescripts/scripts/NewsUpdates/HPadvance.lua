local config = {
    heal = true,
    effect = true,
}

function onAdvance(player, skill, oldLevel, newLevel)
    if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
        return true
    end

    if config.effect then
        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        player:say('LEVEL UP!', TALKTYPE_MONSTER_SAY)
    end

    if config.heal then
        player:addHealth(player:getMaxHealth())
        player:addMana(player:getMaxMana())
    end
    return true
end