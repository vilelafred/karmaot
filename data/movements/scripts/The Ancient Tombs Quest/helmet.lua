	--//Helmet of the Ancients//--
	function onAddItem(moveitem, tileitem, pos)
	if tileitem:getActionId() == 13002 then
		--print("aiiaia")
		if moveitem:getId() == 2335 or moveitem:getId() == 2336 or moveitem:getId() == 2337 or moveitem:getId() == 2338 or moveitem:getId() == 2339 or moveitem:getId() == 2340 or moveitem:getId() == 2341 then
		PayPos = {x=33198, y=32876, z=11}
		Item1 = getTileItemById(PayPos, 2335)
		Item2 = getTileItemById(PayPos, 2336)
		Item3 = getTileItemById(PayPos, 2337)
		Item4 = getTileItemById(PayPos, 2338)
		Item5 = getTileItemById(PayPos, 2339)
		Item6 = getTileItemById(PayPos, 2340)
		Item7 = getTileItemById(PayPos, 2341)
		
			if Item1.itemid == 2335 and Item2.itemid == 2336 and Item3.itemid == 2337 and Item4.itemid == 2338 and Item5.itemid == 2339 and Item6.itemid == 2340 and Item7.itemid == 2341 then
			doRemoveItem(Item1.uid)
			doRemoveItem(Item2.uid)
			doRemoveItem(Item3.uid)
			doRemoveItem(Item4.uid)
			doRemoveItem(Item5.uid)
			doRemoveItem(Item6.uid)
			doTransformItem(Item7.uid,2342)
			doSendMagicEffect(PayPos, 15)
			end
		end
		
		
	
	end
return true
end