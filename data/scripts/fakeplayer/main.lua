dofile("data/lib/fakeplayer/init.lua")

local tickEvent = GlobalEvent("FakePlayerTick")

function tickEvent.onThink(interval)
	FakePlayerBrain.tick()
	return true
end

tickEvent:interval(FakePlayerConfig.tickInterval)
tickEvent:register()

FakePlayerLogger.log("FakePlayer tick registered")
