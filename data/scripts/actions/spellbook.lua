-- spellbook.lua
local spellbook = Action()

function spellbook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = {}
	local spells = {}

	for _, spell in ipairs(player:getInstantSpells()) do
		if spell.level ~= 0 or spell.manapercent > 0 or spell.mana > 0 then
			if spell.manapercent and spell.manapercent > 0 then
				spell.mana = spell.manapercent .. "%"
			elseif spell.mana and spell.mana > 0 then
				spell.mana = spell.mana .. " mana"
			else
				spell.mana = "0 mana"
			end
			table.insert(spells, spell)
		end
	end

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
		table.insert(text, "You don’t know any spells yet.")
	end

	player:showTextDialog(item:getId(), table.concat(text))
	return true
end

spellbook:id(2175, 6120, 8900, 8901, 8902, 8903, 8904, 8918, 23771)
spellbook:register()
