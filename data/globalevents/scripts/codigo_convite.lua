function onThink(interval, lastExecution, thinkInterval)
	local resultId = db.storeQuery(
		"SELECT ref_code.*, players.name as name_player FROM ref_code INNER JOIN players ON ref_code.player_id = players.id WHERE ref_code.entregue = 0;")

	if (resultId ~= false) then
		repeat
			local playerName = result.getDataString(resultId, "name_player")
			local player = Player(getPlayerByName(playerName))

			if player then
				local id_entrega = result.getDataInt(resultId, "id")
				local itemId = result.getDataInt(resultId, "itemid")
				local refCode = result.getDataString(resultId, "ref_code")
				--local quantidade = tonumber(result.getDataInt(resultId, "quantidade"))

				--player:addItem(tonumber(itemId), quantidade)
				player:addItem(tonumber(itemId), 1)
				db.query("UPDATE `ref_code` SET `entregue`='1' WHERE id = " .. id_entrega .. ";")
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("You received your %s code item."):format(refCode))
			end
		until not result.next(resultId)

		result.free(resultId)
	end

	return true
end
