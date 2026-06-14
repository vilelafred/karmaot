FakePlayerSpawn = {}

FakePlayerRuntime = {
	bots = {},
}

function FakePlayerRuntime.get(botId)
	return FakePlayerRuntime.bots[botId]
end

function FakePlayerRuntime.ensure(botId, data)
	if not FakePlayerRuntime.bots[botId] then
		FakePlayerRuntime.bots[botId] = {
			data = data,
			creatureId = nil,
			lastTargetId = nil,
			lastTargetName = nil,
			tickCounter = 0,
			walkStepsLeft = 0,
			walkDirection = nil,
			walkDest = nil,
			anchorPos = nil,
			safeSpot = nil,
		}
	end
	local rt = FakePlayerRuntime.bots[botId]
	if data then
		rt.data = data
	end
	return rt
end

function FakePlayerSpawn.isBotCreature(creature)
	if not creature then
		return false
	end
	for _, rt in pairs(FakePlayerRuntime.bots) do
		if rt.creatureId == creature:getId() then
			return true
		end
	end
	return false
end

function FakePlayerSpawn.getCreature(botId)
	local rt = FakePlayerRuntime.get(botId)
	if not rt or not rt.creatureId then
		return nil
	end
	local creature = Creature(rt.creatureId)
	if not creature or creature:isRemoved() then
		rt.creatureId = nil
		return nil
	end
	return creature
end

function FakePlayerSpawn.applyOutfit(creature, vocation)
	local outfit = FakePlayerConfig.outfits[vocation] or FakePlayerConfig.outfits[4]
	if not outfit or not creature then
		return
	end
	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit({
		lookType = outfit.lookType,
		lookHead = outfit.head,
		lookBody = outfit.body,
		lookLegs = outfit.legs,
		lookFeet = outfit.feet,
	})
	condition:setTicks(-1)
	creature:addCondition(condition)
end

function FakePlayerSpawn.updateDisplayName(creature, data)
	if not creature or not data then
		return
	end
	creature:rename(string.format("%s [Lv%d | %s]", data.name, data.level, data.state))
end

function FakePlayerSpawn.scaleHealth(creature, level)
	if not creature then
		return
	end
	local maxHealth = 185 + (level * 25)
	creature:setMaxHealth(maxHealth)
	creature:addHealth(maxHealth)
end

