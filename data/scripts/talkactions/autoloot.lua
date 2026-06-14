local text = 'Autoloot Commands\n!autoloot add, (ItemName)   -Adding Items\n!autoloot show   -list with autolooting items\n!autoloot clear   -clears autoloot list\n!autoloot remove, (ItemName)   -Removing from autoloot list'
local talkaction = TalkAction("!autoloot")
function talkaction.onSay(player, words, param)
    local split = param:split(", ")
 
    local action = split[1]
    if action == "add" then
        local item = split[2]
        local itemType = ItemType(item)
		if not itemType then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "There is no item with that id or name.")
			return false
		end
        if itemType:getId() == 0 then
            itemType = ItemType(tonumber(item))
            if itemType then
            if itemType:getId() == 0 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "There is no item with that id or name.")
                return false
            end
            end
        end
 
        local itemName = tonumber(split[2]) and itemType:getName() or item
        local size = 0
		local extraUnlocked = math.max(0, player:getStorageValue(AUTOLOOT_EXTRA_UNLOCKED))
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            local storage = player:getStorageValue(i)
            if size >= AUTO_LOOT_MAX_ITEMS then
				if extraUnlocked + AUTO_LOOT_MAX_ITEMS == size then
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The list is full, you can buy extra slots from store.")
					break
				end
				if size == AUTO_LOOT_MAX_ITEMS + AUTO_LOOT_MAX_EXTRA then
					player:sendCancelMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This list is full, please remove an item from the list to add new one.")
					break
				end
            end
 
            if storage == itemType:getId() then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .." is already in the list.")
                break
            end
 
            if storage <= 0 then
                player:setStorageValue(i, itemType:getId())
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .." has been added to the list.")
                break
            end
 
            size = size + 1
        end
    elseif action == "remove" then
        local item = split[2]
        local itemType = ItemType(item)
		if itemType then
		   if itemType:getId() == 0 then
				itemType = ItemType(tonumber(item))
				if itemType:getId() == 0 then
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "There is no item with that id or name.")
					return false
				end
			end
		end
 
        local itemName = tonumber(split[2]) and itemType:getName() or item
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            if player:getStorageValue(i) == itemType:getId() then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .." has been removed from the list.")
                player:setStorageValue(i, 0)
                return false
            end
        end
 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, itemName .." was not founded in the list.")
    elseif action == "show" then
        local text = "-- Auto Loot List --\n"
        local count = 1
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            local storage = player:getStorageValue(i)
            if storage > 0 then
                text = string.format("%s%d. %s\n", text, count, ItemType(storage):getName())
                count = count + 1
            end
        end
 
        if text == "" then
            text = "Empty"
        end
 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
    elseif action == "clear" then
        for i = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
            player:setStorageValue(i, 0)
        end
 
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The autoloot list has been cleared.")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use the commands: !autoloot {add, remove, show, clear}")
        player:showTextDialog(2160, text)
    end
 
    return false
end
talkaction:separator(" ")
talkaction:register()


local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local extraUnlocked = player:getStorageValue(AUTOLOOT_EXTRA_UNLOCKED)
	if extraUnlocked < 0 then
		player:setStorageValue(AUTOLOOT_EXTRA_UNLOCKED, 0)
		extraUnlocked = 0
	elseif extraUnlocked == 5 then
		player:sendCancelMessage("You already unlocked the maximum extra 5 autoloot slots.")
		return false
	end
	item:remove(1)
	player:setStorageValue(AUTOLOOT_EXTRA_UNLOCKED, extraUnlocked + 1)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have successfully unlocked new extra autoloot slot! [Total Unlocked: ".. extraUnlocked + 1 .."]")
	return true
end

action:id(7727)
action:register()