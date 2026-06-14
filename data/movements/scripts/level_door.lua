function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local requiredLevel = item.actionid - 1000

	if creature:getLevel() < requiredLevel then
		creature:sendTextMessage(MESSAGE_INFO_DESCR, "Only the worthy may pass. You need level " .. requiredLevel .. ".")
		creature:teleportTo(fromPosition, true)
		return false
	end

	return true
end
