local outfitMale = 604 -- Outfit Assassin

function onUse(cid, item, frompos, item2, topos)
 
	if item.uid == 22052 then
		if ( getPlayerStorageValue(cid,1235) == -1 ) then
		 doPlayerSendTextMessage(cid,21,"Voce ganhou uma Outfit")
		 doPlayerAddOutfit(cid, outfitMale, 1)
		 setPlayerStorageValue(cid,1235,1)
		 doSendMagicEffect(getCreaturePosition(cid), math.random(1, 67))
		else
			doPlayerSendTextMessage(cid,25,"Voce ja tem essa Outfit.")
		end
	end
	return TRUE
end