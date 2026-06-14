function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local demonKnightLookType = 710
	local ownerStorage = 1220799 -- usado no player pra salvar que ele é o dono

	-- Verifica se o item já tem um dono salvo
	local ownerGuid = item:getAttribute(ITEM_ATTRIBUTE_TEXT)
	local ownerName = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)

	-- Se ainda não tem dono, define esse player como o primeiro dono
	if not ownerGuid or ownerGuid == "" then
		ownerGuid = tostring(player:getGuid())
		ownerName = player:getName()

		item:setAttribute(ITEM_ATTRIBUTE_TEXT, ownerGuid)
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This artifact belongs to: " .. ownerName)
		player:setStorageValue(ownerStorage, 1)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are now the exclusive owner of this King artifact.")
	end

	-- Verifica se o player é o dono do item
	if tostring(player:getGuid()) ~= ownerGuid then
		player:sendCancelMessage("Only " .. (ownerName or "the original owner") .. " can use this King artifact.")
		return true
	end

	-- Verifica se já está transformado
	if player:getOutfit().lookType == demonKnightLookType then
		player:sendCancelMessage("You are already transformed into a King.")
		return true
	end

	-- Aplica a transformação
	local outfit = player:getOutfit()
	outfit.lookType = demonKnightLookType
	player:setOutfit(outfit)

	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You transformed into a King!")

	return true
end
