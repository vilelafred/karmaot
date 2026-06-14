function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You are not authorized to use this command.")
		return false
	end

	local targetName = param and param:trim()
	if targetName == nil or targetName == '' then
		player:sendCancelMessage("Usage: /paralyze playerName")
		return false
	end

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("Player not found.")
		return false
	end

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 10000)
	-- reduce speed to minimum
	condition:setParameter(CONDITION_PARAM_SPEED, -1500)

	-- optionally clear old paralyze to re-apply duration cleanly
	target:removeCondition(CONDITION_PARALYZE)
	target:addCondition(condition)

	target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Paralyzed " .. target:getName() .. " for 5 seconds.")
	return false
end


