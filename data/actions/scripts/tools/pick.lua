local groundIds = {354, 355}
local groundSecret = 352
local actionSecret = 14000
local backSecret = 14003
local effectsSecret = {CONST_ME_BLOCKHIT, CONST_ME_POFF}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 11227 then -- shiny stone refining
		local chance = math.random(1, 100)
		if chance == 1 then
			player:addItem(ITEM_CRYSTAL_COIN) -- 1% chance of getting crystal coin
		elseif chance <= 6 then
			player:addItem(ITEM_GOLD_COIN) -- 5% chance of getting gold coin
		elseif chance <= 51 then
			player:addItem(ITEM_PLATINUM_COIN) -- 45% chance of getting platinum coin
		else
			player:addItem(2145) -- 49% chance of getting small diamond
		end
		target:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		target:remove(1)
		return true
	end

	local tile = Tile(toPosition)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground then
		return false
	end

	math.randomseed(os.time())

	if target.itemid == groundSecret then
		if ground.actionid == actionSecret or ground.actionid == backSecret then
			local random = string.format("%.1f", math.random())
			if random == '0.1' then
				ground:transform(392)
				if ground.actionid == actionSecret then
					doPlayerSendTextMessage(player, 22, "You found a secret passage.")
				end
			else
				local sortEffect = math.random(#effectsSecret)
				target:getPosition():sendMagicEffect(effectsSecret[sortEffect])
			end
		end
	end

	if (ground.uid > 65535 or ground.actionid == 0) and not table.contains(groundIds, ground.itemid) then
		return false
	end

	if ground.actionid == 0 or ground.actionid == nil then
		return false
	else
		ground:transform(392)
		ground:decay()

		toPosition.z = toPosition.z + 1
		tile:relocateTo(toPosition)
	end
	return true
end
