-- by Nottinghster

function onStepIn(cid, item, pos)
	local skull1 = {x=33310, y=31591, z=13, stackpos=255}
	local skull2 = {x=33310, y=31593, z=13, stackpos=255}
	local entrance = {x=33310, y=31592, z=12, stackpos=255}
	local getskull1 = getThingfromPos(skull1)
	local getskull2 = getThingfromPos(skull2)

	if item.actionid == 40999 and getskull1.itemid == 2151 and getskull2.itemid == 2151 then
		doRemoveItem(getskull1.uid,1)
		doRemoveItem(getskull2.uid,1)
		doCreateItem(1492,1,skull1)
		doCreateItem(1492,1,skull2)
		doSendMagicEffect(skull1, 8)
		doSendMagicEffect(skull2, 8)
		doTeleportThing(cid,entrance)
	end

	return true
end