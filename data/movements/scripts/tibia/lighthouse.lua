local wallPositions = {
	{x=32225, y=32282, z=9}
}

function onStepIn(cid, item, position)
	
	doTransformItem(item.uid,item.itemid-1)

	local positions = {
		{x=32225, y=32268, z=9}
	}

	for i = 1, #positions do
		local creature = getTopCreature(positions[i])
		if not creature then
			return true
		end
	end

	for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 424)
		if wallItem.itemid == 424 then
			doRemoveItem(wallItem.uid,1)
			doCreateItem(432,1,wallPositions[i])
		end
	end

	return true
end

function onStepOut(cid, item, position)
	doTransformItem(item.uid,item.itemid+1)
	for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 432)
		if wallItem.itemid == 432 then
			doRemoveItem(wallItem.uid,1)
			doCreateItem(424,wallPositions[i])
		end
	end

	return true
end