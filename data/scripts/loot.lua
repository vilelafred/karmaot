local talkaction = TalkAction("!loot")

local function getItemName(itemId)
	local it = ItemType(itemId)
	local name = it and it:getName() or ""
	if not name or name == "" then
		return string.format("item:%d", itemId)
	end
	return name
end

local function collectLoot(list, out)
	for _, loot in ipairs(list or {}) do
		local itemId = loot.itemId
		local entry = {
			name = getItemName(itemId)
		}
		table.insert(out, entry)
		if loot.childLoot and #loot.childLoot > 0 then
			collectLoot(loot.childLoot, out)
		end
	end
end

-- removed chance formatting

function talkaction.onSay(player, words, param)
	if not param or param == "" then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: !loot <monster name>")
		return false
	end

	local mtype = MonsterType(param)
	if not mtype then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Monster not found: " .. param)
		return false
	end

	local loot = mtype:getLoot() or {}
	if #loot == 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "This monster has no loot configured.")
		return false
	end

	local entries = {}
	collectLoot(loot, entries)

	table.sort(entries, function(a, b)
		return a.name:lower() < b.name:lower()
	end)

	local header = "Loot for " .. (mtype:name() or param) .. ":"
	local lines = {}
	for _, e in ipairs(entries) do
		lines[#lines + 1] = "- " .. e.name
	end

	local chunkSize = 10
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, header)
	for i = 1, #lines, chunkSize do
		local j = math.min(i + chunkSize - 1, #lines)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, table.concat(lines, "\n", i, j))
	end

	return false
end

talkaction:separator(" ")
talkaction:register()


