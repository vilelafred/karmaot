function onUse(cid, item, fromPosition, itemEx, toPosition)
	-- Item ID and Uniqueid --
	switchUniqueID = 40999
	switchID = 1945
	switch2ID = 1946
	swordID	= 5934
	crossbowID = 5909
	appleID	= 5940
	spellbookID	= 5917

	-- Level para fazer a quest --
	questlevel = 120

	piece1pos = {x=33395, y=31543, z=11, stackpos=1}
	getpiece1 = getThingfromPos(piece1pos)
 
	piece2pos = {x=33395, y=31546, z=11, stackpos=1}
	getpiece2 = getThingfromPos(piece2pos)
 
	piece3pos = {x=33399, y=31546, z=11, stackpos=1}
	getpiece3 = getThingfromPos(piece3pos)
 
	piece4pos = {x=33399, y=31543, z=11, stackpos=1}
	getpiece4 = getThingfromPos(piece4pos)

	player1pos = {x=33405, y=31553, z=11, stackpos=253}
	player1 = getThingfromPos(player1pos)
	player2pos = {x=33404, y=31553, z=11, stackpos=253}
	player2 = getThingfromPos(player2pos)
	player3pos = {x=33403, y=31553, z=11, stackpos=253}
	player3 = getThingfromPos(player3pos)
	player4pos = {x=33402, y=31553, z=11, stackpos=253}
	player4 = getThingfromPos(player4pos)

	nplayer1pos = {x=33400, y=31577, z=11}
	nplayer2pos = {x=33399, y=31577, z=11}
	nplayer3pos = {x=33399, y=31578, z=11}
	nplayer4pos = {x=33399, y=31576, z=11}

	-- Permitir de 2 a 4 jogadores
	if item.uid == switchUniqueID then
		if item.itemid == switchID then
			-- Verifica itens corretos nas bacias
			if getpiece1.itemid == swordID and getpiece2.itemid == crossbowID and getpiece3.itemid == appleID and getpiece4.itemid == spellbookID then
				local starts = {player1pos, player2pos, player3pos, player4pos}
				local dests = {nplayer1pos, nplayer2pos, nplayer3pos, nplayer4pos}
				local presentPlayers = {}
				local levelsOk = true
				for i = 1, 4 do
					local creature = getThingfromPos(starts[i])
					if creature.itemid > 0 then
						table.insert(presentPlayers, {uid = creature.uid, start = starts[i], dest = dests[i]})
						if getPlayerLevel(creature.uid) < questlevel then
							levelsOk = false
						end
					end
				end
				if #presentPlayers < 2 then
					doPlayerSendCancel(cid, "Desculpe, precisa de pelo menos 2 jogadores nas posições.")
					return true
				end
				if not levelsOk then
					doPlayerSendCancel(cid, "Sorry, all players in your team must be level " .. questlevel .. ".")
					return true
				end
				for _, p in ipairs(presentPlayers) do
					doSendMagicEffect(p.start, 2)
					doTeleportThing(p.uid, p.dest)
					doSendMagicEffect(p.dest, 10)
				end
				doRemoveItem(getpiece1.uid,1)
				doRemoveItem(getpiece2.uid,1)
				doRemoveItem(getpiece3.uid,1)
				doRemoveItem(getpiece4.uid,1)
				doTransformItem(item.uid, item.itemid+1)
			else
				doPlayerSendCancel(cid,"Sorry, you need to put the correct stuffs at the correct basins.")
			end
		elseif item.itemid == switch2ID then
			doTransformItem(item.uid, item.itemid-1)
		end
	else
		doPlayerSendCancel(cid,"Sorry, invalid switch.")
	end
	return true
end
