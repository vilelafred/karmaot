-- Variável global para rastrear o índice do próximo jogador
local nextPlayerIndex = 1

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	-- Se não houver parâmetro, navega para o próximo jogador
	if param == "" then
		local players = Game.getPlayers()
		if #players == 0 then
			player:sendCancelMessage("Não há jogadores online.")
			return false
		end

		-- Ajusta o índice se exceder o número de jogadores
		if nextPlayerIndex > #players then
			nextPlayerIndex = 1
		end

		local targetPlayer = players[nextPlayerIndex]
		if targetPlayer and targetPlayer:getId() ~= player:getId() then
			player:teleportTo(targetPlayer:getPosition())
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Teleportado para: " .. targetPlayer:getName() .. " (" .. nextPlayerIndex .. "/" .. #players .. ")")
			nextPlayerIndex = nextPlayerIndex + 1
		else
			-- Se o jogador atual for o alvo, pula para o próximo
			nextPlayerIndex = nextPlayerIndex + 1
			if nextPlayerIndex > #players then
				nextPlayerIndex = 1
			end
			local nextTarget = players[nextPlayerIndex]
			player:teleportTo(nextTarget:getPosition())
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Teleportado para: " .. nextTarget:getName() .. " (" .. nextPlayerIndex .. "/" .. #players .. ")")
			nextPlayerIndex = nextPlayerIndex + 1
		end
	else
		-- Comportamento original: teleportar para um jogador específico
		local target = Creature(param)
		if target then
			player:teleportTo(target:getPosition())
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Teleportado para: " .. target:getName())
		else
			player:sendCancelMessage("Criatura não encontrada.")
		end
	end
	return false
end
