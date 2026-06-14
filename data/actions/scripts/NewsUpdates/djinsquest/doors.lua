function onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	local actionid = item:getActionId()
	local itemid = item:getId()
	
	if player:getStorageValue(1020) >= 2 and actionid == 915 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
		doMoveCreature(player, dir)
	elseif player:getStorageValue(1020) >= 11 and actionid == 913 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
		doMoveCreature(player, dir)
	elseif player:getStorageValue(1030) >= 2 and actionid == 914 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
		doMoveCreature(player, dir)
	elseif player:getStorageValue(1030) >= 2 and actionid == 916 then
		item:transform(itemid + 1)
		local dir = getDirectionTo(getPlayerPosition(cid), fromPosition)
		doMoveCreature(player, dir)
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "The door is sealed against unwanted intruders.")
	end

	return true
end


