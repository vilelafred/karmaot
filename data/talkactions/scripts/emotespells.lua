function onSay(player)
	local switch = player:getStorageValue(203500) == -1 and 1 or -1

	player:sendTextMessage(MESSAGE_INFO_DESCR, 'Emote spells: (' .. (switch == 1 and 'ON' or 'OFF') .. ')')
	player:setStorageValue(203500, switch)
end