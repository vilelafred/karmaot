function onSay(cid, words, param)
	local player = Player(cid)
	if getPlayerVipPoints(cid) >= 15 then
	doPlayerRemoveVipPoints(cid, 15)
	player:aaddItem(5118, 1)
	changePpts(cid)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have received Green Djinn Scroll from the NptOld Online. Please logout so your character can save.")
	else
	player:sendCancelMessage("You do not have enough points!")
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
return false
end
