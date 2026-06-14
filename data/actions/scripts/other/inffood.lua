local foods = {
	[7731] = {30, "Hummmmmm..."}, -- carrot
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local food = foods[item.itemid]
	if not food then
		return false
	end

	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (food[1] * 12)) >= 1200 then
		player:sendCancelMessage("You are full.")
		return false
	else
		player:feed(food[1] * 60)
		player:say(food[2], TALKTYPE_MONSTER_SAY)
	end
	return true
end
