function onUse(cid, item, fromPosition, itemEx, toPosition)
	local wall1 = {x=32593, y=32103, z=14, stackpos=1}
	local wall2 = {x=32594, y=32103, z=14, stackpos=1}
	local wall3 = {x=32595, y=32103, z=14, stackpos=1}
	local wall4 = {x=32596, y=32103, z=14, stackpos=1}
	local wall5 = {x=32597, y=32103, z=14, stackpos=1}
	local wall6 = {x=32598, y=32103, z=14, stackpos=1}
	local wall7 = {x=32599, y=32103, z=14, stackpos=1}
	local wall8 = {x=32600, y=32103, z=14, stackpos=1}
	local wall9 = {x=32601, y=32103, z=14, stackpos=1}
	local wall10 = {x=32602, y=32103, z=14, stackpos=1}	
	local getwall1 = getThingfromPos(wall1)
	local getwall2 = getThingfromPos(wall2)
	local getwall3 = getThingfromPos(wall3)
	local getwall4 = getThingfromPos(wall4)
	local getwall5 = getThingfromPos(wall5)
	local getwall6 = getThingfromPos(wall6)
	local getwall7 = getThingfromPos(wall7)
	local getwall8 = getThingfromPos(wall8)
	local getwall9 = getThingfromPos(wall9)
	local getwall10 = getThingfromPos(wall10)

	if item.actionid == 9000 and item.itemid == 1946 and getwall1.itemid == 1026 then
		doRemoveItem(getwall1.uid,1)
		doRemoveItem(getwall2.uid,1)
		doRemoveItem(getwall3.uid,1)
		doRemoveItem(getwall4.uid,1)
		doRemoveItem(getwall5.uid,1)
		doRemoveItem(getwall6.uid,1)
		doRemoveItem(getwall7.uid,1)
		doRemoveItem(getwall8.uid,1)
		doRemoveItem(getwall9.uid,1)
		doRemoveItem(getwall10.uid,1)
		doCreateItem(1025,1,{x=32592, y=32104, z=14})
		doCreateItem(1025,1,{x=32592, y=32105, z=14})
	else
		doPlayerSendCancel(cid,"Sorry, not possible.")
	end

	return true
end