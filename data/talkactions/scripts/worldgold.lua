function onSay(player, words, param)
    local totalGold = 0

    -- GOLD em player_items (backpack, slots, containers)
    local result1 = db.storeQuery([[
        SELECT SUM(
            CASE 
                WHEN itemtype = 2148 THEN count
                WHEN itemtype = 2152 THEN count * 100
                WHEN itemtype = 2160 THEN count * 10000
                WHEN itemtype = 8238 THEN count * 1000000
                ELSE 0
            END
        ) AS gold FROM player_items
        WHERE itemtype IN (2148, 2152, 2160, 8238);
    ]])
    if result1 then
        totalGold = totalGold + (result.getDataInt(result1, "gold") or 0)
        result.free(result1)
    end

    -- GOLD em player_depotitems (depot box)
    local result2 = db.storeQuery([[
        SELECT SUM(
            CASE 
                WHEN itemtype = 2148 THEN count
                WHEN itemtype = 2152 THEN count * 100
                WHEN itemtype = 2160 THEN count * 10000
                WHEN itemtype = 8238 THEN count * 1000000
                ELSE 0
            END
        ) AS gold FROM player_depotitems
        WHERE itemtype IN (2148, 2152, 2160, 8238);
    ]])
    if result2 then
        totalGold = totalGold + (result.getDataInt(result2, "gold") or 0)
        result.free(result2)
    end

    -- GOLD no banco
    local result3 = db.storeQuery("SELECT SUM(balance) AS gold FROM players;")
    if result3 then
        totalGold = totalGold + (result.getDataInt(result3, "gold") or 0)
        result.free(result3)
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "A economia do servidor atualmente possui: " .. totalGold .. " gold coins.")
    return false
end
