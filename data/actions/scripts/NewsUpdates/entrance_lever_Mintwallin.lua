function onUse(player, item, fromPosition, target, toPosition, isHotkey)
local positions = {
	wall1 = Position(32593, 32103, 14),
}

local itemid,itemaid = item:getId(),item:getActionId()

	if itemaid == 9000 and itemid == 1946 then
		local wall = Tile(positions.wall1):getItemById(1026)
		if wall then
		wall:remove()
		Game.createItem(1025, 1, Position(32252, 32104, 14))
		Game.createItem(1025, 1, Position(32252, 32105, 14))	
	end
	else
		player:sendCancelMessage("Sorry, not possible.")
	end
	return true
end

