function onUse(cid, item, fromPosition, itemEx, toPosition)
	local gatePos = {x=32225, y=32276, z=8, stackpos=0}
	local gateItem = getThingfromPos(gatePos)

	if item.itemid == 1945 and gateItem.itemid == 355 then
		doRemoveItem(gateItem.uid,1)
		doCreateItem(429,1,gatePos)
		doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 then
		doTransformItem(item.uid,item.itemid-1)
		local wallItem = getTileItemById({x=32225, y=32276, z=8}, 429)
		if wallItem.itemid == 429 then
			doRemoveItem(wallItem.uid,1)
			doCreateItem(355,{x=32225, y=32276, z=8})
		end
	else
		doPlayerSendCancel(cid,"Sorry not possible.")
	end
	
	return true
end