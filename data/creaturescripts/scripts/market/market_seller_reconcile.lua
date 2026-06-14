local function ensureSellerCleanedTable()
	return db.query([[CREATE TABLE IF NOT EXISTS `market_seller_cleaned` (
		`history_id` INT UNSIGNED NOT NULL,
		`player_id` INT NOT NULL,
		`itemtype` INT NOT NULL,
		`amount` INT NOT NULL,
		`cleaned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`history_id`),
		KEY `idx_player_id` (`player_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]) == true
end

local function getCutoff()
	local res = db.storeQuery("SELECT cutoff_inserted FROM market_reconcile_state WHERE id = 1")
	if res then
		local v = result.getDataLong(res, "cutoff_inserted")
		result.free(res)
		if v and v > 0 then return v end
	end
	return os.time()
end

local function removeFromContainer(container, itemId, amount)
	if not container or amount <= 0 then return 0 end
	local removed = 0
	local t = ItemType(itemId)
	local isStack = t and t:isStackable() or false
	for i = container:getSize() - 1, 0, -1 do
		if removed >= amount then break end
		local it = container:getItem(i)
		if it then
			if it:isContainer() then
				removed = removed + removeFromContainer(it, itemId, amount - removed)
			else
				if it:getId() == itemId then
					if isStack and it.getCount then
						local take = math.min(it:getCount(), amount - removed)
						if take >= it:getCount() then
							removed = removed + it:getCount()
							it:remove()
						else
							it:transform(itemId, it:getCount() - take)
							removed = removed + take
						end
					else
						it:remove()
						removed = removed + 1
					end
				end
			end
		end
	end
	return removed
end

local function removeFromPlayerStorage(player, itemId, amount)
	local totalRemoved = 0
	-- Inbox primeiro
	local inbox = player:getInbox()
	if inbox then
		totalRemoved = totalRemoved + removeFromContainer(inbox, itemId, amount - totalRemoved)
	end
	-- Depots 1..20
	for depotId = 1, 20 do
		if totalRemoved >= amount then break end
		local chest = player:getDepotChest(depotId, true)
		if chest then
			totalRemoved = totalRemoved + removeFromContainer(chest, itemId, amount - totalRemoved)
		end
	end
	return totalRemoved
end

function onLogin(player)
	if not ensureSellerCleanedTable() then
		print("[MarketSellerReconcile][WARN] Falha ao garantir tabela market_seller_cleaned")
		return true
	end

	local guid = player:getGuid()
	local cutoff = getCutoff()
	local q = string.format([[SELECT h.id AS history_id, h.itemtype, h.amount
		FROM market_history h
		LEFT JOIN market_seller_cleaned c ON c.history_id = h.id
		WHERE h.player_id = %d AND h.sale = 1 AND h.state IN (3,255) AND h.inserted >= %d AND c.history_id IS NULL
		ORDER BY h.id ASC]], guid, cutoff)

	addEvent(function(pid)
		local pl = Player(pid)
		if not pl then return end
		local res = db.storeQuery(q)
		if not res then return end
		repeat
			local hid = result.getDataInt(res, "history_id")
			local itemId = result.getDataInt(res, "itemtype")
			local amount = result.getDataInt(res, "amount")
			if hid and itemId and amount and amount > 0 then
				local removed = removeFromPlayerStorage(pl, itemId, amount)
				if removed >= amount then
					db.query(string.format("INSERT IGNORE INTO market_seller_cleaned (history_id, player_id, itemtype, amount) VALUES (%d, %d, %d, %d)", hid, guid, itemId, amount))
					print(string.format("[MarketSellerReconcile] player=%s removed item=%d amount=%d (history_id=%d)", pl:getName(), itemId, amount, hid))
				else
					print(string.format("[MarketSellerReconcile][WARN] player=%s expected remove=%d removed=%d item=%d (history_id=%d)", pl:getName(), amount, removed, itemId, hid))
				end
			end
		until not result.next(res)
		result.free(res)
	end, 400, player:getId())

	return true
end


