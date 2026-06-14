-- Funções para trabalhar apenas com itens da backpack (slot 3)
-- Agora usando as funções nativas do TFS modificado

-- Conta quantos itens de um tipo existem apenas na mochila principal (slot 3)
function getPlayerBackpackItemCount(cid, itemId)
	local player = Player(cid)
	if not player then return 0 end
	return player:getBackpackItemCount(itemId)
end

-- Remove itens apenas da mochila principal (slot 3)
function doPlayerRemoveBackpackItem(cid, itemId, count)
	local player = Player(cid)
	if not player then return false end
	return player:removeBackpackItem(itemId, count)
end