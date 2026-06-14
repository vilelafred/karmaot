function onStepOut(cid, item, frompos, item2, topos) 
	wall1 = {x=32316, y=31753,z=2}
	getwall1 = getThingfromPos(wall1)
		
		if item.actionid == 4111 and
		getwall1.itemid == 432 then
		doRemoveItem(getwall1.uid,1)
		doCreateItem(424,1,wall1)
		doTransformItem(item.uid, item.itemid + 1)
		


		else

end
end
 
function onStepIn(cid, item, frompos, item2, topos)
	wall1 = {x=32308, y=31839, z=8}

	
	getwall1 = getThingfromPos(wall1)

	
	if item.actionid == 4111 and 
		getwall1.itemid == 424 then
		doRemoveItem(getwall1.uid,1)
		doCreateItem(432,1,wall1)
		doTransformItem(item.uid, item.itemid - 1)
		


		else

 
end
end