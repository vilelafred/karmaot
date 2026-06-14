-- Ultimate Healing Rune como Action (ID: 6675)
-- Tabela para controlar cooldown rigoroso
local playerCooldowns = {}
local COOLDOWN_TIME = 1000 -- 1 segundo

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end

	local playerId = player:getId()
	local currentTime = os.time() * 1000 + os.clock() * 1000 -- Tempo mais preciso

	-- Verifica se está em cooldown - bloqueio rígido
	if playerCooldowns[playerId] then
		if currentTime < playerCooldowns[playerId] then
			-- Bloqueia silenciosamente para evitar spam
			return true
		else
			-- Remove o cooldown expirado
			playerCooldowns[playerId] = nil
		end
	end

	-- Aplica o cooldown ANTES de executar qualquer coisa
	playerCooldowns[playerId] = currentTime + COOLDOWN_TIME

	-- Calcula a cura
	local level = player:getLevel()
	local magicLevel = player:getMagicLevel()
	local vocation = player:getVocation():getId()
	
	local base = 250
	-- Se for Knight (4) ou Elite Knight (8), aumenta o base da cura
	if vocation == 4 or vocation == 8 then
		base = 310
	end

	local min = math.max(base, ((3 * magicLevel + 2 * level) * base / 100))
	local max = math.floor(min * 1.15) -- +15% do min
	
	-- Calcula o valor final da cura
	local healValue = math.random(min, max)

	-- Define o target (se não tiver target, usa o próprio player)
	local targetPlayer = target and target:isPlayer() and target or player

	-- Verifica se pode curar o target
	if not targetPlayer then
		player:sendCancelMessage("You can only use this on players.")
		playerCooldowns[playerId] = nil -- Remove cooldown em caso de erro
		return true
	end

	-- Aplica a cura
	targetPlayer:addHealth(healValue)
	
	-- Efeitos visuais
	targetPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	-- Remove paralyze se tiver
	targetPlayer:removeCondition(CONDITION_PARALYZE)

	-- Consome a runa
	item:remove(1)

	return true
end
