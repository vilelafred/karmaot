function onUse(player, item, fromPosition, target, toPosition, isHotkey)
local positions = {
	gatePos = Position(32225, 32276, 8)
}

local itemid = item:getId()

	if itemid == 1945 then
		local itemtp = Tile(positions.gatePos):getItemById(355)
		if itemtp then
			itemtp:remove()
			Game.createItem(429, 1, positions.gatePos)
		end
		item:transform(item.itemid + 1)
	elseif itemid == 1946 then
		item:transform(item.itemid - 1)
		local wallItem = Tile(positions.gatePos):getItemById(429)
		if wallItem then
		wallItem:remove()
		Game.createItem(355, 1, positions.gatePos) 
	end
else
	player:sendCancelMessage("Sorry not possible.")
end

return true
end




