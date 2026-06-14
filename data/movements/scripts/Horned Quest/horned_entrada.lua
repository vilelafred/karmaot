-- by Nottinghster

function onStepIn(cid, item, pos)
	local skull1 = {x=33011, y=32089, z=10, stackpos=255}
	local skull2 = {x=33008, y=32092, z=10, stackpos=255}
	local skull3 = {x=33014, y=32092, z=10, stackpos=255}
	local skull4 = {x=33011, y=32095, z=10, stackpos=255}
	local entrance = {x=32983, y=32093, z=10, stackpos=255}
	local getskull1 = getThingfromPos(skull1)
	local getskull2 = getThingfromPos(skull2)
	local getskull3 = getThingfromPos(skull3)
	local getskull4 = getThingfromPos(skull4)

	if item.actionid == 52000 and getskull1.itemid == 5949 and getskull2.itemid == 5950 and getskull3.itemid == 5951 and getskull4.itemid == 5952 then
		doRemoveItem(getskull1.uid,1)
		doRemoveItem(getskull2.uid,1)
		doRemoveItem(getskull3.uid,1)
		doRemoveItem(getskull4.uid,1)
		doCreateItem(1490,1,skull1)
		doCreateItem(1490,1,skull2)
		doCreateItem(1490,1,skull3)
		doCreateItem(1490,1,skull4)
		doSendMagicEffect(skull1, 8)
		doSendMagicEffect(skull2, 8)
		doSendMagicEffect(skull3, 8)
		doSendMagicEffect(skull4, 8)
		doTeleportThing(cid,entrance)
	end

	return true
end