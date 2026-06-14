local arbalestChest = Action()

local chestId = 8066
local rewardItem = 6110 -- Arbalest
local rewardStorage = 8713 -- storage exclusivo desse baú

function arbalestChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= chestId then
		return false
	end

	if player:getStorageValue(rewardStorage) == 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already claimed your powerful reward.")
		return true
	end

	player:addItem(rewardItem, 1)
	player:setStorageValue(rewardStorage, 1)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have claimed the mighty Arbalest! May your shots strike true!")

	return true
end

arbalestChest:aid(1741) -- usar outro actionid para evitar conflito com o baú da Warlord
arbalestChest:register()
