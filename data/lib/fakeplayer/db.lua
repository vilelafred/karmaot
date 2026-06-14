FakePlayerDb = {}

local function rowToData(resultId)
	return {
		id = result.getNumber(resultId, "id"),
		name = result.getString(resultId, "name"),
		vocation = result.getNumber(resultId, "vocation"),
		level = result.getNumber(resultId, "level"),
		experience = result.getNumber(resultId, "experience"),
		gold = result.getNumber(resultId, "gold"),
		state = result.getString(resultId, "state"),
		goal = result.getString(resultId, "goal"),
		position = Position(
			result.getNumber(resultId, "position_x"),
			result.getNumber(resultId, "position_y"),
			result.getNumber(resultId, "position_z")
		),
		creatureUid = result.getNumber(resultId, "creature_uid"),
	}
end

function FakePlayerDb.loadById(id)
	local resultId = db.storeQuery("SELECT * FROM `fake_players` WHERE `id` = " .. tonumber(id))
	if not resultId then
		return nil
	end
	local data = rowToData(resultId)
	result.free(resultId)
	return data
end

function FakePlayerDb.loadAll()
	local list = {}
	local resultId = db.storeQuery("SELECT * FROM `fake_players` ORDER BY `id` ASC")
	if not resultId then
		return list
	end
	repeat
		table.insert(list, rowToData(resultId))
	until not result.next(resultId)
	result.free(resultId)
	return list
end

function FakePlayerDb.loadByName(name)
	local resultId = db.storeQuery("SELECT * FROM `fake_players` WHERE `name` = " .. db.escapeString(name))
	if not resultId then
		return nil
	end
	local data = rowToData(resultId)
	result.free(resultId)
	return data
end

function FakePlayerDb.create(name, position, vocation)
	local pos = position or FakePlayerConfig.spawn
	local voc = vocation or FakePlayerConfig.defaultVocation
	db.query(string.format(
		"INSERT INTO `fake_players` (`name`, `vocation`, `level`, `experience`, `gold`, `state`, `goal`, `position_x`, `position_y`, `position_z`) VALUES (%s, %d, 1, 0, 0, 'idle', %s, %d, %d, %d)",
		db.escapeString(name),
		voc,
		db.escapeString(FakePlayerConfig.defaultGoal),
		pos.x, pos.y, pos.z
	))
	return FakePlayerDb.loadByName(name)
end

function FakePlayerDb.nextDefaultName()
	local all = FakePlayerDb.loadAll()
	local used = {}
	for _, row in ipairs(all) do
		used[row.name:lower()] = true
	end
	for _, name in ipairs(FakePlayerConfig.defaultNames) do
		if not used[name:lower()] then
			return name
		end
	end
	return "KarmaBot" .. (#all + 1)
end

function FakePlayerDb.save(data)
	if not data or not data.id then
		return false
	end

	local pos = data.position or FakePlayerConfig.spawn
	db.query(string.format(
		"UPDATE `fake_players` SET `name` = %s, `vocation` = %d, `level` = %d, `experience` = %d, `gold` = %d, `state` = %s, `goal` = %s, `position_x` = %d, `position_y` = %d, `position_z` = %d, `creature_uid` = %s WHERE `id` = %d",
		db.escapeString(data.name),
		data.vocation,
		data.level,
		data.experience,
		data.gold,
		db.escapeString(data.state),
		db.escapeString(data.goal),
		pos.x, pos.y, pos.z,
		data.creatureUid and tostring(data.creatureUid) or "NULL",
		data.id
	))
	return true
end

function FakePlayerDb.getExpForNextLevel(level)
	return Game.getExperienceForLevel(level + 1)
end

function FakePlayerDb.addExperience(data, amount)
	data.experience = data.experience + amount
	local leveled = false
	while data.experience >= FakePlayerDb.getExpForNextLevel(data.level) do
		data.level = data.level + 1
		leveled = true
	end
	return leveled
end

function FakePlayerDb.deleteAll()
	db.query("DELETE FROM `fake_players`")
end

function FakePlayerDb.deleteById(id)
	db.query("DELETE FROM `fake_players` WHERE `id` = " .. tonumber(id))
end

function FakePlayerDb.getKillReward(target)
	local exp = FakePlayerConfig.minExpPerKill
	local monster = Monster(target)
	if monster then
		local mt = monster:getType()
		if mt then
			local monsterExp = mt:experience()
			if monsterExp and monsterExp > 0 then
				exp = monsterExp
			end
		end
	end
	return exp
end
