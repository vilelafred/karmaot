function onSay(cid, words, param, channel)

    if getPlayerStorageValue(cid, 95027) > os.time() then
        doPlayerSendCancel(cid, "You are exhausted.")
        return false
    else
        setPlayerStorageValue(cid, 95027, os.time() + 2)
    end

    function msgFailedRunes()
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
            "You need say the type runing. Available commands: cure poison | animate dead | chameleon | convince creature | disintegrate | destroy field | explosion | energy wall | energy bomb | energy field | fireball | fire wall | fire bomb | fire field | great fireball | heavy magic missile | intense healing rune | light magic missile | magic wall | poison wall | poison bomb | poison field | paralyze | sudden death | soulfire | ultimate healing rune")
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

    function findAutoMunitionActive()
        for k, v in pairs(munitionsStats) do
            if getPlayerStorageValue(cid, v.sto) == 1 then
                return k
            end
        end
        return false
    end

    if (findAutoMunitionActive() ~= false) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
            "[AUTOMUNITION] Sorry, but you have the " .. findAutoMunitionActive() ..
                " munitions activated, please disable for active auto rune.")
        return false
    end

    if findRuneName(param) then
        local runeNameFormatted = capitalizeWords(param)
        local playerVoc = getPlayerVocation(cid)
        local learnSpell = verifyStringExistsOnArray(playerVoc, runes[param].voc)
        if not learnSpell then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUNE] Your vocation cannot make this rune.")
            return false
        end
        function findStatsFromRuneByName(name)
            local runeNameFormatted = name
            if not string.match(runeNameFormatted, "Rune") then
                runeNameFormatted = runeNameFormatted .. " Rune"
                print("CHEGOU AQUI PAPAI: ", runeNameFormatted)
            end
            local spells = {}
            for _, spell in ipairs(cid:getInstantSpells()) do
                if (spell.name == runeNameFormatted) then
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
        print("NOME DA RUNA FORMATADA: ", runeNameFormatted)
        local statsRune = findStatsFromRuneByName(runeNameFormatted)
        print("VALOR QUE VEIO NA STATS: ", statsRune)
        local mLevelPlayer = getPlayerMagLevel(cid)
        if mLevelPlayer < statsRune.mLevel then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUNE] You need the magic level " ..
                statsRune.mLevel .. " for make this rune.")
            return false
        end

        local manaMaxPlayer = getPlayerMaxMana(cid)
        if manaMaxPlayer < statsRune.mana then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[AUTORUNE] You need the minimium " ..
                statsRune.mana .. " mana points for make this rune.")
            return false
        end

        if getPlayerStorageValue(cid, runes[param].sto) == 1 then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                "[AUTORUNE] " .. param .. " rune has been disabled.")
            setPlayerStorageValue(cid, runes[param].sto, 0)
        else
            if (findAutoRuneActive() ~= false) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                    "[AUTORUNE] Sorry, but you have the " .. findAutoRuneActive() ..
                        " rune activated, please disable for active other auto runes.")
                return false
            end
            if (getPlayerItemCount(cid, 2260) > 0) then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                    "[AUTORUNE] Command activated! When you are sleeping you will be runed: " .. param .. " rune.")
                setPlayerStorageValue(cid, runes[param].sto, 1)
            else
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE,
                    "[AUTORUNE] Sorry but you need at least 1 blank rune.")
                return false
            end
        end
        return false
    else
        msgFailedRunes()
        return false
    end

end
