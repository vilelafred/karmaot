FakePlayerLogger = {}

local function ensureLogDir()
	os.execute("mkdir -p data/logs 2>/dev/null")
end

function FakePlayerLogger.log(message)
	local line = string.format("[%s] %s", os.date("%Y-%m-%d %H:%M:%S"), message)
	print("[FakePlayer] " .. message)
	ensureLogDir()
	local file = io.open(FakePlayerConfig.logFile, "a")
	if file then
		file:write(line .. "\n")
		file:close()
	end
end

function FakePlayerLogger.logState(data, detail)
	local pos = data.position
	local msg = string.format(
		"%s | lv %d | exp %d | gold %d | state %s | goal %s | pos %d/%d/%d%s",
		data.name,
		data.level,
		data.experience,
		data.gold,
		data.state,
		data.goal,
		pos.x, pos.y, pos.z,
		detail and (" | " .. detail) or ""
	)
	FakePlayerLogger.log(msg)
end
