local itemRemove = 1355
local actionRemove = 14002
local effectsSecret = {CONST_ME_BLOCKHIT, CONST_ME_POFF}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	math.randomseed(os.time())

	if target.itemid == itemRemove and target.actionid == actionRemove then
		local chance = math.random(1, 10)
		if chance == 1 then
			target:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
			target:remove(1)
			return true
		else
			local sortEffect = math.random(#effectsSecret)
			target:getPosition():sendMagicEffect(effectsSecret[sortEffect])
		end
	end

	return true
end
