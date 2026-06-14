FakePlayerBrain = {}

local function posDistance(a, b)
	if a.z ~= b.z then
		return 999
	end
	return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function wakeMonster(creature)
	local monster = Monster(creature)
	if monster then
		monster:setIdle(false)
	end
end

local function moveTowards(creature, targetPos, maxSteps)
	maxSteps = maxSteps or FakePlayerConfig.stepsPerTick or 1
	local path = creature:getPathTo(targetPos, 0, 1, true, true, 14)
	if type(path) ~= "table" or #path == 0 then
		return false
	end

	local moved = false
	for i = 1, math.min(maxSteps, #path) do
		if creature:move(path[i]) then
			moved = true
		else
			break
		end
	end
	return moved
end

local function pickRandomWalkDestination(creature, rt)
	local pos = creature:getPosition()
	local anchor = rt.anchorPos or pos
	local radius = FakePlayerConfig.randomWalk.radius or 8

	for _ = 1, 10 do
		local dx = math.random(-radius, radius)
		local dy = math.random(-radius, radius)
		if dx ~= 0 or dy ~= 0 then
			local dest = Position(anchor.x + dx, anchor.y + dy, anchor.z)
			local tile = Tile(dest)
			if tile and tile:getGround() and not tile:hasFlag(TILESTATE_BLOCKSOLID) then
				return dest
			end
		end
	end

	return nil
end

local function randomWalk(creature, rt)
	if not rt.walkDest or posDistance(creature:getPosition(), rt.walkDest) <= 0 then
		rt.walkDest = pickRandomWalkDestination(creature, rt)
	end

	if rt.walkDest and moveTowards(creature, rt.walkDest, FakePlayerConfig.stepsPerTick) then
		return true
	end

	rt.walkDest = nil

	if not rt.walkStepsLeft or rt.walkStepsLeft <= 0 then
		rt.walkStepsLeft = math.random(FakePlayerConfig.randomWalk.minSteps, FakePlayerConfig.randomWalk.maxSteps)
		rt.walkDirection = math.random(0, 3)
	end

	for _ = 1, FakePlayerConfig.stepsPerTick or 1 do
		if creature:move(rt.walkDirection) then
			rt.walkStepsLeft = rt.walkStepsLeft - 1
			return true
		end
		rt.walkDirection = math.random(0, 3)
	end

	rt.walkStepsLeft = 0
	return false
end

local function engageTarget(monster, prey)
	if not monster or not prey then
		return false
	end

	monster:removeFriend(prey)
	monster:addTarget(prey, true)
	monster:setIdle(false)

	local preyMonster = Monster(prey)
	if preyMonster then
		preyMonster:removeFriend(monster)
		preyMonster:addTarget(monster, true)
		preyMonster:selectTarget(monster)
		preyMonster:setIdle(false)
	end

	if not monster:selectTarget(prey) then
		monster:setFollowCreature(prey)
		monster:setTarget(prey)
	end

	return true
end

local function performMeleeAttack(attacker, target, level)
	if posDistance(attacker:getPosition(), target:getPosition()) > 1 then
		return false
	end

	local min = 5 + math.floor(level * 1.5)
	local max = 12 + math.floor(level * 2.5)
	doTargetCombatHealth(attacker:getId(), target:getId(), COMBAT_PHYSICALDAMAGE, -max, -min, CONST_ME_HITAREA)
	return true
end

local function isValidTarget(creature, spec)
	if not spec:isMonster() or spec:getId() == creature:getId() then
		return false
	end

	if FakePlayerSpawn.isBotCreature(spec) then
		return false
	end

	if FakePlayerConfig.skipSummons and spec:getMaster() then
		return false
	end

	local monster = Monster(spec)
	if not monster then
		return false
	end

	local mt = monster:getType()
	if not mt then
		return false
	end

	if mt:name():lower() == FakePlayerConfig.monsterName:lower() then
		return false
	end

	if FakePlayerConfig.ignoreMonsters[mt:name():lower()] then
		return false
	end

	if FakePlayerConfig.skipBosses and mt:isBoss() then
		return false
	end

	return true
end

local function findNearestTarget(creature)
	local pos = creature:getPosition()
	local best, bestDist = nil, FakePlayerConfig.searchRadius + 1
	local spectators = Game.getSpectators(pos, false, false,
		FakePlayerConfig.searchRadius, FakePlayerConfig.searchRadius,
		FakePlayerConfig.searchRadius, FakePlayerConfig.searchRadius)

	for _, spec in ipairs(spectators) do
		if isValidTarget(creature, spec) then
			local dist = posDistance(pos, spec:getPosition())
			if dist < bestDist then
				best = spec
				bestDist = dist
			end
		end
	end

	return best
end

local function creditKill(data, rt, targetCreature)
	local exp = FakePlayerDb.getKillReward(targetCreature)
	local leveled = FakePlayerDb.addExperience(data, exp)
	data.gold = data.gold + FakePlayerConfig.goldPerKill
	local targetName = targetCreature and targetCreature:getName() or (rt.lastTargetName or "monster")
	FakePlayerLogger.logState(data, string.format("kill %s (+%d exp)", targetName, exp))
	if leveled then
		FakePlayerLogger.log(string.format("%s subiu para level %d!", data.name, data.level))
		local creature = FakePlayerSpawn.getCreature(data.id)
		if creature then
			FakePlayerSpawn.scaleHealth(creature, data.level)
		end
	end
end

local function onKillResolved(data, rt)
	if rt.lastTargetId then
		local last = Creature(rt.lastTargetId)
		creditKill(data, rt, last)
	end
	rt.lastTargetId = nil
	rt.lastTargetName = nil
	data.state = FakePlayerState.HUNTING
end

local function isTargetDead(targetId)
	if not targetId then
		return true
	end
	local target = Creature(targetId)
	return not target or target:isRemoved() or target:getHealth() <= 0
end

local function tickIdle(creature, data)
	data.state = FakePlayerState.HUNTING
end

local function tickHunting(creature, data, rt)
	wakeMonster(creature)

	local prey = findNearestTarget(creature)
	if prey then
		local monster = Monster(creature)
		if monster then
			engageTarget(monster, prey)
		end
		rt.lastTargetId = prey:getId()
		rt.lastTargetName = prey:getName():lower()
		rt.walkDest = nil
		data.state = FakePlayerState.FIGHTING
		FakePlayerLogger.logState(data, "target " .. prey:getName())
		return
	end

	randomWalk(creature, rt)
end

local function tickFighting(creature, data, rt)
	local maxHp = creature:getMaxHealth()
	if maxHp > 0 and (creature:getHealth() * 100 / maxHp) <= FakePlayerConfig.lowHpPercent then
		rt.lastTargetId = nil
		rt.lastTargetName = nil
		rt.walkDest = nil
		data.state = FakePlayerState.RETURNING
		FakePlayerLogger.logState(data, "low hp retreat")
		return
	end

	wakeMonster(creature)
	local monster = Monster(creature)
	local prey = Creature(rt.lastTargetId)

	if isTargetDead(rt.lastTargetId) then
		onKillResolved(data, rt)
		return
	end

	if prey and monster then
		engageTarget(monster, prey)
		monster:setFollowCreature(prey)
		if posDistance(creature:getPosition(), prey:getPosition()) > 1 then
			moveTowards(creature, prey:getPosition())
		else
			performMeleeAttack(creature, prey, data.level)
		end
	else
		local fallback = findNearestTarget(creature)
		if fallback and monster then
			engageTarget(monster, fallback)
			rt.lastTargetId = fallback:getId()
			rt.lastTargetName = fallback:getName():lower()
		else
			data.state = FakePlayerState.HUNTING
			randomWalk(creature, rt)
		end
	end
end

local function tickReturning(creature, data, rt)
	local safe = rt.safeSpot or data.position or FakePlayerConfig.spawn
	if posDistance(creature:getPosition(), safe) <= 1 then
		creature:addHealth(creature:getMaxHealth())
		data.state = FakePlayerState.HUNTING
		rt.walkDest = nil
		FakePlayerLogger.logState(data, "recovered at safe spot")
		return
	end

	wakeMonster(creature)
	moveTowards(creature, safe)
end

local function tickBot(botId)
	local rt = FakePlayerRuntime.get(botId)
	if not rt then
		return
	end

	local creature = FakePlayerSpawn.getCreature(botId)
	if not creature then
		if rt.data and rt.data.state ~= FakePlayerState.DEAD and rt.data.state ~= FakePlayerState.IDLE then
			FakePlayerSpawn.handleDeath(botId)
		end
		return
	end

	local data = rt.data or FakePlayerDb.loadById(botId)
	if not data then
		return
	end

	rt.data = data
	data.position = creature:getPosition()
	data.creatureUid = creature:getId()
	FakePlayerSpawn.updateDisplayName(creature, data)
	wakeMonster(creature)

	if data.state == FakePlayerState.IDLE then
		tickIdle(creature, data)
	elseif data.state == FakePlayerState.HUNTING then
		tickHunting(creature, data, rt)
	elseif data.state == FakePlayerState.FIGHTING then
		tickFighting(creature, data, rt)
	elseif data.state == FakePlayerState.RETURNING then
		tickReturning(creature, data, rt)
	end

	rt.tickCounter = rt.tickCounter + 1
	if rt.tickCounter % FakePlayerConfig.saveEveryTicks == 0 then
		FakePlayerDb.save(data)
	end
end

function FakePlayerBrain.tick()
	for botId, rt in pairs(FakePlayerRuntime.bots) do
		tickBot(botId)
	end

	for _, data in ipairs(FakePlayerDb.loadAll()) do
		if data.creatureUid and not FakePlayerRuntime.get(data.id) then
			FakePlayerRuntime.ensure(data.id, data)
		end
	end
	return true
end
