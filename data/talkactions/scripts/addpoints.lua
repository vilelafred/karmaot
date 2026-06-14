function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	-- Check if parameters were provided
	if not param or param == "" then
		player:sendCancelMessage("Usage: /addpoints player_name, amount")
		player:sendCancelMessage("Example: /addpoints Player Name, 100")
		return false
	end

	local targetName = param
	local points = 100 -- default value

	-- Check if there's a comma (separator)
	local separatorPos = param:find(',')
	if separatorPos then
		targetName = string.trim(param:sub(1, separatorPos - 1))
		local pointsStr = string.trim(param:sub(separatorPos + 1))
		points = tonumber(pointsStr)
		
		if not points or points <= 0 then
			player:sendCancelMessage("The amount of karma points must be a positive number.")
			return false
		end
	else
		-- If no comma, consider only the name was passed (100 points default)
		targetName = string.trim(param)
	end

	-- Check if player exists
	local accountId = getAccountNumberByPlayerName(targetName)
	if accountId == 0 then
		player:sendCancelMessage("Player '" .. targetName .. "' not found.")
		return false
	end

	-- Add premium points to database
	local query = "UPDATE `accounts` SET `premium_points` = `premium_points` + " .. points .. " WHERE `id` = " .. accountId
	local result = db.query(query)
	
	if result then
		-- Confirm to administrator
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, points .. " karma points have been added to " .. targetName .. ".")
		
		-- If player is online, notify them too
		local target = Player(targetName)
		if target then
			target:sendTextMessage(MESSAGE_INFO_DESCR, points .. " Karma Points have been added to your account by an administrator!")
		end
	else
		player:sendCancelMessage("Error adding karma points. Please check the database.")
	end

	return false
end
