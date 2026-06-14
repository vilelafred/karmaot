local wallPositions = {
	{x=32566, y=32119, z=7}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 1945 then
		for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 1025)
		if wallItem.itemid == 1025 then
			doRemoveItem(wallItem.uid,1)
			doTransformItem(item.uid,item.itemid+1)
		end
	end
	elseif item.itemid == 1946 then
		for i = 1, #wallPositions do
			doCreateItem(1025,wallPositions[i])
			doTransformItem(item.uid,item.itemid-1)
		end
	end
	
	return true
end