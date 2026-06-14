function onUse(cid, item, fromPosition, itemEx, toPosition)
	local gatePos = {x=32233, y=32276, z=9, stackpos=1}
	local nextTile = {x=gatePos.x+1, y=gatePos.y, z=gatePos.z}
	local teleportPos = {x=32233, y=32276, z=9, stackpos=1}
	local goPos = {x=32225, y=32275, z=10, stackpos=1}
	local gateItem = getThingfromPos(gatePos)
	local teleportItem = getThingfromPos(teleportPos)

	if item.itemid == 1945 then
		doCreateTeleport(1387, goPos, teleportPos)
		doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 then
		doRelocate(gatePos, nextTile)
		doRemoveItem(teleportItem.uid,1)
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendCancel(cid,"Sorry not possible.")
	end
	
	return true
end