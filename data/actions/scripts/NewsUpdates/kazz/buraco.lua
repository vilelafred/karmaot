local wallPositions = {
	{x=32605, y=31902, z=4}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 1945 then
		for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 431)
		if wallItem.itemid == 431 then
			doRemoveItem(wallItem.uid,1)
			doCreateItem(408,1,wallPositions[i])
			doTransformItem(item.uid,item.itemid+1)
		end
	end
	elseif item.itemid == 1946 then
		for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 408)
		if wallItem.itemid == 408 then
			doRemoveItem(wallItem.uid,1)
			doCreateItem(431,wallPositions[i])
			doTransformItem(item.uid,item.itemid-1)
		end
	end
	end
	
	return true
end