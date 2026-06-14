function onUse(player, item, fromPosition, target, toPosition, isHotkey)
 
local life = player:addHealth(math.random(80, 150))
local ppos = player:getPosition()

	if player then
	ppos:sendMagicEffect(CONST_ME_MAGIC_BLUE) 
	player:addHealth(life)
	player:say("Aaaah...")
	item:remove(1)
	end

 return true
end