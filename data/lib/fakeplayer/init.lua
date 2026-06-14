dofile("data/lib/fakeplayer/config.lua")
dofile("data/lib/fakeplayer/db.lua")
dofile("data/lib/fakeplayer/logger.lua")
dofile("data/lib/fakeplayer/spawn.lua")
dofile("data/lib/fakeplayer/brain.lua")

FakePlayer = {
	summon = function(botId, position) return FakePlayerSpawn.summon(tonumber(botId) or 1, position) end,
	summonAll = function(position) return FakePlayerSpawn.summonAll(position) end,
	create = function(name, position, vocation) return FakePlayerSpawn.createAndSummon(name, position, vocation) end,
	dismiss = function(botId) return FakePlayerSpawn.dismiss(botId) end,
	purge = function() return FakePlayerSpawn.purgeAll(true) end,
	status = function(botId) return FakePlayerSpawn.getStatusText(botId) end,
	list = function() return FakePlayerSpawn.getListText() end,
}

for _, data in ipairs(FakePlayerDb.loadAll()) do
	FakePlayerRuntime.ensure(data.id, data)
end
