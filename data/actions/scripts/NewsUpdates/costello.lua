function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemid = item:getId()

if itemid == 1223 or itemid == 1225 then
	if player:getStorageValue(99697) == 1 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(player:getPosition(), fromPosition)
		doMoveCreature(player, dir)
	end
else
	player:sendCancelMessage("sorry, not possible.")
end


return true
end