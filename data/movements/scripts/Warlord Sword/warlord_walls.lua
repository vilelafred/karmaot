local wallPositions = {
	{x=33031, y=32174, z=9},
	{x=33031, y=32175, z=9},
	{x=33031, y=32176, z=9}
}

function onStepIn(cid, item, position)
	
	doTransformItem(item.uid,item.itemid-1)

	local positions = {
		{x=33045, y=32212, z=9},
		{x=33047, y=32214, z=9}
	}

	for i = 1, #positions do
		local creature = getTopCreature(positions[i])
		if not creature then
			return true
		end
	end

	for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 1498)
		if wallItem.itemid == 1498 then
			doRemoveItem(wallItem.uid,1)
		end
	end

	return true
end

function onStepOut(cid, item, position)

	doTransformItem(item.uid,item.itemid+1)

	for i = 1, #wallPositions do
		local wallItem = getThingfromPos(wallPositions[i])
		if wallItem.itemid == 1498 then
			return true
		end
		local nextTile = {x = wallPositions[i].x, y = wallPositions[i].y+1, z = wallPositions[i].z}
		doRelocate(wallPositions[i], nextTile)
		doCreateItem(1498,1,wallPositions[i])
	end

	return true
end