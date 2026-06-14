function onSay(cid, words, param)
    local player = Player(cid)


	
        local time = getPlayerStorageValue(cid, 1234) - os.time()
         local hours, minutes, seconds = math.floor (time / 3600), math.floor ((time - ((math.floor (time / 3600)) * 3600))/ 60), time - ((math.floor (time/60)) * 60)
         if time >= 3600 then
             text = hours.." "..(hours > 1 and "hours" or "hour")..", "..minutes.." "..(minutes > 1 and "minutes" or "minute").." and "..seconds.." "..(seconds > 1 and "seconds" or "second")
         elseif time >= 60 then
             text = minutes.." "..(minutes > 1 and "minutes" or "minute").." and "..seconds.." "..(seconds > 1 and "seconds" or "second")
         else
             text = seconds.." "..(seconds > 1 and "seconds" or "second")
         end
		if time <= 0 then
        player:sendCancelMessage("You do not have any experience boosts active!")
		else
         if getPlayerStorageValue(cid, 1234) > 1 then
		 player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have " ..text.. " remaining until your extra experience expires.")
     end
     return true
end
end