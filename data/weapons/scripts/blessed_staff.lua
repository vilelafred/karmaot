local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

function onGetFormulaValues(player, level, magicLevel)
	return -140, -200
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onUseWeapon(player, variant)
	local target = Creature(variant.number)
	if not target then return false end

	-- ⚡ Efeito visual da SD voando
	player:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SUDDENDEATH)

	-- 🔋 Consumo de mana manual
	if player:getMana() < 30 then
		player:sendCancelMessage("Not enough mana.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	player:addMana(-25)

	-- ☠️ Dano físico
	return combat:execute(player, variant)
end
