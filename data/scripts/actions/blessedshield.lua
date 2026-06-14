local arcaneChest = Action()

local chestId = 1740
local rewardItem = 2523 -- Arcane Staff
local rewardStorage = 8720 -- storage exclusivo desse baú

function arcaneChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= chestId then
		return false
	end

	if player:getStorageValue(rewardStorage) == 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already claimed your magical reward.")
		return true
	end

	player:addItem(rewardItem, 1)
	player:setStorageValue(rewardStorage, 1)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have claimed the mystical Blessed Shield! Let the energy flow through you!")

	return true
end

arcaneChest:aid(1745) -- actionid exclusivo para esse baú
arcaneChest:register()
