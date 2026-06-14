local function moveContainerContents(fromContainer, toContainer)
    if not fromContainer or not toContainer then
        return {}
    end
    local movedIds = {}
    for i = fromContainer:getSize() - 1, 0, -1 do
        local item = fromContainer:getItem(i)
        if item then
            local ok = item:moveTo(toContainer)
            if ok then
                table.insert(movedIds, item:getId())
            else
                print("[InboxToDepotTick][WARN] moveTo failed for itemId=" .. item:getId())
            end
        end
    end
    return movedIds
end

-- Throttle de falhas por jogador+item para evitar spam
local moveFailLog = {}
local notifyLog = {}
local failCounters = {}
local failNotifyTs = {}

local function tryMoveToAnyDepot(player, item, preferredDepotId)
    -- tenta mover para o depot preferido e, se falhar, tenta depots 1..20
    local chestPref = player:getDepotChest(preferredDepotId, true)
    if chestPref and item:moveTo(chestPref) then
        return preferredDepotId
    end
    for did = 1, 20 do
        if did ~= preferredDepotId then
            local chest = player:getDepotChest(did, true)
            if chest and item:moveTo(chest) then
                return did
            end
        end
    end
    return nil
end

local function getPreferredDepotChest(player)
    local depotId = 0
    local town = player:getTown()
    if town then
        depotId = town:getId()
    else
        depotId = player.getTownId and player:getTownId() or 1
    end
    return player:getDepotChest(depotId, true), depotId
end

local function reconcileOnlineDelivery(player, movedIds)
	-- Marca no banco as compras (sale=0) entregues enquanto o player estava online
	if not movedIds or #movedIds == 0 then return end
	local guid = player:getGuid()
	-- Conta por itemtype
	local counts = {}
	for _, iid in ipairs(movedIds) do
		counts[iid] = (counts[iid] or 0) + 1
	end
	for itemType, remaining in pairs(counts) do
		if remaining > 0 then
			local q = string.format([[SELECT h.id, h.amount
				FROM market_history h
				LEFT JOIN market_delivered d ON d.history_id = h.id
				WHERE h.player_id = %d AND h.sale = 0 AND h.state IN (3,255)
				AND h.itemtype = %d AND d.history_id IS NULL
				ORDER BY h.id ASC]], guid, itemType)
			local res = db.storeQuery(q)
			if res then
				repeat
					local hid = result.getDataInt(res, "id")
					local amount = result.getDataInt(res, "amount")
					if hid and amount and remaining > 0 then
						local take = math.min(amount, remaining)
						db.query(string.format(
							"INSERT IGNORE INTO market_delivered (history_id, player_id, itemtype, amount) VALUES (%d, %d, %d, %d)",
							hid, guid, itemType, take
						))
						remaining = remaining - take
					end
				until remaining <= 0 or not result.next(res)
				result.free(res)
			end
		end
	end
end

