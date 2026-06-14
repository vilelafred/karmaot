function onSay(cid, words, param)
	local player = Player(cid)
	if param == "" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você precisa escolher um valor (7,15,30,60) exemplo: !premium 60")
	--	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "[TESTSYSTEM-HENRIQUE] Você tem ".. player:getPremiumDays() .." dias de premium!")
	elseif param == "7" then
		if getPlayerVipPoints(cid) >= 4 then
			doPlayerRemoveVipPoints(cid, 4)
			player:addItem(5114, 1)
			changePpts(cid)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have received Premium Scroll 7 Days from the NptOld Online. Please logout so your character can save.")
		else
			player:sendCancelMessage("You do not have enough points!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif param == "15" then
		if getPlayerVipPoints(cid) >= 7 then
			doPlayerRemoveVipPoints(cid, 7)
			player:addItem(5115, 1)
			changePpts(cid)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have received Premium Scroll 15 Days from the NptOld Online. Please logout so your character can save.")
		else
			player:sendCancelMessage("You do not have enough points!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif param == "30" then
		if getPlayerVipPoints(cid) >= 15 then
			doPlayerRemoveVipPoints(cid, 15)
			player:addItem(5116, 1)
			changePpts(cid)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have received Premium Scroll 30 Days from the NptOld Online. Please logout so your character can save.")
		else
			player:sendCancelMessage("You do not have enough points!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	elseif param == "60" then
		if getPlayerVipPoints(cid) >= 25 then
			doPlayerRemoveVipPoints(cid, 25)
			player:addItem(5117, 1)
			changePpts(cid)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have received Premium Scroll 60 Days from the NptOld Online. Please logout so your character can save.")
		else
			player:sendCancelMessage("You do not have enough points!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	end
	return false
end			

