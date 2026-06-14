function onUse(cid, item, frompos, item2, topos)

         if item.uid == 12001 then
             if (getPlayerStorageValue(cid,12010) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Hunter Outfit!")
		doPlayerAddOutfitId(cid,480,0)
		setPlayerStorageValue(cid,12010,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Hunter Outfit.")
end

       elseif item.uid == 12002 then
              if (getPlayerStorageValue(cid,12011) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Mage Outfit!")
		doPlayerAddOutfitId(cid,481,0)
		setPlayerStorageValue(cid,12011,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Mage Outfit.")
end

       elseif item.uid == 12003 then
              if (getPlayerStorageValue(cid,12012) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Knight Outfit!")
		doPlayerAddOutfitId(cid,482,0)
		setPlayerStorageValue(cid,12012,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Knight Outfit.")
	end


    elseif item.uid == 12004 then
           if (getPlayerStorageValue(cid,12013) == -1) and getPlayerSex(cid) == 1 then
		doPlayerSendTextMessage(cid,21,"You now have the Nobleman Outfit!")
		doPlayerAddOutfitId(cid,4,0)
		setPlayerStorageValue(cid,12013,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
        	else if(getPlayerStorageValue(cid,12013) == -1) and getPlayerSex(cid) == 0 then
        	doPlayerSendTextMessage(cid,21,"You now have the Noblewoman Outfit!")
		doPlayerAddOutfitId(cid,5,0)
		setPlayerStorageValue(cid,12013,1)
    	else
		doPlayerSendTextMessage(cid,25,"You Already have this outfit.")		
	end
	   end

   
   elseif item.uid == 12005 then
	if (getPlayerStorageValue(cid,12014) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Summoner Outfit!")
		doPlayerAddOutfitId(cid,483,0)
		setPlayerStorageValue(cid,12014,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Summoner Outfit.")
	end

   elseif item.uid == 12006 then
          if (getPlayerStorageValue(cid,12015) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Warrior Outfit!")
		doPlayerAddOutfitId(cid,484,0)
		setPlayerStorageValue(cid,12015,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Warrior Outfit.")
	end

   elseif item.uid == 12007 then
          if (getPlayerStorageValue(cid,12016) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Barbarian Outfit!")
		doPlayerAddOutfitId(cid,485,0)
		setPlayerStorageValue(cid,12016,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Barbarian Outfit.")
	end

   elseif item.uid == 12008 then
          if (getPlayerStorageValue(cid,12017) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Druid Outfit!")
		doPlayerAddOutfitId(cid,486,0)
		setPlayerStorageValue(cid,12017,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Druid Outfit.")
	end

   elseif item.uid == 12009 then
          if (getPlayerStorageValue(cid,12018) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Wizard Outfit!")
		doPlayerAddOutfitId(cid,487,0)
		setPlayerStorageValue(cid,12018,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Wizard Outfit.")
	end

   elseif item.uid == 12010 then
          if (getPlayerStorageValue(cid,12019) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Oriental Outfit!")
		doPlayerAddOutfitId(cid,488,0)
		setPlayerStorageValue(cid,12019,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Oriental Outfit.")
	end

   elseif item.uid == 12011 then
          if (getPlayerStorageValue(cid,12020) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Pirate Outfit!")
		doPlayerAddOutfitId(cid,489,0)
		setPlayerStorageValue(cid,12020,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Pirate Outfit.")
	end

   elseif item.uid == 12012 then
          if (getPlayerStorageValue(cid,12021) == -1) then
		doPlayerSendTextMessage(cid,21,"You now have the Assassin Outfit!")
		doPlayerAddOutfitId(cid,490,0)
		setPlayerStorageValue(cid,12021,1)
        	doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
    	else
		doPlayerSendTextMessage(cid,25,"You Already have the Assassin Outfit.")
	end

    end
	return TRUE
end