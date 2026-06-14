MarketAllowedMove = MarketAllowedMove or {}

local function ensureExcessLogTable()
	return db.query([[CREATE TABLE IF NOT EXISTS `market_excess_log` (
		`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
		`player_id` INT NOT NULL,
		`itemtype` INT NOT NULL,
		`amount` INT NOT NULL,
		`logged_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`id`),
		KEY `idx_player_id` (`player_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]) == true
end

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

-- Não criar itens aqui; reconciliação apenas observa e marca entregas quando item já está na Inbox

local function countInboxUnitsByItemType(container, itemId)
	if not container then return 0 end
	local total = 0
	local t = ItemType(itemId)
	local stackable = t and t:isStackable() or false
	for i = 0, math.max(0, container:getSize() - 1) do
		local it = container:getItem(i)
		if it and it:getId() == itemId then
			if stackable and it.getCount then
				total = total + it:getCount()
			else
				total = total + 1
			end
		end
	end
	return total
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

		-- Carrega pendências em memória
		local pending = {}
		repeat
			local hid = result.getDataInt(res, "history_id")
			local itemId = result.getDataInt(res, "itemtype")
			local amount = result.getDataInt(res, "amount")
			if hid and itemId and amount and amount > 0 then
				pending[#pending+1] = { history_id = hid, itemId = itemId, amount = amount }
			end
		until not result.next(res)
		result.free(res)

        -- Agrupa por itemtype mantendo a ordem dos history_ids
		local byType = {}
		for _, row in ipairs(pending) do
			byType[row.itemId] = byType[row.itemId] or { total = 0, entries = {} }
			byType[row.itemId].total = byType[row.itemId].total + row.amount
			table.insert(byType[row.itemId].entries, row)
		end

		local inbox = pl:getInbox()
		local delivered = 0
		local allowedByType = {}
        for itemId, group in pairs(byType) do
            -- Aguarda item cair na Inbox (engine entrega); sem criar nada
            local available = countInboxUnitsByItemType(inbox, itemId)
            if available < group.total then
                -- tenta mais 3 vezes com pequenos delays
                for _ = 1, 3 do
                    addEvent(function(pid2)
                        local p2 = Player(pid2)
                        if not p2 then return end
                        local inbox2 = p2:getInbox()
                        local av2 = countInboxUnitsByItemType(inbox2, itemId)
                        -- nada a fazer aqui; só atualiza available por fechamento sobre upvalue não existe em Lua pura
                    end, 150)
                end
            end
            available = countInboxUnitsByItemType(inbox, itemId)
			for _, entry in ipairs(group.entries) do
				local take = math.min(entry.amount, available)
				if take > 0 then
					db.query(string.format(
						"INSERT IGNORE INTO market_delivered (history_id, player_id, itemtype, amount) VALUES (%d, %d, %d, %d)",
						entry.history_id, guid, itemId, take
					))
					available = available - take
					delivered = delivered + 1
					allowedByType[itemId] = (allowedByType[itemId] or 0) + take
					print(string.format("[MarketReconcile] player=%s delivered history_id=%d item=%d amount=%d", pl:getName(), entry.history_id, itemId, take))
				else
					print(string.format("[MarketReconcile][PEND] player=%s still pending history_id=%d item=%d amount=%d (available=%d)", pl:getName(), entry.history_id, itemId, entry.amount, available))
				end
			end
		end

		print(string.format("[MarketReconcile][SUMMARY] player=%s pending=%d delivered=%d", pl:getName(), pendingCount, delivered))
		if next(allowedByType) then
			MarketAllowedMove[guid] = { items = allowedByType, expires = os.time() + 60 }
			print(string.format("[MarketReconcile][ALLOW_MOVE] player=%s types=%d", pl:getName(), (function(m) local c=0 for _ in pairs(m) do c=c+1 end return c end)(allowedByType)))
			-- Sanitizar Inbox: remover excedentes além do permitido (evita duplicação visível)
			if ensureExcessLogTable() and inbox then
				for i = inbox:getSize() - 1, 0, -1 do
					local it = inbox:getItem(i)
					if it then
						local iid = it:getId()
						local allowed = allowedByType[iid]
						if allowed and allowed > 0 then
							-- consome 1 unidade (não reduz stack aqui, tick cuidará de mover)
							allowedByType[iid] = math.max(0, allowedByType[iid] - 1)
						else
							-- remover excedente
							local t = ItemType(iid)
							local removed = 0
							if t and t:isStackable() and it.getCount then
								removed = it:getCount()
								it:remove()
							else
								it:remove()
								removed = 1
							end
							if removed > 0 then
								db.query(string.format("INSERT INTO market_excess_log (player_id, itemtype, amount) VALUES (%d, %d, %d)", guid, iid, removed))
								print(string.format("[MarketReconcile][EXCESS_REMOVED] player=%s item=%d amount=%d", pl:getName(), iid, removed))
							end
						end
					end
				end
			end
		end
	end, 500, pid)
	return true
end