function FakePlayerSpawn.findSpawnPosition(basePos, index)
	local offsets = {
		{0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1},
		{1, 1}, {-1, 1}, {1, -1}, {-1, -1}, {2, 0}, {-2, 0},
	}
	local offset = offsets[((index - 1) % #offsets) + 1]
	return Position(basePos.x + offset[1], basePos.y + offset[2], basePos.z)
end

function FakePlayerSpawn.summon(botId, position)
	local data = FakePlayerDb.loadById(botId)
	if not data then
		return false, "Fake player id " .. botId .. " nao existe."
	end

	if FakePlayerSpawn.getCreature(botId) then
		return false, data.name .. " ja esta ativo."
	end

	local rt = FakePlayerRuntime.ensure(botId, data)
	local pos = position or data.position or FakePlayerConfig.spawn
	if not Tile(pos) then
		return false, "Posicao invalida."
	end

	local creature = Game.createMonster(FakePlayerConfig.monsterName, pos, false, true)
	if not creature then
		return false, "Sem espaco para spawnar " .. data.name .. "."
	end

	creature:setMaster(nil)
	creature:setIdle(false)

	data.position = creature:getPosition()
	data.creatureUid = creature:getId()
	data.state = FakePlayerState.HUNTING
	rt.data = data
	rt.creatureId = creature:getId()
	rt.lastTargetId = nil
	rt.lastTargetName = nil
	rt.tickCounter = 0
	rt.walkStepsLeft = 0
	rt.walkDest = nil
	rt.anchorPos = Position(creature:getPosition())
	rt.safeSpot = Position(data.position)

	FakePlayerSpawn.applyOutfit(creature, data.vocation)
	FakePlayerSpawn.scaleHealth(creature, data.level)
	FakePlayerSpawn.updateDisplayName(creature, data)
	FakePlayerDb.save(data)

	pos:sendMagicEffect(CONST_ME_TELEPORT)
	FakePlayerLogger.logState(data, "summoned")
	return true, data.name .. " summonado."
end

function FakePlayerSpawn.createAndSummon(name, position, vocation)
	local existing = FakePlayerDb.loadByName(name)
	if existing then
		return FakePlayerSpawn.summon(existing.id, position)
	end

	if #FakePlayerDb.loadAll() >= FakePlayerConfig.maxBots then
		return false, "Limite de fake players atingido (" .. FakePlayerConfig.maxBots .. ")."
	end

	local data = FakePlayerDb.create(name, position, vocation)
	if not data then
		return false, "Falha ao criar fake player."
	end
	return FakePlayerSpawn.summon(data.id, position)
end

function FakePlayerSpawn.summonAll(position)
	local okCount = 0
	local msgs = {}
	for i, data in ipairs(FakePlayerDb.loadAll()) do
		if not FakePlayerSpawn.getCreature(data.id) and data.state ~= FakePlayerState.DEAD then
			local pos = FakePlayerSpawn.findSpawnPosition(position, i)
			local ok, msg = FakePlayerSpawn.summon(data.id, pos)
			if ok then
				okCount = okCount + 1
			else
				table.insert(msgs, msg)
			end
		end
	end
	if okCount == 0 then
		return false, #msgs > 0 and msgs[1] or "Nenhum fake player disponivel para summon."
	end
	return true, okCount .. " fake player(s) summonados."
end

function FakePlayerSpawn.dismiss(botId)
	if botId == "all" or botId == nil then
		local count = 0
		for id, rt in pairs(FakePlayerRuntime.bots) do
			if FakePlayerSpawn.getCreature(id) then
				FakePlayerSpawn.dismissOne(id)
				count = count + 1
			end
		end
		return true, count .. " fake player(s) removidos."
	end

	local id = tonumber(botId)
	if not id then
		return false, "ID invalido."
	end
	return FakePlayerSpawn.dismissOne(id)
end

function FakePlayerSpawn.dismissOne(botId)
	local creature = FakePlayerSpawn.getCreature(botId)
	local rt = FakePlayerRuntime.get(botId)
	local data = rt and rt.data or FakePlayerDb.loadById(botId)

	if creature then
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		creature:remove()
	end

	if rt then
		rt.creatureId = nil
		rt.lastTargetId = nil
		rt.lastTargetName = nil
	end

	if data then
		data.state = FakePlayerState.IDLE
		data.creatureUid = nil
		if rt then
			rt.data = data
		end
		FakePlayerDb.save(data)
		FakePlayerLogger.logState(data, "dismissed")
		return true, data.name .. " removido."
	end

	return false, "Fake player nao encontrado."
end

function FakePlayerSpawn.respawn(botId)
	local rt = FakePlayerRuntime.get(botId)
	local data = rt and rt.data or FakePlayerDb.loadById(botId)
	if not data then
		return false
	end

	data.state = FakePlayerState.HUNTING
	if rt then
		rt.data = data
	end
	local ok, msg = FakePlayerSpawn.summon(botId, data.position)
	if ok then
		FakePlayerLogger.log(data.name .. " respawned after death")
	end
	return ok, msg
end

function FakePlayerSpawn.handleDeath(botId)
	local rt = FakePlayerRuntime.get(botId)
	local data = rt and rt.data
	if not data then
		return
	end

	data.state = FakePlayerState.DEAD
	data.creatureUid = nil
	rt.creatureId = nil
	rt.lastTargetId = nil
	rt.lastTargetName = nil
	FakePlayerDb.save(data)
	FakePlayerLogger.logState(data, "died")

	addEvent(function()
		if not FakePlayerSpawn.getCreature(botId) then
			FakePlayerSpawn.respawn(botId)
		end
	end, FakePlayerConfig.respawnDelay)
end

function FakePlayerSpawn.getStatusText(botId)
	if botId then
		local data = FakePlayerDb.loadById(tonumber(botId))
		if not data then
			return "Fake player id " .. botId .. " nao encontrado."
		end
		return FakePlayerSpawn.formatStatus(data)
	end

	local lines = {}
	for _, data in ipairs(FakePlayerDb.loadAll()) do
		table.insert(lines, FakePlayerSpawn.formatStatus(data))
	end
	if #lines == 0 then
		return "Nenhum fake player cadastrado. Use /fp create Nome"
	end
	return table.concat(lines, "\n")
end

function FakePlayerSpawn.formatStatus(data)
	local creature = FakePlayerSpawn.getCreature(data.id)
	local pos = creature and creature:getPosition() or data.position
	local voc = FakePlayerVocations[data.vocation] or ("Voc " .. data.vocation)
	local hpText = "-"
	if creature then
		hpText = string.format("%d/%d", creature:getHealth(), creature:getMaxHealth())
	end
	return string.format(
		"[%d] %s | %s | Lv %d | Exp %d | Gold %d | %s | Pos %d/%d/%d | Ativo: %s",
		data.id, data.name, voc, data.level, data.experience, data.gold,
		data.state, pos.x, pos.y, pos.z, creature and "sim" or "nao"
	)
end

function FakePlayerSpawn.purgeAll(clearDatabase)
	for botId, rt in pairs(FakePlayerRuntime.bots) do
		local creature = FakePlayerSpawn.getCreature(botId)
		if creature then
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
			creature:remove()
		end
		rt.creatureId = nil
		rt.lastTargetId = nil
		rt.lastTargetName = nil
	end
	FakePlayerRuntime.bots = {}

	if clearDatabase then
		FakePlayerDb.deleteAll()
	else
		for _, data in ipairs(FakePlayerDb.loadAll()) do
			data.state = FakePlayerState.IDLE
			data.creatureUid = nil
			FakePlayerDb.save(data)
		end
	end

	FakePlayerLogger.log("All fake players purged")
	return true, "Todos os fake players foram removidos."
end

function FakePlayerSpawn.getListText()
	local lines = { "Fake players cadastrados:" }
	for _, data in ipairs(FakePlayerDb.loadAll()) do
		local active = FakePlayerSpawn.getCreature(data.id) and "ON" or "OFF"
		table.insert(lines, string.format("  #%d %s [%s] Lv%d", data.id, data.name, active, data.level))
	end
	if #lines == 1 then
		table.insert(lines, "  (vazio)")
	end
	return table.concat(lines, "\n")
end
