local fromPos = {x = 32365, y = 32625, z = 3} -- z começa no andar de cima (agora inclui o andar 5)
local toPos   = {x = 32410, y = 32655, z = 7} -- z termina no andar de baixo

function onSay(player, words, param)
	local playersFound = {}

	for z = fromPos.z, toPos.z do
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				local pos = Position(x, y, z)
				local creature = Tile(pos):getTopCreature()
				if creature and creature:isPlayer() then
					if not table.contains(playersFound, creature) then
						table.insert(playersFound, creature)
					end
				end
			end
		end
	end

	if #playersFound == 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No players are currently training in the area.")
	else
		local msg = string.format("[TRAINERS] There are %d players currently training:\n", #playersFound)
		for _, p in ipairs(playersFound) do
			local voc = p:getVocation() and p:getVocation():getName() or "Unknown"
			local pos = p:getPosition()
			msg = msg .. string.format("- %s [Level %d, %s] - Pos: %d/%d/%d\n",
				p:getName(), p:getLevel(), voc, pos.x, pos.y, pos.z)
		end
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
	end

	return false
end
