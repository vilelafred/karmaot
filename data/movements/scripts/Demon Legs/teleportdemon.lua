function onStepIn(cid, item, pos)

	white = {x=33310, y=31591, z=13, stackpos=255}
	black = {x=33310, y=31593, z=13, stackpos=255}
	newpos = {x=33310, y=31592, z=12}

	getwhite = getThingfromPos(white)
	getblack = getThingfromPos(black)
	
	if item.actionid == 40999 and getwhite.itemid == 2151 and getblack.itemid == 2151 then
		doTeleportThing(cid,newpos)
		doRemoveItem(getwhite.uid,1)
		doRemoveItem(getblack.uid,1)
		doSendMagicEffect(white, CONST_ME_POFF)
		doSendMagicEffect(black, CONST_ME_POFF)
		doSendMagicEffect(getCreaturePosition(cid), 10)
	else
	end

end