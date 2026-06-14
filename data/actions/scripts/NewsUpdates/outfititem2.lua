function onUse(cid, item, itemEx, toPosition, fromPosition)
	
local table = {19000, 617, 488}
local pos = getPlayerPosition(cid)	
	
	if getPlayerStorageValue(cid, table[1]) < 1 then
		doPlayerAddOutfit(cid, table[2], 1)
		doPlayerAddOutfit(cid, table[3], 1)
		doPlayerSendTextMessage(cid, 22, "Parabéns! Você ganhou um novo outfit.")
		doSendMagicEffect(pos, 30)
		setPlayerStorageValue(cid, table[1], 1)
		doRemoveItem(item.uid, 1)
	else
		return doPlayerSendCancel(cid, "Você já tem esse outfit.")
	end
return true
end