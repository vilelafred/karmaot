-- by Nottinghster
function onStepIn(cid, item, pos)

	coin = {x=33310, y=31593, z=13, stackpos=1}
	newpos = {x=33310, y=31592, z=13}

	getcoin = getThingfromPos(coin)
	
	if item.actionid == 40995 and getcoin.itemid == 2151 then
		doTeleportThing(cid,newpos)
		doRemoveItem(getcoin.uid,1)
		doSendMagicEffect(coin, CONST_ME_MAGIC_RED)
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
		else
	end
	
	if item.actionid == 40996 then
	doTeleportThing(cid, {x=33321, y=31592, z=15})
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)	
	end
	return true
end