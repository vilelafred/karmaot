function onUse(cid, item, fromPosition, itemEx, toPosition)
	if itemEx.itemid == 6132 and item.itemid == 6136 then
		doTransformItem(item.uid, 6148)
		doDecayItem(item.uid)
		doRemoveItem(itemEx.uid,1)
		doSendMagicEffect(toPosition, CONST_ME_MAGIC_RED)
		return true
	end
	return false
end