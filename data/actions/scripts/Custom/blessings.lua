function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Debug log
	print("DEBUG: Player " .. player:getName() .. " tried to use blessing scroll")
	
	-- Check if player has all blessings
	local hasAllBlessings = true
	local currentBlessings = {}
	
	for i = 1, 5 do
		local hasBlessing = player:hasBlessing(i)
		currentBlessings[i] = hasBlessing
		if not hasBlessing then
			hasAllBlessings = false
		end
		print("DEBUG: Blessing " .. i .. " = " .. tostring(hasBlessing))
	end
	
	if hasAllBlessings then
		player:sendCancelMessage("You already have all 5 blessings!")
		print("DEBUG: Player " .. player:getName() .. " already has all blessings")
		return true
	end
	
	-- Try to remove the item
	if not item:remove() then
		player:sendCancelMessage("Error using blessing scroll!")
		print("DEBUG: Error removing item for player " .. player:getName())
		return false
	end
	
	-- Add all blessings
	local blessingsAdded = 0
	for i = 1, 5 do
		if not currentBlessings[i] then
			if player:addBlessing(i, 1) then
				blessingsAdded = blessingsAdded + 1
				print("DEBUG: Blessing " .. i .. " added for " .. player:getName())
			else
				print("DEBUG: Error adding blessing " .. i .. " for " .. player:getName())
			end
		end
	end
	
	-- Visual effects and messages
	player:getPosition():sendMagicEffect(13)
	player:setStorageValue(30006, 1)
	
	if blessingsAdded > 0 then
		-- Count total blessings after adding
		local totalBlessings = 0
		for i = 1, 5 do
			if player:hasBlessing(i) then
				totalBlessings = totalBlessings + 1
			end
		end
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You received " .. blessingsAdded .. " blessing(s)! Total blessings: " .. totalBlessings .. "/5")
		print("DEBUG: " .. blessingsAdded .. " blessings added for " .. player:getName() .. " - Total: " .. totalBlessings .. "/5")
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, "No blessings were added. Check if you already have all of them.")
		print("DEBUG: No blessings were added for " .. player:getName())
	end
	
	return true
end