function onThink(interval)
    for _, player in ipairs(Game.getPlayers()) do
        local inbox = player:getInbox()
        if inbox and inbox:getSize() > 0 then
            local depotChest, depotId = getPreferredDepotChest(player)
            if not depotChest then
                -- Depot indisponível: throttling a cada 60s
                local key = player:getGuid() .. ":nodepot"
                local now = os.time()
                if not moveFailLog[key] or (now - moveFailLog[key]) > 60 then
                    print("[InboxToDepotTick][WARN] player=" .. player:getName() .. " depot not found for depotId=" .. tostring(depotId))
                    moveFailLog[key] = now
                end
            else
                -- tenta mover item a item, com fallback para outros depots se necessário
                local movedIds, fallbackMoved = {}, {}
                local allow = MarketAllowedMove and MarketAllowedMove[player:getGuid()] or nil
                local allowMap = allow and allow.items or nil
                if allow and allow.expires and os.time() > allow.expires then
                    MarketAllowedMove[player:getGuid()] = nil
                    allowMap = nil
                end
                local thisFailCounts = {}
                for i = inbox:getSize() - 1, 0, -1 do
                    local item = inbox:getItem(i)
                    if item then
                        if (not allowMap or (allowMap[item:getId()] and allowMap[item:getId()] > 0)) and item:moveTo(depotChest) then
                            table.insert(movedIds, item:getId())
                            if allowMap and allowMap[item:getId()] then
                                allowMap[item:getId()] = math.max(0, allowMap[item:getId()] - 1)
                            end
                        else
                            local altDid = tryMoveToAnyDepot(player, item, depotId)
                            if altDid then
                                table.insert(movedIds, item:getId())
                                fallbackMoved[altDid] = (fallbackMoved[altDid] or 0) + 1
                            else
                                local key = player:getGuid() .. ":fail:" .. item:getId()
                                local now = os.time()
                                if not moveFailLog[key] or (now - moveFailLog[key]) > 60 then
                                    print("[InboxToDepotTick][WARN] moveTo failed for itemId=" .. item:getId() .. " for player=" .. player:getName())
                                    moveFailLog[key] = now
                                end
                                thisFailCounts[item:getId()] = (thisFailCounts[item:getId()] or 0) + 1
                            end
                        end
                    end
                end
                if #movedIds > 0 then
                    local idStrings = {}
                    for _, id in ipairs(movedIds) do idStrings[#idStrings+1] = tostring(id) end
                    print("[InboxToDepotTick] player=" .. player:getName() .. " depotId=" .. depotId .. " moved=" .. #movedIds .. " item(s) [ids=" .. table.concat(idStrings, ",") .. "] from inbox to depot (fallbacks=" .. (next(fallbackMoved) and "yes" or "no") .. ")")
                    for did, count in pairs(fallbackMoved) do
                        print("[InboxToDepotTick][FALLBACK] player=" .. player:getName() .. " moved=" .. count .. " item(s) to depotId=" .. did)
                    end
					-- Marca history como entregue para evitar reconciliação futura do mesmo item
					reconcileOnlineDelivery(player, movedIds)
                    -- Player notification (throttled 30s)
                    local keyN = player:getGuid() .. ":notify"
                    local nowN = os.time()
                    if not notifyLog[keyN] or (nowN - notifyLog[keyN]) > 30 then
                        local town = player:getTown()
                        local tId = town and town:getId() or (player.getTownId and player:getTownId() or 1)
                        local tName = (town and town.getName and town:getName()) or ("Town " .. tostring(tId))
                        -- Aggregate moved items by unique name (no quantities)
                        local seenNames = {}
                        for _, iid in ipairs(movedIds) do
                            local it = ItemType(iid)
                            local iname = it and it:getName() or "item"
                            seenNames[iname] = true
                        end
                        local parts = {}
                        for iname, _ in pairs(seenNames) do
                            parts[#parts+1] = iname
                        end
                        player:sendTextMessage(
                            MESSAGE_INFO_DESCR,
                            string.format(
                                "Your market items were delivered to your depot in %s: %s",
                                tName,
                                table.concat(parts, ", ")
                            )
                        )
                        notifyLog[keyN] = nowN
                    end
                else
                    local key = player:getGuid() .. ":moved0"
                    local now = os.time()
                    if not moveFailLog[key] or (now - moveFailLog[key]) > 30 then
                        print("[InboxToDepotTick] player=" .. player:getName() .. " depotId=" .. depotId .. " moved=0 inboxSize=" .. inbox:getSize())
                        moveFailLog[key] = now
                    end
                end
                -- Aggregate fails and notify player (throttled 60s)
                if next(thisFailCounts) then
                    local guid = player:getGuid()
                    failCounters[guid] = failCounters[guid] or {}
                    for iid, cnt in pairs(thisFailCounts) do
                        failCounters[guid][iid] = (failCounters[guid][iid] or 0) + cnt
                    end
                    local nowF = os.time()
                    if not failNotifyTs[guid] or (nowF - failNotifyTs[guid]) > 60 then
                        local parts = {}
                        local totalFails = 0
                        -- Preferir os itens realmente permitidos (reconciliados) para exibir ao jogador
                        local allow = MarketAllowedMove and MarketAllowedMove[guid] or nil
                        local allowMap = allow and allow.items or nil
                        if allow and allow.expires and nowF > allow.expires then
                            MarketAllowedMove[guid] = nil
                            allowMap = nil
                        end
                        if allowMap then
                            for iid, cnt in pairs(allowMap) do
                                if cnt > 0 then
                                    local t = ItemType(iid)
                                    local iname = t and t:getName() or "item"
                                    parts[#parts+1] = string.format("%s (x%d)", iname, cnt)
                                    totalFails = totalFails + cnt
                                end
                            end
                        else
                            -- Fallback: nomes sem sugerir quantidades reais
                            local seen = {}
                            for iid, _ in pairs(failCounters[guid]) do
                                local t = ItemType(iid)
                                local iname = t and t:getName() or "item"
                                if not seen[iname] then
                                    parts[#parts+1] = iname
                                    seen[iname] = true
                                end
                            end
                        end
                        local town = player:getTown()
                        local tId = town and town:getId() or (player.getTownId and player:getTownId() or 1)
                        local tName = (town and town.getName and town:getName()) or ("Town " .. tostring(tId))
					player:sendTextMessage(
						MESSAGE_INFO_DESCR,
						(parts[1] and string.format(
							"Your market items are ready. Open your depot in %s to receive them: %s",
							tName, table.concat(parts, ", ")
						) or string.format(
							"Your market items are ready. Open your depot in %s to receive them.",
							tName
						))
					)
                        failNotifyTs[guid] = nowF
                        failCounters[guid] = {}
                    end
                end
            end
        end
    end
    return true
end



