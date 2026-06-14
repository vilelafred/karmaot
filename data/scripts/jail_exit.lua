--[[
	Jail Time Tracker System - KarmaOT
	
	Sistema de contagem de tempo:
	- Conta tempo ONLINE (16 horas jogadas)
	- Conta tempo OFFLINE (5 dias corridos)
	- Libera automaticamente quando atingir qualquer um dos requisitos
	- Teleporta para Thais ao liberar
]]

local config = {
	jailPosition = Position(32356, 32208, 7),
	thaisTemplePosition = Position(32369, 32241, 7),
	onlineTimeRequired = 57600,    -- 16 horas em segundos (16 * 3600)
	offlineTimeRequired = 432000,  -- 5 dias em segundos (5 * 24 * 3600)
	storageJailOnlineTime = 55500, -- Storage para tempo online acumulado
	storageJailStartTime = 55501,  -- Storage para timestamp de início
	updateInterval = 60            -- Atualiza a cada 60 segundos
}

-- ========== HELPER: Verifica se player deve ser liberado ==========
local function checkAndReleasePlayer(player)
	local onlineTime = player:getStorageValue(config.storageJailOnlineTime)
	local startTime = player:getStorageValue(config.storageJailStartTime)
	
	if onlineTime < 0 or startTime < 0 then
		return false -- Não está preso
	end

	local now = os.time()
	local offlineElapsed = now - startTime
	
	-- Verifica se completou 16h online OU 5 dias offline
	if onlineTime >= config.onlineTimeRequired or offlineElapsed >= config.offlineTimeRequired then
		-- LIBERAR PLAYER
		player:setStorageValue(config.storageJailOnlineTime, -1)
		player:setStorageValue(config.storageJailStartTime, -1)
		
		-- Teleportar para Thais
		player:teleportTo(config.thaisTemplePosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		
		-- Mensagens
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "========== RELEASED FROM JAIL ==========")
		if onlineTime >= config.onlineTimeRequired then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You completed 16 hours of online time!")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You completed 5 days of offline time!")
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to Thais Temple.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Don't break the rules again!")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "========================================")
		
		-- Log
		print(string.format("[JAIL SYSTEM] %s has been released from jail (Online: %dh, Offline: %dd)",
			player:getName(), math.floor(onlineTime / 3600), math.floor(offlineElapsed / 86400)))
		
		return true
	end
	
	return false
end

-- ========== LOGIN: Verifica se deve liberar e registra contador ==========
local jailLoginCheck = CreatureEvent("JailLoginCheck")

function jailLoginCheck.onLogin(player)
	local onlineTime = player:getStorageValue(config.storageJailOnlineTime)
	local startTime = player:getStorageValue(config.storageJailStartTime)
	
	if onlineTime < 0 or startTime < 0 then
		return true -- Não está preso
	end

	-- Verifica se deve ser liberado
	if checkAndReleasePlayer(player) then
		return true -- Foi liberado
	end

	-- Ainda está preso - teleportar de volta para a cadeia se estiver fora
	local currentPos = player:getPosition()
	if currentPos.x ~= config.jailPosition.x or 
	   currentPos.y ~= config.jailPosition.y or 
	   currentPos.z ~= config.jailPosition.z then
		player:teleportTo(config.jailPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	
	-- Mensagem de status
	local now = os.time()
	local offlineElapsed = now - startTime
	local onlineHours = math.floor(onlineTime / 3600)
	local offlineDays = math.floor(offlineElapsed / 86400)
	
	player:sendTextMessage(MESSAGE_STATUS_WARNING, "You are still in jail!")
	player:sendTextMessage(MESSAGE_STATUS_WARNING, 
		string.format("Progress: %dh online / %dd offline", onlineHours, offlineDays))
	player:sendTextMessage(MESSAGE_STATUS_WARNING, "Use /jailtime to check your progress.")

	return true
end

jailLoginCheck:register()

-- ========== GLOBALEVENT: Conta tempo online de todos os presos ==========
local jailTimeCounter = GlobalEvent("JailTimeCounter")

function jailTimeCounter.onThink(interval)
	-- Percorre todos os players online
	for _, player in ipairs(Game.getPlayers()) do
		local onlineTime = player:getStorageValue(config.storageJailOnlineTime)
		local startTime = player:getStorageValue(config.storageJailStartTime)
		
		if onlineTime >= 0 and startTime >= 0 then
			-- Player está preso, incrementa tempo
			local incrementSeconds = interval / 1000 -- GlobalEvent interval já é em ms
			local newOnlineTime = onlineTime + incrementSeconds
			player:setStorageValue(config.storageJailOnlineTime, newOnlineTime)

			-- Verifica se deve ser liberado
			checkAndReleasePlayer(player)
		end
	end
	return true
end

jailTimeCounter:interval(1000) -- A cada 1 segundo
jailTimeCounter:register()

