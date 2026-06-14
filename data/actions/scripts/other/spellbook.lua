function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = {}
	local spells = {}

	-- Try to get instant spells
	local instantSpells = player:getInstantSpells()
	if instantSpells then
		for _, spell in ipairs(instantSpells) do
			if spell and spell.level and (spell.level ~= 0 or (spell.manapercent and spell.manapercent > 0) or (spell.mana and spell.mana > 0)) then
				local manaText = "0 mana"
				if spell.manapercent and spell.manapercent > 0 then
					manaText = spell.manapercent .. "%"
				elseif spell.mana and spell.mana > 0 then
					manaText = spell.mana .. " mana"
				end
				
				local spellInfo = {
					level = spell.level or 0,
					words = spell.words or "Unknown",
					name = spell.name or "Unknown",
					mana = manaText
				}
				table.insert(spells, spellInfo)
			end
		end
	end

	-- Sort spells by level
	table.sort(spells, function(a, b)
		return a.level < b.level
	end)

	local prevLevel = -1
	for i, spell in ipairs(spells) do
		if prevLevel ~= spell.level then
			if i ~= 1 then
				table.insert(text, "\n")
			end
			table.insert(text, "Spells for Level " .. spell.level .. "\n")
			prevLevel = spell.level
		end
		table.insert(text, spell.words .. " - " .. spell.name .. " : " .. spell.mana .. "\n")
	end

	if #text == 0 then
		table.insert(text, "You don't know any spells yet.")
	end

	player:showTextDialog(item:getId(), table.concat(text))
	return true
end
