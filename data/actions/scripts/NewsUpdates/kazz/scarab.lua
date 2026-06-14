local wallPositions = {
	{x=33211, y=32698, z=13}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.itemid == 1829 then
		for i = 1, #wallPositions do
		local wallItem = getTileItemById(wallPositions[i], 1061)
		if wallItem.itemid == 1061 then
			doRemoveItem(wallItem.uid,1)
		else
			doCreateItem(1061,wallPositions[i])
		end
		end
	end
	
	return true
end