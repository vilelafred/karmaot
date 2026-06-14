local wallPositions = {
	{x=32915, y=32076, z=6}
}

local wall1Positions = {
	{x=32915, y=32080, z=6}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 1945 then
		for i = 1, #wallPositions do
		for u = 1, #wall1Positions do
		local wallItem = getTileItemById(wallPositions[i], 386)
		local wall1Item = getTileItemById(wall1Positions[u], 386)
		if wallItem.itemid == 386 then
			doRemoveItem(wallItem.uid,1)
			doRemoveItem(wall1Item.uid,1)
		end
	end
	end
	elseif item.itemid == 1946 then
		for i = 1, #wallPositions do
		for u = 1, #wall1Positions do
			doCreateItem(386,wallPositions[i])
			doCreateItem(386,wall1Positions[u])
		end
	end
	end
	
	return true
end