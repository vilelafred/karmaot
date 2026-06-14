wallPosition = Position(33108, 32530, 3)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(1020) == 6 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You Have Chosem an tear of daraman.")
		Game.createItem(2346, 1, wallPosition)
		player:setStorageValue(1020, 7)
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The chest is empty.")
	end
	return true
end