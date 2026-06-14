function onUse(cid, item, fromPosition, itemEx, toPosition)
	local gatePos = {x=32970, y=31759, z=7, stackpos=1}
	local nextTile = {x=gatePos.x, y=gatePos.y+1, z=gatePos.z}
	local gateItem = getThingfromPos(gatePos)

	if item.itemid == 1945 and gateItem.itemid == 1546 then
		doRemoveItem(gateItem.uid,1)
		doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 then
		doRelocate(gatePos, nextTile)
		doCreateItem(1546,1,gatePos)
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendCancel(cid,"Sorry not possible.")
	end
	
	return true
end