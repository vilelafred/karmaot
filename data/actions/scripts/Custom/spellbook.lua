function onUse(cid, item, frompos, item2, topos)
    local t = {}
    for i = 0, getPlayerInstantSpellCount(cid) - 1 do
        local spell = getPlayerInstantSpellInfo(cid, i)
        if(spell.mlevel ~= 0) then
            if(spell.manapercent > 0) then
                spell.mana = spell.manapercent .. "%"
            end

            table.insert(t, spell)
        end
    end

    table.sort(t, function(a, b) return a.mlevel < b.mlevel end)
    local text, prevLevel = "", -1
    for i, spell in ipairs(t) do
        local line = ""
        if(prevLevel ~= spell.mlevel) then
            if(i ~= 1) then
                line = "\n"
            end

            line = line .. "Spells for Magic Level " .. spell.mlevel .. "\n"
            prevLevel = spell.mlevel
        end

    --    text = text .. line .. "  " .. spell.words .. " - " .. spell.name .. " Mana: " .. spell.mana .. "\n"

        text = text .. line .. "  " .. spell.words .. " : " .. spell.mana .. "\n"
    end

    doShowTextDialog(cid, 2175, text)
    return true
end