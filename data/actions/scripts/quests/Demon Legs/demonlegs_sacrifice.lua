function onUse(cid, item, frompos, item2, topos)
	food1 = {x=33281, y=31540, z=13, stackpos=1}
	food2 = {x=33282, y=31540, z=13, stackpos=1}
	getfood1 = getThingfromPos(food1)
	getfood2 = getThingfromPos(food2)	
	ladderpos = {x=33284, y=31544, z=13, stackpos=1}
	getladder = getThingfromPos(ladderpos)
	if item.actionid == 40996 and item.itemid == 1945 and getfood1.itemid == 1487 and getfood2.itemid == 1487 then
		addEvent(ChangeBack, 45000, cid)
		doCreateItem(1386, 1, ladderpos)
		doRemoveItem(getfood1.uid, 1)
		doRemoveItem(getfood2.uid, 1)
		doSendMagicEffect(food1, 2)
		doSendMagicEffect(food2, 2)
		doTransformItem(item.uid, item.itemid+1)
	elseif item.actionid == 40996 and item.itemid == 1946 then
		doTransformItem(item.uid, item.itemid-1)
	end

	return true
end