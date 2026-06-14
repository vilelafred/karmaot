	--//Helmet of the Ancients//--
	function onAddItem(moveitem, tileitem, pos)
	if tileitem:getActionId() == 61113 then
		--print("aiiaia")
		if moveitem:getId() == 2151 or moveitem:getId() == 2153 or moveitem:getId() == 2154 or moveitem:getId() == 2155 or moveitem:getId() == 2156 or moveitem:getId() == 2158 or moveitem:getId() == 2400 then
		PayPos = {x=33022, y=32176, z=9}
		Item1 = getTileItemById(PayPos, 2151)
		Item2 = getTileItemById(PayPos, 2154)
		Item3 = getTileItemById(PayPos, 2155)
		Item4 = getTileItemById(PayPos, 2156)
		Item5 = getTileItemById(PayPos, 2158)
		Item6 = getTileItemById(PayPos, 2350)
		Item7 = getTileItemById(PayPos, 6215)
		
			if Item1.itemid == 2151 and Item2.itemid == 2153 and Item3.itemid == 2154 and Item4.itemid == 2155 and Item5.itemid == 2156 and Item6.itemid == 2158 and Item7.itemid == 2400 then
			doRemoveItem(Item1.uid)
			doRemoveItem(Item2.uid)
			doRemoveItem(Item3.uid)
			doRemoveItem(Item4.uid)
			doRemoveItem(Item5.uid)
			doRemoveItem(Item6.uid)
			doTransformItem(Item7.uid,6067)
			doSendMagicEffect(PayPos, 15)
			end
		end
		
		
	
	end
return true
end