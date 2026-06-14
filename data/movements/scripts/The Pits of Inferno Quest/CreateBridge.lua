function onStepIn(cid, item, frompos, item2, topos) 
	wall1 = {x=32852, y=32310, z=11, stackpos=1}
	getwall1 = getThingfromPos(wall1)

	if item.uid == 10325 then
	doRemoveItem(getwall1.uid,1)	
end
end

function onStepOut(cid, item, frompos, item2, topos)
	wall1 = {x=32852, y=32310, z=11, stackpos=1}
	getwall1 = getThingfromPos(wall1)

	if item.uid == 10325 then
	doCreateItem(387,1,wall1)
	end

	return 1
end