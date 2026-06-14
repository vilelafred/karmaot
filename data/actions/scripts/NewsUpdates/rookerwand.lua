function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemid = item:getCount()
	local targetId = target.itemid

	if targetId == 6821 then
        if itemid >= 10 then
            target:remove()
            item:remove()
            player:addItem(6822, 1)
            doSendMagicEffect(getCreaturePosition(player), 14)
            player:say("You successfull recharge rooker wand!", TALKTYPE_MONSTER_SAY)
        else
            doSendMagicEffect(getCreaturePosition(player), 3)
            doPlayerSendCancel(player, "Sorry, you need at least 10 rooker rubys!")
        end
	else
        doSendMagicEffect(getCreaturePosition(player), 3)
        doPlayerSendCancel(player, "You need a rooker wand to recharge!")
    end
	return true
end
