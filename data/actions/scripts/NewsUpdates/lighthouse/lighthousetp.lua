function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local positions = {
		gatePos = Position(32233, 32276, 9),
		nextTile = Position(32234, 32276, 9),
		teleportPos = Position(32233, 32276, 9),
		goPos = Position(32225, 32275, 10)
	}

	local itemid = item:getId()

	if itemid == 1945 then
	 local teleport = Game.createItem(1387, -1, positions.teleportPos)
       Teleport(teleport.uid):setDestination(positions.goPos)
       item:transform(item.itemid + 1)
   elseif itemid == 1946 then
   		doRelocate(positions.gatePos, positions.nextTile)
   	local tp = Tile(teleportPos):getItemById(1387)
		if tp then
			tp:remove()
		end
		item:transform(item.itemid - 1)
	else
		player:sendCancelMessage("Sorry not possible.")
	end
	return true
end
