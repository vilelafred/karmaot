local warlordChest = Action()

local chestId = 8066
local rewardItem = 2408 -- Warlord Sword
local rewardStorage = 8711 -- storage exclusivo desse baú

function warlordChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= chestId then
		return false
	end

	if player:getStorageValue(rewardStorage) == 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already claimed your legendary reward.")
		return true
	end

	player:addItem(rewardItem, 1)
	player:setStorageValue(rewardStorage, 1)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have claimed the legendary Warlord Sword! May it serve you well in battle!")

	return true
end

warlordChest:aid(1740) -- você pode usar actionid se preferir, ou trocar por itemid(1740)
warlordChest:register()
