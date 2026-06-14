local ladder = 1386
local kitRepair = 6825
local pos = Position(32102, 32086, 8)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posPlayer = getPlayerPosition(player)
	local posTarget = target:getPosition()

	function delLadder()
		doRemoveItem(getThingfromPos({x=32102, y=32086, z=8, stackpos=1}).uid, ladder)
		target:getPosition():sendMagicEffect(14)
	end

	if posTarget == pos then
		target:getPosition():sendMagicEffect(15)
		item:remove()
		doCreateItem(ladder, 1, pos)
		addEvent(delLadder, 10000)
		return true
	else
		player:sendCancelMessage("You need select correct position.")
		doSendMagicEffect(posPlayer, 3)
		return true
	end

	return true
end
