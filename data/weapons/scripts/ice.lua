function onUseWeapon(cid, var)
doPlayerRemoveItem(cid, 2396, 1)
	return doCombat(cid, combat, var)
end