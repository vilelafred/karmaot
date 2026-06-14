function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local itemid = item:getId()

	if player:getStorageValue(290) == 1 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(player:getPosition(), fromPosition)
		doMoveCreature(player, dir)
	else
		player:sendCancelMessage("sorry not possible.")
	end

	return true
end
