local BoxId = 6066
local Ladder = 1386
local LadderPos = {x=32669, y=32149, z=11, stackpos=1}

function onAddItem(moveitem, tileitem, pos)
	if moveitem.itemid == BoxId then  	
		doCreateItem(Ladder, 1, LadderPos)
	end
end

function onRemoveItem(moveitem, tileitem, pos)
	if moveitem.itemid == BoxId then  	
		doRemoveItem(getThingfromPos({x=32669, y=32149, z=11, stackpos=1}).uid,1)
	end
end