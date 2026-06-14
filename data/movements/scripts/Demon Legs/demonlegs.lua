local BoxId = 1739
local Ladder = 1386
local LadderPos = {x=33309, y=31592, z=13, stackpos=1}

function onAddItem(moveitem, tileitem, pos)
	if moveitem.itemid == BoxId then  	
		doCreateItem(Ladder, 1, LadderPos)
	end
end

function onRemoveItem(moveitem, tileitem, pos)
	if moveitem.itemid == BoxId then  	
		doRemoveItem(getThingfromPos({x=33309, y=31592, z=13, stackpos=1}).uid,1)
	end
end