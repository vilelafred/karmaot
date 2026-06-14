function onUse(cid, item, fromPosition, itemEx, toPosition)
	local gatePos = {x=33256, y=31510, z=12, stackpos=1}
	local nextTile = {x=gatePos.x, y=gatePos.y+1, z=gatePos.z}
	local gateItem = getThingfromPos(gatePos)

	if item.itemid == 1945 and gateItem.itemid == 1355 then
		doRemoveItem(gateItem.uid,1)
		doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 then
		doRelocate(gatePos, nextTile)
		doCreateItem(1355,1,gatePos)
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendCancel(cid,"Sorry not possible.")
	end
	
	return true
end