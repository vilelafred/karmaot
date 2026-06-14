local wall1 = {x=32482, y=32170, z=14} -- Wall position
local wall2 = {x=32468, y=32119, z=14} -- Wall position
local newpos = {x=wall1.x, y=wall1.y, z=wall1.z}

function onStepIn(cid, item, position, fromPosition)
		doTransformItem(item.uid, 425)
		doCreateItem(430,1,wall1)
                doSendMagicEffect(wall1,14)
                doSendMagicEffect(wall2,14)
end

function onStepOut(cid, item, position, fromPosition)
		doTransformItem(item.uid, 426)
                doSendMagicEffect(wall1,13)
                doSendMagicEffect(wall2,13)
		wall1.stackpos = 1
		local getwall1 = getThingfromPos(wall1) -- Get thing from wall position
    pos = getCreaturePosition(cid)
     doRemoveItem(getwall1.uid,1)
	return TRUE
end