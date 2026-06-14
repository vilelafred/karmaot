function ChangeBack(cid)
	doRemoveItem(getThingfromPos({x=32479, y=31904, z=3, stackpos=1}).uid, 1386)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)

	local food1 = {x=33310, y=31591, z=13, stackpos=1}
	local food2 = {x=33310, y=31593, z=13, stackpos=1}
	local getfood1 = getThingfromPos(food1)
	local getfood2 = getThingfromPos(food2)	
	local ladderpos = {x=33309, y=31592, z=13, stackpos=1}
	local getladder = getThingfromPos(ladderpos)

	if item.actionid == 40995 and item.itemid == 1945 and getfood1.itemid == 2151 and getfood2.itemid == 2151 then
		addEvent(ChangeBack, 45000, cid)
		doCreateItem(1386,1,ladderpos)
		doRemoveItem(getfood1.uid,1)
		doRemoveItem(getfood2.uid,1)
		doSendMagicEffect(food1, 2)
		doSendMagicEffect(food2, 2)
		doTransformItem(item.uid,item.itemid+1)
	elseif item.actionid == 40995 and item.itemid == 1946 then
		doTransformItem(item.uid,item.itemid-1)
	end

	return true
end