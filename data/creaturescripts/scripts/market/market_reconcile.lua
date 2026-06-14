local function ensureDeliveredTable()
	-- Cria tabela de controle, se não existir
	local ok = db.query([[CREATE TABLE IF NOT EXISTS `market_delivered` (
		`history_id` INT UNSIGNED NOT NULL,
		`player_id` INT NOT NULL,
		`itemtype` INT NOT NULL,
		`amount` INT NOT NULL,
		`delivered_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`history_id`),
		KEY `idx_player_id` (`player_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
	return ok == true
end

local function addItemsToInbox(player, itemId, amount)
	local inbox = player:getInbox()
	if not inbox then
		return false
	end
	local itemType = ItemType(itemId)
	if not itemType then
		return false
	end
	if itemType:isStackable() then
		local remaining = amount
		while remaining > 0 do
			local toCreate = math.min(100, remaining)
			local it = Game.createItem(itemId, toCreate)
			if not it then return false end
			local ok = it:moveTo(inbox)
			if not ok then it:remove(); return false end
			remaining = remaining - toCreate
		end
		return true
	else
		for i = 1, amount do
			local it = Game.createItem(itemId, 1)
			if not it then return false end
			local ok = it:moveTo(inbox)
			if not ok then it:remove(); return false end
		end
		return true
	end
end

function onLogin(player)
	-- Garante tabela de controle
	if not ensureDeliveredTable() then
		print("[MarketReconcile] WARN: tabela market_delivered não pôde ser criada.")
		return true
	end

	-- Tabela de estado: evita entregas retroativas (duplicaçao)
	local function ensureStateTable()
		local ok = db.query([[CREATE TABLE IF NOT EXISTS `market_reconcile_state` (
			`id` TINYINT UNSIGNED NOT NULL,
			`cutoff_inserted` BIGINT UNSIGNED NOT NULL,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
		return ok == true
	end

	local function getOrInitCutoff()
		local now = os.time()
		local res = db.storeQuery("SELECT cutoff_inserted FROM market_reconcile_state WHERE id = 1")
		if res then
			local v = result.getDataLong(res, "cutoff_inserted")
			result.free(res)
			if v and v > 0 then return v end
		end
		-- inicializa na primeira execução com o timestamp atual
		db.query(string.format("REPLACE INTO market_reconcile_state (id, cutoff_inserted) VALUES (1, %d)", now))
		return now
	end

	if not ensureStateTable() then
		print("[MarketReconcile] WARN: tabela market_reconcile_state não pôde ser criada.")
		return true
	end

	local pid = player:getId()
	local guid = player:getGuid()
	local cutoff = getOrInitCutoff()
	print(string.format("[MarketReconcile][CUTOFF] player=%s guid=%d cutoff_inserted=%d", player:getName(), guid, cutoff))
	-- Contagem de pendências para log
	local qCount = string.format([[SELECT COUNT(*) AS pending
		FROM market_history h
		LEFT JOIN market_delivered d ON d.history_id = h.id
		WHERE h.player_id = %d AND h.sale = 0 AND h.state IN (3,255) AND h.inserted >= %d AND d.history_id IS NULL]], guid, cutoff)
	local cRes = db.storeQuery(qCount)
	local pendingCount = 0
	if cRes then
		pendingCount = result.getDataInt(cRes, "pending") or 0
		result.free(cRes)
	end
	print(string.format("[MarketReconcile][PENDING] player=%s guid=%d pending=%d", player:getName(), guid, pendingCount))
	-- Seleciona compras (sale=0) marcadas como concluídas (state em {3,255}) não entregues ainda
	local q = string.format([[SELECT h.id AS history_id, h.itemtype, h.amount
		FROM market_history h
		LEFT JOIN market_delivered d ON d.history_id = h.id
		WHERE h.player_id = %d AND h.sale = 0 AND h.state IN (3,255) AND h.inserted >= %d AND d.history_id IS NULL
		ORDER BY h.id ASC
	]], guid, cutoff)
	addEvent(function(pid)
		local pl = Player(pid)
		if not pl then return end
		local res = db.storeQuery(q)
		if not res then
			if pendingCount > 0 then
				print(string.format("[MarketReconcile][WARN] player=%s pending=%d mas consulta não retornou linhas", pl:getName(), pendingCount))
			end
			return
		end

		local delivered = 0
		repeat
			local hid = result.getDataInt(res, "history_id")
			local itemId = result.getDataInt(res, "itemtype")
			local amount = result.getDataInt(res, "amount")
			if hid and itemId and amount and amount > 0 then
				-- Verifica se já existe o item na Inbox (engine pode ter entregue)
				local inbox = pl:getInbox()
				local existsInInbox = false
				if inbox then
					for i = 0, math.max(0, inbox:getSize() - 1) do
						local it = inbox:getItem(i)
						if it and it:getId() == itemId then
							existsInInbox = true
							break
						end
					end
				end
				if existsInInbox then
					db.query(string.format(
						"INSERT IGNORE INTO market_delivered (history_id, player_id, itemtype, amount) VALUES (%d, %d, %d, %d)",
						hid, guid, itemId, amount
					))
					print(string.format("[MarketReconcile][SKIP_EXISTS] player=%s history_id=%d item=%d amount=%d (found in inbox)", pl:getName(), hid, itemId, amount))
				else
					local ok = addItemsToInbox(pl, itemId, amount)
					if ok then
						db.query(string.format(
							"INSERT IGNORE INTO market_delivered (history_id, player_id, itemtype, amount) VALUES (%d, %d, %d, %d)",
							hid, guid, itemId, amount
						))
						delivered = delivered + 1
						print(string.format("[MarketReconcile] player=%s delivered history_id=%d item=%d amount=%d",
							pl:getName(), hid, itemId, amount))
					else
						print(string.format("[MarketReconcile][WARN] moveTo inbox failed player=%s history_id=%d item=%d amount=%d",
							pl:getName(), hid, itemId, amount))
					end
				end
			end
		until not result.next(res)
		result.free(res)

		print(string.format("[MarketReconcile][SUMMARY] player=%s pending=%d delivered=%d", pl:getName(), pendingCount, delivered))
	end, 500, pid)
	return true
end


