local rewards = {
	[14501] = {itemId = 6115, name = "Magic Armor"},         -- AID 14501
	[14502] = {itemId = 5783, name = "Red Magician Axe"},   -- AID 14502
	[14503] = {itemId = 5813, name = "Fireblade"},          -- AID 14503
	[14504] = {itemId = 6175, name = "Bow of Flame"}        -- AID 14504
}

local questStorage = 45013 -- Storage que marca se o player já pegou a recompensa

local annihilatorReward = Action()

function annihilatorReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local reward = rewards[item.actionid]
	if not reward then
		player:sendCancelMessage("This reward chest is not configured.")
		return true
	end

	if player:getStorageValue(questStorage) >= 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already claimed your reward from this quest.")
		return true
	end

	if player:addItem(reward.itemId, 1, true) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received: " .. reward.name .. "!")
		player:setStorageValue(questStorage, 1)
		fromPosition:sendMagicEffect(CONST_ME_FIREWORK_RED)
	else
		player:sendCancelMessage("You don't have enough space or capacity.")
	end
	return true
end

-- Registra todos os AIDs
for aid, _ in pairs(rewards) do
	annihilatorReward:aid(aid)
end

annihilatorReward:register()
