dofile("data/lib/fakeplayer/init.lua")

function onThink(creature, interval)
	if not FakePlayerSpawn.isBotCreature(creature) then
		return false
	end

	local monster = Monster(creature)
	if monster then
		monster:setIdle(false)
	end
	return true
end
