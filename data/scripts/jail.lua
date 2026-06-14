--[[
	Jail System - KarmaOT
	Comando: /jail <player name>
	
	Punições aplicadas:
	- Teleporta para a cadeia (32356, 32208, 7)
	- Remove 10% da experiência total
	- Remove 10% do gold no banco
	
	Sistema de tempo:
	- ONLINE: 16 horas de tempo jogado (conta apenas quando online)
	- OFFLINE: 5 dias corridos (120 horas de tempo real)
	- Ao liberar: teleporta para Thais (32369, 32241, 7)
]]

local config = {
	jailPosition = Position(32356, 32208, 7),
	thaisTemplePosition = Position(32369, 32241, 7),
	expPenalty = 0.10,           -- 10% de perda de exp
	bankPenalty = 0.10,          -- 10% de perda de gold no banco
	onlineTimeRequired = 57600,  -- 16 horas em segundos (16 * 3600)
	offlineTimeRequired = 432000, -- 5 dias em segundos (5 * 24 * 3600)
	storageJailOnlineTime = 55500, -- Storage para tempo online acumulado
	storageJailStartTime = 55501   -- Storage para timestamp de início (offline)
}

local jail = TalkAction("/jail")

function jail.onSay(player, words, param)
	-- Verifica se é GM/ADM
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	-- Parse do comando: /jail <player name>
	if param == "" then
		player:sendCancelMessage("Usage: /jail <player name>")
		player:sendCancelMessage("Example: /jail Player Name")
		return false
	end

	local targetName = param:trim()

	-- Busca o player alvo
	local target = Player(targetName)
	if not target then
		player:sendCancelMessage(string.format("Player '%s' is not online.", targetName))
		return false
	end

	-- Não pode prender outro GM/ADM
	if target:getGroup():getAccess() then
		player:sendCancelMessage("You cannot jail staff members.")
		return false
	end

	-- ========== APLICAR PUNIÇÕES ==========
	
	-- 1. Calcular perdas
	local currentExp = target:getExperience()
	local expLoss = math.floor(currentExp * config.expPenalty)
	
	local bankBalance = target:getBankBalance()
	local goldLoss = math.floor(bankBalance * config.bankPenalty)

	-- 2. Aplicar perdas
	target:removeExperience(expLoss)
	target:setBankBalance(math.max(0, bankBalance - goldLoss))

	-- 3. Inicializar storages de prisão
	target:setStorageValue(config.storageJailOnlineTime, 0) -- Começa com 0 segundos online
	target:setStorageValue(config.storageJailStartTime, os.time()) -- Marca timestamp de início

	-- 4. Teleportar para a cadeia (GlobalEvent vai contar tempo automaticamente)
	local oldPos = target:getPosition()
	target:teleportTo(config.jailPosition)
	target:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	-- ========== MENSAGENS ==========

	-- Mensagem para o player preso
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "========== YOU HAVE BEEN JAILED ==========")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "ONLINE: 16 hours of playtime required")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "OFFLINE: 5 days (120 hours) real time")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Experience lost: %s (-%d%%)", 
		formatNumber(expLoss), config.expPenalty * 100))
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Bank gold lost: %s (-%d%%)", 
		formatNumber(goldLoss), config.bankPenalty * 100))
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use /jailtime to check your progress.")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "==========================================")

	-- Mensagem para o GM
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("[JAIL] Player '%s' has been jailed.", target:getName()))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("[JAIL] Penalties: -%s exp, -%s gold", formatNumber(expLoss), formatNumber(goldLoss)))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		"[JAIL] Time: 16h online OR 5 days offline")

	-- Log para o servidor
	print(string.format("[JAIL SYSTEM] %s jailed %s (Position: %d,%d,%d -> %d,%d,%d) | Penalties: -%s exp, -%s gold | Time: 16h online OR 5 days offline",
		player:getName(), target:getName(), 
		oldPos.x, oldPos.y, oldPos.z,
		config.jailPosition.x, config.jailPosition.y, config.jailPosition.z,
		formatNumber(expLoss), formatNumber(goldLoss)))

	-- Broadcast
	Game.broadcastMessage(string.format("%s has been jailed!", target:getName()), 
		MESSAGE_STATUS_WARNING)

	return false
end

jail:separator(" ")
jail:register()

-- ========== HELPER: Formatar números ==========
function formatNumber(n)
	if n >= 1000000 then
		return string.format("%.2fkk", n / 1000000)
	elseif n >= 1000 then
		return string.format("%.1fk", n / 1000)
	else
		return tostring(n)
	end
end

-- ========== COMANDO PARA VERIFICAR TEMPO DE PRISÃO ==========
local jailTime = TalkAction("/jailtime")

function jailTime.onSay(player, words, param)
	local onlineTime = player:getStorageValue(config.storageJailOnlineTime)
	local startTime = player:getStorageValue(config.storageJailStartTime)
	
	if onlineTime < 0 or startTime < 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are not jailed.")
		return false
	end

	-- Calcula progresso ONLINE (em horas)
	local onlineHours = math.floor(onlineTime / 3600)
	local onlineMinutes = math.floor((onlineTime % 3600) / 60)
	local onlineProgress = (onlineTime / config.onlineTimeRequired) * 100
	
	-- Calcula progresso OFFLINE (em dias/horas)
	local offlineElapsed = os.time() - startTime
	local offlineDays = math.floor(offlineElapsed / 86400)
	local offlineHours = math.floor((offlineElapsed % 86400) / 3600)
	local offlineProgress = (offlineElapsed / config.offlineTimeRequired) * 100

	-- Mensagens
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "========== JAIL TIME ==========")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("ONLINE: %dh %dmin / 16h (%.1f%%)", onlineHours, onlineMinutes, onlineProgress))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("OFFLINE: %dd %dh / 5d (%.1f%%)", offlineDays, offlineHours, offlineProgress))
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "===============================")
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Complete EITHER time requirement to be freed!")

	return false
end

jailTime:separator(" ")
jailTime:register()

-- ========== COMANDO PARA LIBERTAR PLAYER ==========
local unjail = TalkAction("/unjail")

function unjail.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You don't have permission to use this command.")
		return false
	end

	if param == "" then
		player:sendCancelMessage("Usage: /unjail <player name>")
		return false
	end

	local target = Player(param)
	if not target then
		player:sendCancelMessage(string.format("Player '%s' is not online.", param))
		return false
	end

	local onlineTime = target:getStorageValue(config.storageJailOnlineTime)
	local startTime = target:getStorageValue(config.storageJailStartTime)
	
	if onlineTime < 0 or startTime < 0 then
		player:sendCancelMessage(string.format("%s is not jailed.", target:getName()))
		return false
	end

	-- Liberar
	target:setStorageValue(config.storageJailOnlineTime, -1)
	target:setStorageValue(config.storageJailStartTime, -1)
	
	-- Teleportar para Thais
	target:teleportTo(config.thaisTemplePosition)
	target:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been released from jail by a Game Master!")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been teleported to Thais Temple.")

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
		string.format("[JAIL] Player '%s' has been released and teleported to Thais.", target:getName()))

	print(string.format("[JAIL SYSTEM] %s released %s from jail (manual release by GM).", 
		player:getName(), target:getName()))

	return false
end

unjail:separator(" ")
unjail:register()

