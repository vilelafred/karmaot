function onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local split = param:split(" ")
	if #split < 3 then
		player:sendCancelMessage("Use: /settp x y z")
		return false
	end

	local x, y, z = tonumber(split[1]), tonumber(split[2]), tonumber(split[3])
	if not x or not y or not z then
		player:sendCancelMessage("Invalid coordinates.")
		return false
	end

	local pos = player:getPosition()
	pos:getNextPosition(player:getDirection(), 1)

	local tile = Tile(pos)
	if not tile then
		player:sendCancelMessage("No tile found.")
		return false
	end

	local item = tile:getTopDownItem()
	if not item then
		player:sendCancelMessage("No item found.")
		return false
	end

	if not item:isTeleport() then
		player:sendCancelMessage("Item is not a teleport.")
		return false
	end

	if item:setAttribute(ITEM_ATTRIBUTE_TELEPORT_DESTINATION, Position(x, y, z)) then
		pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Teleport destination set to: " .. x .. ", " .. y .. ", " .. z)
	else
		player:sendCancelMessage("Failed to set destination.")
	end

	return false
end
