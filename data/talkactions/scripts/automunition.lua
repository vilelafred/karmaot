function onSay(cid, words, param, channel)

	if getPlayerStorageValue(cid, 95028) > os.time() then
		doPlayerSendCancel(cid, "You are exhausted.")
		return false
	else
		setPlayerStorageValue(cid, 95028, os.time()+2)
	end

	local vocPlayer = getPlayerVocation(cid)
	if (vocPlayer ~= 3 and vocPlayer ~= 7) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "This command is only for paladins!")
		return false
	end

	if (vocPlayer == 3 and param == "conjure power bolt") then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "This command is only for royal paladins!")
		return false
	end

	function msgFailedMunitions()
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need say the type munition. Available commands: conjure arrow | conjure poisoned arrow | conjure bolt | conjure explosive arrow | conjure power bolt")
		return false
	end

	function findAutoRuneActive()
		for k, v in pairs(runes) do
			if getPlayerStorageValue(cid, v.sto) == 1 then
				return k
			end
		end
		return false
	end

	if(findAutoRuneActive() ~= false) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUNE] Sorry, but you have the "..findAutoRuneActive().." rune activated, please disable for active auto munition.")
		return false
	end

	function findAutoMunitionActive()
		for k, v in pairs(munitionsStats) do
			if getPlayerStorageValue(cid, v.sto) == 1 then
				return k
			end
		end
		return false
	end

	if findMunitionName(param) then
		local munitionNameFormatted = capitalizeWords(param)
		function findStatsFromMunitionByName(name)
            local spells = {}
            for _, spell in ipairs(cid:getInstantSpells()) do
                if (spell.name == name) then
                    local stats = {
                        mLevel = spell.mlevel,
                        level = spell.level,
                        mana = spell.mana,
                        name = spell.name,
                        words = spell.words
                    }
					return stats
                end
            end
		end
		local statsMunition = findStatsFromMunitionByName(munitionNameFormatted)
		local mLevelPlayer = getPlayerMagLevel(cid)
		if (mLevelPlayer < statsMunition.mLevel) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] You need the magic level "..statsMunition.mLevel.." for make this munition.")
			return false
		end

		local levelPlayer = getPlayerLevel(cid)
		if (levelPlayer < statsMunition.level) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] You need level "..statsMunition.level.." for make this munition.")
			return false
		end

		local manaMaxPlayer = getPlayerMaxMana(cid)
		if (manaMaxPlayer < statsMunition.mana) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] You need the minimium "..statsMunition.mana.." mana points for make this munition.")
			return false
		end

		if getPlayerStorageValue(cid, munitionsStats[param].sto) == 1 then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] "..param.." munition has been disabled.")
			setPlayerStorageValue(cid, munitionsStats[param].sto, 0)
		else
			if(findAutoMunitionActive() ~= false) then
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] Sorry, but you have the "..findAutoMunitionActive().." munitions activated, please disable for active auto munitions.")
				return false
			end
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTOMUNITION] Command activated! When you are sleeping you will be auto make munition: "..param..".")
			setPlayerStorageValue(cid, munitionsStats[param].sto, 1)
		end
		return false
	else
		msgFailedMunitions()
		return false
	end

end
