local wallPositions = {
	one = Position(32566, 32119, 7)
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

local itemid = item:getId()

	if itemid == 1945 then
		local wallItem = Tile(wallPositions.one):getItemById(1025)
		if wallItem then
			wallItem:remove()
		end
		item:transform(item.itemid + 1)
	elseif itemid == 1946 then
		Game.createItem(1025, 1, wallPositions.one)
		item:transform(item.itemid - 1)
	end
	return true
end
