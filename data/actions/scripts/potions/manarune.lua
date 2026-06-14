function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local position = player:getPosition()

    -- Verifica level mínimo
    if player:getLevel() < 280 then
        position:sendMagicEffect(CONST_ME_POFF)
        player:say("You need to be at least level 280 to use this rune!", TALKTYPE_MONSTER_SAY)
        return false
    end

    -- Aplica mana aleatória
    local manaAmount = math.random(180, 300)
    player:addMana(manaAmount)

    -- Efeito e feedback
    position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
    player:say("Aaaah...", TALKTYPE_MONSTER_SAY)

    -- Remove o item usado
    item:remove(1)
    return true
end
