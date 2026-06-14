local ITEM_ID = 3909 -- Ferumbras Dummy Kit

local giveDummy = TalkAction("/givedummy")

function giveDummy.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	if param == "" then
		player:sendCancelMessage("Usage: /givedummy [player name]")
		return false
	end

	local targetPlayer = Player(param)
	if not targetPlayer then
		player:sendCancelMessage("Player \"" .. param .. "\" not found or not online.")
		return false
	end

	local item = targetPlayer:addItem(ITEM_ID, 1)
	if item then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Ferumbras Dummy Kit has been given to " .. targetPlayer:getName() .. ".")
		targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have received a Ferumbras Dummy Kit from " .. player:getName() .. "!")
	else
		player:sendCancelMessage("Couldn't add the item. Inventory full?")
	end

	return false
end

giveDummy:separator(" ")
giveDummy:register()
