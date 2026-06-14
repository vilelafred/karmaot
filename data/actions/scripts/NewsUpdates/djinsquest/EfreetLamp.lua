function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local Removewall4,Removewall5 = Position(33094, 32524, 1), Position(33048, 32630, 1)
	local itemid = item:getId()

	if itemid == 2344 and player:getStorageValue(1020) >= 9 then
		local tile1 = Tile(Removewall4):getItemById(2344)
		if tile1 then
			tile1:remove()
			player:setStorageValue(1020, 11)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		else
			player:sendCancelMessage("Sorry not possible.")
		end

	elseif itemid == 2344 and player:getStorageValue(1030) >= 8 then
		local tile2 = Tile(Removewall5):getItemById(2344)
		if tile2 then
			tile2:remove()
			player:setStorageValue(1030, 10)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		else
			player:sendCancelMessage("Sorry not possible.")
		end
	end
	return true
end
  