function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.actionid == 24777) then
		if (getPlayerStorageValue(cid,STORAGE_THADDEUS_DOOR) == 5) then
			if(isInArray(doors, item.itemid)) then
				local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
				doMoveCreature(cid, dir)
				doTransformItem(item.uid, item.itemid + 1)
			end
		end
	end
	return true
end