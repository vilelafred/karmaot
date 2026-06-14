-- KarmaOT - Speed Balancer (PvP Balance)
-- Objetivo: Reduzir speed excessiva dos high levels para melhorar PvP
-- Aplica CONDITION_HASTE negativo para reduzir speed base

local SPEED_BALANCER_SUBID = 424243 -- SubID exclusivo
local SPEED_CURVE_SUBID = 424242 -- speed_curve.lua (legado)
local MAX_ALLOWED_SPEED = 1500 -- Speed maxima permitida (cap final)
local SPEED_REDUCTION_START_LEVEL = 1 -- TODOS os levels sao afetados

local function normalizeNegativeSpeed(player)
	local delta = player:getSpeed() - player:getBaseSpeed()
	if delta < 0 then
		player:changeSpeed(-delta)
	end
end

local function clearScriptedSpeedDebuffs(player)
	player:removeCondition(CONDITION_HASTE, CONDITIONID_COMBAT, SPEED_BALANCER_SUBID)
	player:removeCondition(CONDITION_HASTE, CONDITIONID_COMBAT, SPEED_CURVE_SUBID)
	normalizeNegativeSpeed(player)
end

-- Funcao para calcular speed alvo progressiva
-- Level 300 -> 700 speed (começa a reduzir - mais agressivo)
-- Level 600 -> 850 speed
-- Level 1000 -> 1100 speed
-- Level 1400 -> 1350 speed
-- Level 2000+ -> 1500 speed (cap max)
local function getTargetSpeed(level)
	if level < 300 then
		-- Levels 1-300: velocidade base normal (220 + 2*level)
		-- Nao aplica cap
		--print(string.format("[Speed Balancer] Level %d -> Target Speed: 0 (below 300, no cap)", level))
		return 0
	elseif level < 600 then
		-- Level 300-600: progressao de 700 a 850 (mais lento nos baixos)
		local progress = (level - 300) / 300 -- 0.0 a 1.0
		local speed = 700 + (progress * 150) -- 700 a 850
		--print(string.format("[Speed Balancer] Level %d -> Target Speed: %.0f (progress: %.2f)", level, speed, progress))
		return speed
	elseif level < 1000 then
		-- Level 600-1000: progressao de 850 a 1100
		local progress = (level - 600) / 400 -- 0.0 a 1.0
		local speed = 850 + (progress * 250) -- 850 a 1100
		--print(string.format("[Speed Balancer] Level %d -> Target Speed: %.0f (progress: %.2f)", level, speed, progress))
		return speed
	elseif level < 1400 then
		-- Level 1000-1400: progressao de 1100 a 1350
		local progress = (level - 1000) / 400 -- 0.0 a 1.0
		local speed = 1100 + (progress * 250) -- 1100 a 1350
		--print(string.format("[Speed Balancer] Level %d -> Target Speed: %.0f (progress: %.2f)", level, speed, progress))
		return speed
	else
		-- Level 1400+: progressao de 1350 a 1500
		local progress = math.min(1.0, (level - 1400) / 600) -- max 1.0 at level 2000
		local speed = 1350 + (progress * 150) -- 1350 a 1500
		--print(string.format("[Speed Balancer] Level %d -> Target Speed: %.0f (progress: %.2f)", level, speed, progress))
		return speed
	end
end

-- Funcao para calcular quanto precisa reduzir
local function calculateSpeedReduction(level, baseSpeed)
	-- Speed alvo baseado no level (progressivo)
	local targetSpeed = getTargetSpeed(level)
	--print(string.format("[Speed Balancer] calculateSpeedReduction: level=%d baseSpeed=%d targetSpeed=%d", level, baseSpeed, targetSpeed))
	
	-- Se targetSpeed é 0 (level abaixo de 300), nao reduz
	if targetSpeed == 0 then
		--print("[Speed Balancer] targetSpeed == 0 (level below 300), returning 0")
		return 0
	end
	
	-- Se o player tem menos que o alvo, nao reduz
	if baseSpeed <= targetSpeed then
		--print("[Speed Balancer] baseSpeed <= targetSpeed, returning 0")
		return 0
	end
	
	-- Calcula quanto precisa reduzir (negativo para CONDITION_HASTE)
	local reductionNeeded = baseSpeed - targetSpeed
	--print(string.format("[Speed Balancer] reductionNeeded = %d, returning %d", reductionNeeded, -reductionNeeded))
	
	return -reductionNeeded
end

-- Aplicar balanceador de speed
local function applySpeedBalancer(player)
	--print("[Speed Balancer] ==============================================")
	--print(string.format("[Speed Balancer] Checking player: %s", player:getName()))
	
	if not player or not player:isPlayer() then
		--print("[Speed Balancer] ERROR: Not a valid player!")
		return
	end
	
	-- Staff/God: nao aplica cap PvP, mas limpa debuffs acumulados de relogs antigos
	if player:getGroup():getAccess() then
		clearScriptedSpeedDebuffs(player)
		return
	end
	
	local level = player:getLevel()
	--print(string.format("[Speed Balancer] Player level: %d", level))
	
	-- Remove debuffs deste script antes de recalcular
	player:removeCondition(CONDITION_HASTE, CONDITIONID_COMBAT, SPEED_BALANCER_SUBID)
	player:removeCondition(CONDITION_HASTE, CONDITIONID_COMBAT, SPEED_CURVE_SUBID)
	
	-- Pega speed BASE do player (sem bonuses de itens/hastes)
	local baseSpeed = player:getBaseSpeed()
	--print(string.format("[Speed Balancer] Base speed: %d", baseSpeed))
	
	-- Calcula reducao necessaria baseado na speed base
	local speedAdjustment = calculateSpeedReduction(level, baseSpeed)
	--print(string.format("[Speed Balancer] Speed adjustment needed: %d", speedAdjustment))
	
	-- Protecao: nao aplica se nao houver reducao necessaria
	if speedAdjustment == 0 or speedAdjustment >= 0 then
		--print(string.format("[Speed Balancer] No adjustment needed (base speed already <= target)"))
		return
	end
	
	-- Aplica condition de reducao de speed
	local cond = Condition(CONDITION_HASTE)
	cond:setParameter(CONDITION_PARAM_TICKS, -1) -- permanente
	cond:setParameter(CONDITION_PARAM_SUBID, SPEED_BALANCER_SUBID)
	cond:setParameter(CONDITION_PARAM_SPEED, speedAdjustment)
	cond:setParameter(CONDITION_PARAM_BUFF_SPELL, false) -- nao aparece no buff bar
	player:addCondition(cond)
	
	-- Debug log
	--print(string.format("[Speed Balancer] APPLIED! Base speed %d -> Target: %d (reduction: %d)", 
		--baseSpeed, baseSpeed + speedAdjustment, math.abs(speedAdjustment)))
	
	--print("[Speed Balancer] ==============================================")
end

-- Aplicar ao logar
function onLogin(player)
	--print(string.format("[Speed Balancer] onLogin triggered for: %s", player:getName()))
	addEvent(function()
		if Player(player:getId()) then
			applySpeedBalancer(player)
		end
	end, 1000)
	return true
end

-- Aplicar ao upar level
function onAdvance(player, skill, oldLevel, newLevel)
	if skill == SKILL_LEVEL and newLevel > oldLevel then
		--print(string.format("[Speed Balancer] onAdvance triggered for: %s (level %d -> %d)", player:getName(), oldLevel, newLevel))
		addEvent(function()
			local p = Player(player:getId())
			if p then
				applySpeedBalancer(p)
			end
		end, 1000)
	end
	return true
end


