local doors = {
	5290,
	5105,
	1225,
	5114,
	1223,
	5123,
	7049,
	7040,
	9177,
	10791,
	12204,
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.actionid == 25003) then
		if (getPlayerStorageValue(cid,STORAGE_POSTMAN_DOOR) == 5) then
			if(isInArray(doors, item.itemid)) then
				local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
				doMoveCreature(cid, dir)
				doTransformItem(item.uid, item.itemid + 1)
			end
		end
	end
	return true
end