-- ===================================================
-- VIP BLESSING SCROLL (Single VIP Blessing - ID 6)
-- ===================================================
-- Scroll consumivel que adiciona a blessing VIP (ID 6)
-- Requisito: Ter todas as 5 blessings basicas (1-5)
-- Com 5 blessings: 5% loss | Com 6 blessings (VIP): 1% loss (80% reduction)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Debug log
	print("DEBUG: Player " .. player:getName() .. " tried to use VIP blessing scroll")
	
	-- Verificar se tem todas as 5 blessings basicas (requisito)
	local hasAllBasic = true
	for i = 1, 5 do
		if not player:hasBlessing(i) then
			hasAllBasic = false
			print("DEBUG: Player " .. player:getName() .. " is missing basic blessing " .. i)
			break
		end
	end
	
	if not hasAllBasic then
		player:sendCancelMessage("You must have all 5 basic blessings before using this scroll!")
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Talk to the Monk to get the basic blessings first.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		print("DEBUG: Player " .. player:getName() .. " doesn't have all basic blessings")
		return true
	end
	
	-- Verificar se ja tem a blessing VIP (ID 6)
	if player:hasBlessing(6) then
		player:sendCancelMessage("You already have the VIP blessing!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		print("DEBUG: Player " .. player:getName() .. " already has VIP blessing")
		return true
	end
	
	-- Tentar remover o scroll do inventario
	if not item:remove() then
		player:sendCancelMessage("Error using VIP blessing scroll!")
		print("DEBUG: Error removing VIP scroll item for player " .. player:getName())
		return false
	end
	
	-- Adicionar blessing VIP (ID 6)
	if player:addBlessing(6, 1) then
		-- Mensagem de sucesso
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been blessed with the VIP protection! Maximum protection achieved!")
		player:sendTextMessage(MESSAGE_INFO_DESCR, "VIP Blessing activated! You now lose only 1% exp/skills on death.")
		
		-- Efeitos visuais
		local playerPos = player:getPosition()
		playerPos:sendMagicEffect(CONST_ME_HOLYDAMAGE)
		playerPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		
		-- Storage para controle (opcional)
		player:setStorageValue(30007, 1) -- Storage para VIP blessing via scroll
		
		-- Log de sucesso
		print(string.format("[VIP Blessing Scroll] Player %s (level %d) successfully used VIP blessing scroll", 
			player:getName(), player:getLevel()))
		
		return true
	else
		-- Erro ao adicionar blessing (nao deveria acontecer)
		player:sendCancelMessage("Error adding VIP blessing! Contact an administrator.")
		print("ERROR: Could not add VIP blessing (ID 6) to player " .. player:getName())
		
		-- Tentar devolver o scroll se deu erro
		player:addItem(item:getId(), 1)
		
		return false
	end
end

