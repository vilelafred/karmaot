function onUse(player, item, fromPosition, target, toPosition, isHotkey)
 
local mana = player:getMaxMana()
local ppos = player:getPosition()

	if player then
	ppos:sendMagicEffect(CONST_ME_MAGIC_BLUE) 
	player:addMana(mana)
	player:say("Aaaah...")
	end

 return true
end