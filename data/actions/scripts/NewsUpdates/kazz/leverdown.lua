function onUse(cid, item, fromPosition, itemEx, toPosition)
	local goPos = {x=32636, y = 31881, z = 2, stackpos=255}
	local gate = getThingfromPos(goPos)
	
    if item.itemid == 1945 and gate.itemid > 0 and gate.itemid < 100 then
    doTeleportThing(cid, {x=32636, y=31881, z=7})
	doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 and gate.itemid > 0 then
    doTeleportThing(cid, {x=32636, y=31881, z=7})
	doTransformItem(item.uid,item.itemid-1)
	else
	doPlayerSendCancel(cid, "sorry not possible.")
	end
    return true
end