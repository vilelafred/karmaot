local bosses = {
	-- attempts (expiry time stored)
	{ name = "Swamp Spider", storage = 2501, seconds = 72000, mode = "expiry" },
	{ name = "Dreadfiend", storage = 2235, seconds = 72000, mode = "expiry" },
	{ name = "Mozradek", storage = 2240, seconds = 72000, mode = "expiry" },
	{ name = "Terragor", storage = 2255, seconds = 72000, mode = "expiry" },
	{ name = "Infernal Dreadlord", storage = 2266, seconds = 72000, mode = "expiry" },
	{ name = "Revenge Incarnate", storage = 6644, seconds = 72000, mode = "expiry" },	
	-- storageCooldown (last time stored)
	{ name = "Lory Mistress", storage = 54455, seconds = 72000, mode = "last" },
}

local function formatRemaining(seconds)
	if seconds <= 0 then
		return "Ready"
	end
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	return string.format("%02dh %02dm %02ds", h, m, s)
end

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local now = os.time()
	local lines = {}

	for _, b in ipairs(bosses) do
		local value = player:getStorageValue(b.storage)
		local remaining = 0
		if value and value > 0 then
			if b.mode == "last" then
				remaining = (value + b.seconds) - now
			else -- expiry
				remaining = value - now
			end
		end
		if remaining < 0 then
			remaining = 0
		end
		lines[#lines + 1] = string.format("- %s: %s", b.name, formatRemaining(remaining))
	end

	table.sort(lines)
	local text = "Daily Boss Cooldowns:\n\n" .. table.concat(lines, "\n")
	local window = ModalWindow {
		title = "Daily Boss Cooldowns",
		message = text,
	}
	window:addButton("OK")
	window:sendToPlayer(player)
	return true
end

action:id(5994)
action:register()


