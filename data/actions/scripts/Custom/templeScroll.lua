function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isPzLocked() and not player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
		player:teleportTo(getTownTemplePosition(player:getTown():getId()))
		--doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_BLUE)	
		item:remove()
	else
		player:sendCancelMessage("You can't use this when you're in a fight.")
		Position(fromPosition):sendMagicEffect(CONST_ME_POFF)
	end
	return true
end
