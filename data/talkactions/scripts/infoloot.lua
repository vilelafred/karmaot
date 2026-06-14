function onSay(player, words, param)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto Loot commands (items are automatically moved to your bp if you open a monster corpse):"
            .. '\n' .. "!autoloot add, itemName - add item to auto loot by name"
            .. '\n' .. "!autoloot remove, itemName - remove item from auto loot by name"
            .. '\n' .. "!autoloot list - list your current auto loot items")
	return false
end
