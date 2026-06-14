function onSay(player, words, param)
    -- Check if the player has a vocation
    if player:getVocation() == 0 then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You need to choose a vocation to use this command.")
        return false
    end

    -- Check if the player is at level 8
    if player:getLevel() < 8 then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You need to be at least level 8 to use this command.")
        return false
    end

    -- Open the skill points window
    player:sendSkillPointsWindow()

    return false
end
