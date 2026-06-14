-- Versão modificada do ShopModule que só vende itens da mochila

-- Função para contar itens na mochila
function Player.getBackpackItemCount(self, itemid)
	local container = self:getSlotItem(CONST_SLOT_BACKPACK)
	if not container then
		return 0
	end
	
	local count = 0
	local size = container:getSize()
	for i = 0, size-1 do
		local item = container:getItem(i)
		if item then
			if item:isContainer() then
				count = count + self:getItemCountInContainer(item, itemid)
			elseif item:getId() == itemid then
				count = count + item:getCount()
			end
		end
	end
	return count
end

-- Função auxiliar para contar itens em containers
function Player.getItemCountInContainer(self, container, itemid)
	local count = 0
	local size = container:getSize()
	
	for i = 0, size-1 do
		local item = container:getItem(i)
		if item then
			if item:isContainer() then
				count = count + self:getItemCountInContainer(item, itemid)
			elseif item:getId() == itemid then
				count = count + item:getCount()
			end
		end
	end
	
	return count
end

-- Função para remover itens de containers
function Player.removeItemsFromContainer(self, container, itemid, count)
	local removed = 0
	local size = container:getSize()
	
	for i = 0, size-1 do
		if removed >= count then
			break
		end
		
		local item = container:getItem(i)
		if item then
			if item:isContainer() then
				local removedFromSub = self:removeItemsFromContainer(item, itemid, count - removed)
				removed = removed + removedFromSub
			elseif item:getId() == itemid then
				local stackCount = item:getCount()
				local toRemove = math.min(stackCount, count - removed)
				item:remove(toRemove)
				removed = removed + toRemove
			end
		end
	end
	
	return removed
end

-- Função para remover itens da mochila
function Player.removeBackpackItem(self, itemid, count)
	local countInBackpack = self:getBackpackItemCount(itemid)
	if count > countInBackpack or count <= 0 then
		return false
	end
	
	local container = self:getSlotItem(CONST_SLOT_BACKPACK)
	if not container then
		return false
	end
	
	local totalRemoved = 0
	
	-- Primeiro, remove itens diretos da mochila
	local size = container:getSize()
	for i = 0, size-1 do
		if totalRemoved >= count then
			break
		end
		
		local item = container:getItem(i)
		if item and item:getId() == itemid then
			local stackCount = item:getCount()
			local toRemove = math.min(stackCount, count - totalRemoved)
			
			if toRemove > 0 then
				item:remove(toRemove)
				totalRemoved = totalRemoved + toRemove
			end
		end
	end
	
	-- Se ainda precisa remover mais, procura em containers
	if totalRemoved < count then
		for i = 0, size-1 do
			if totalRemoved >= count then
				break
			end
			
			local item = container:getItem(i)
			if item and item:isContainer() then
				local removedFromContainer = self:removeItemsFromContainer(item, itemid, count - totalRemoved)
				totalRemoved = totalRemoved + removedFromContainer
			end
		end
	end
	
	return totalRemoved == count
end

-- Função para vender apenas itens da mochila
function doPlayerSellBackpackItem(cid, itemId, count, price)
	local player = Player(cid)
	if not player then 
		return LUA_ERROR 
	end
	
	-- Verifica se o jogador tem o item na mochila usando nossa função
	local backpackCount = player:getBackpackItemCount(itemId)
	
	if backpackCount < count then
		return LUA_ERROR
	end
	
	-- Usa método nativo para tentar remover do inventário primeiro
	if player:removeItem(itemId, count, -1, true) then
		-- Se conseguiu remover, adiciona o dinheiro
		player:addMoney(price)
		return LUA_NO_ERROR
	else
		-- Se falhou com método nativo, tenta nossa implementação customizada
		local removed = player:removeBackpackItem(itemId, count)
		if removed then
			player:addMoney(price)
			return LUA_NO_ERROR
		end
		return LUA_ERROR
	end
end

-- Função para substituir a função padrão do ShopModule
function ShopModule.onConfirm(cid, message, keywords, parameters, node)
	local module = parameters.module
	if cid ~= module.npcHandler.focus then 
		return false 
	end
	
	local parentParameters = node:getParent():getParameters()
	local player = Player(cid)
	local parseInfo = {
		[TAG_PLAYERNAME] = getPlayerName(cid),
		[TAG_ITEMCOUNT] = module.amount,
		[TAG_TOTALCOST] = parentParameters.cost * module.amount,
		[TAG_ITEMNAME] = parentParameters.realname or node:getParent():getKeywords()[1]
	}
	
	if parentParameters.eventType == SHOPMODULE_SELL_ITEM then
		local ret = doPlayerSellBackpackItem(cid, parentParameters.itemid, module.amount, parentParameters.cost * module.amount)
		local msg = module.npcHandler:getMessage(ret == LUA_NO_ERROR and MESSAGE_ONSELL or MESSAGE_NOTHAVEITEM)
		msg = module.npcHandler:parseMessage(msg, parseInfo)
		module.npcHandler:say(msg)
	elseif parentParameters.eventType == SHOPMODULE_BUY_ITEM then
		local totalCost = parentParameters.cost * module.amount
		local totalMoney = player:getMoney() + player:getBankBalance()
		if totalMoney < totalCost then
			local msg = module.npcHandler:getMessage(MESSAGE_NEEDMOREMONEY)
			msg = module.npcHandler:parseMessage(msg, parseInfo)
			module.npcHandler:say(msg)
		else
			local fromInventory = math.min(player:getMoney(), totalCost)
			local fromBank = totalCost - fromInventory
			if fromInventory > 0 then
				player:removeMoney(fromInventory)
			end
			if fromBank > 0 then
				player:setBankBalance(player:getBankBalance() - fromBank)
			end
			local ret = doPlayerBuyItem(cid, parentParameters.itemid, module.amount, 0, parentParameters.charges)
			local msg = module.npcHandler:getMessage(ret == LUA_NO_ERROR and MESSAGE_ONBUY or MESSAGE_NEEDMOREMONEY)
			msg = module.npcHandler:parseMessage(msg, parseInfo)
			module.npcHandler:say(msg)
		end
	end
	
	module.npcHandler:resetNpc()
	return true
end