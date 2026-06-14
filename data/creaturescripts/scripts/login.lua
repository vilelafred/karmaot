function onLogin(player)
	local loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"

	local capFree = getPlayerFreeCap(player)
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	local backpackFreeSlots = nil
	if backpack then
		backpackFreeSlots = getContainerSlotsFree(backpack.uid)
	end

	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		local lastLogin = player:getLastLoginSaved()
		loginStr = string.format("Your last visit was on %s.", os.date("%a %b %d %X %Y", lastLogin))
		local fid = getPlayerGUID(player)
		local lastLogout = os.date("%a %b %d %X %Y", getLastLogout(fid))
		strTimeNow = "Last logout " .. lastLogout .. "."
		doPlayerSendTextMessage(player, MESSAGE_STATUS_DEFAULT, strTimeNow)
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	-- Stamina
	nextUseStaminaTime[player.uid] = 0

	-- Channel Loot
	player:openChannel(9)

	-- Premium Bonus
	if player:isPremium() then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You have 50% more experience for being a Premium Account.")
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Become a Premium Account and get 50% more experience.")
	end

	-- Activate Custom Item Attributes
	for i = 1,10 do
		local item = player:getSlotItem(i)
		if item then
			itemAttributes(player, item, i, true)
		end
	end

	-- If player logged with more 'current health' than their db 'max health' due to an item attribute
	local query = db.storeQuery("SELECT `health`,`mana` FROM players where `id`="..player:getGuid())
	if query then
		local health = tonumber(result.getDataString(query, 'health'))
		local mana = tonumber(result.getDataString(query, 'mana'))
		local playerHealth = player:getHealth()
		local playerMana = player:getMana()
		if playerHealth < health then
			player:addHealth(health - playerHealth)
		end
		if playerMana < mana then
			player:addMana(mana - playerMana)
		end
		result.free(query)
	end

	if player:getStorageValue(2038) == 1 then -- Task System register if still has task
		player:registerEvent("TaskKiller")
	end

	-- ⚠️ Removido temporariamente pra evitar erro!
	-- if tasks then
	--     tasks:updateTasks(player)
	-- end

	-- Events
	player:registerEvent("Multishot")
	-- PvP damage scalingInboxToDepotOnLogin
	player:registerEvent("InboxToDepotOnLogin")
	player:registerEvent("MarketReconcile")
	player:registerEvent("MarketSellerReconcile")
	player:registerEvent("PvpHealthReduction")
	player:registerEvent("PvpManaReduction")
	player:registerEvent("TaskSystem")
	player:registerEvent("levelSave")	
	player:registerEvent("PlayerDeath")
	player:registerEvent("RatKill")
	player:registerEvent("DropLoot")
	player:registerEvent("HPadvance")
	player:registerEvent("Killed")
	player:registerEvent("Shop")
	player:registerEvent("TaskKill")
	player:registerEvent("randomstats_loot")
	player:registerEvent("rollHealth")
	player:registerEvent("rollMana")
	player:registerEvent("ModalWindowHelper")
	player:registerEvent("AutoBank")
	player:registerEvent("AutoBankEquip")
	player:registerEvent("AutoBankDeEquip")
	player:registerEvent("criticalHitSystemXHP")
    player:registerEvent("criticalHitSystemXMP")
	player:registerEvent("SpeedBalancerLogin")
	player:registerEvent("SpeedBalancerAdvance")	
	
	
	
		-- Sanitize storages de Task para evitar contagem negativa
	if TaskSystem and TaskSystem.sanitizePlayer then
		TaskSystem.sanitizePlayer(player)
	end

	player:loadVipData()
	player:updateVipTime()
	player:setStorageValue(9999, player:getVipDays())
	return true
end
