local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HEALING)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, 0)
setCombatParam(combat, COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
setCombatParam(combat, COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

-- Tabela para controlar cooldown rigoroso
local playerCooldowns = {}
local COOLDOWN_TIME = 1000 -- 1 segundo

function onGetFormulaValues(cid, level, maglevel)
	local vocation = getPlayerVocation(cid)
	local base = 250
	local variation = 0

	-- Se for Knight (4) ou Elite Knight (8), aumenta o base da cura
	if vocation == 4 or vocation == 8 then
		base = 310
	end

	local min = math.max((base - variation), ((3 * maglevel + 2 * level) * (base - variation) / 100))
	local max = math.floor(min * 1.25 + 0.5) -- +25% do min (apenas pra cima)

	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var)
	local player = Player(cid)
	if not player then
		return false
	end

	local playerId = player:getId()
	local currentTime = os.time() * 1000 + os.clock() * 1000 -- Tempo mais preciso

	-- Verifica se está em cooldown - bloqueio rígido
	if playerCooldowns[playerId] then
		if currentTime < playerCooldowns[playerId] then
			-- Bloqueia silenciosamente para evitar spam de mensagens
			return false
		else
			-- Remove o cooldown expirado
			playerCooldowns[playerId] = nil
		end
	end

	-- Aplica o cooldown ANTES de executar qualquer coisa
	playerCooldowns[playerId] = currentTime + COOLDOWN_TIME

	-- Executa o combat
	local result = doCombat(cid, combat, var)
	
	-- Se falhou, remove o cooldown imediatamente
	if not result then
		playerCooldowns[playerId] = nil
	end

	return result
end
