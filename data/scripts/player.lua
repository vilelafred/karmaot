function Player:onBrowseField(position)
	return true
end

function Player:onLook(thing, position, distance)
	local description = "You see " .. thing:getDescription(distance)
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:isPlayer() and thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
        local client = thing:getClient()
				description = string.format("%s\nIP: %s PING: %i FPS: %i.", description, Game.convertIpToString(thing:getIp()), client.ping, client.fps)
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:isPlayer() and creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if creature:isPlayer() then
      local client = thing:getClient()
      description = string.format("%s\nIP: %s PING: %i FPS: %i.", description, Game.convertIpToString(thing:getIp()), client.ping, client.fps)
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if item:getAttribute("wrapid") ~= 0 then
		local tile = Tile(toPosition)
		if (fromPosition.x ~= CONTAINER_POSITION and toPosition.x ~= CONTAINER_POSITION) or tile and not tile:getHouse() then
			if tile and not tile:getHouse() then
				self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
				return false
			end
		end
	end

	if toPosition.x ~= CONTAINER_POSITION then
		return true
	end

	if item:getTopParent() == self and bit.band(toPosition.y, 0x40) == 0 then
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = self:getSlotItem(CONST_SLOT_RIGHT)
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = self:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return true
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:isContainer() and parent:getSize() == parent:getCapacity() then
				self:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM))
				return false
			else
				return moveItem:moveTo(parent)
			end
		end
	end

	return true
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

local function hasPendingReport(name, targetName, reportType)
	local f = io.open(string.format("data/reports/players/%s-%s-%d.txt", name, targetName, reportType), "r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	local name = self:getName()
	if hasPendingReport(name, targetName, reportType) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your report is being processed.")
		return
	end

	local file = io.open(string.format("data/reports/players/%s-%s-%d.txt", name, targetName, reportType), "a")
	if not file then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when processing your report, please contact a gamemaster.")
		return
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Reported by: " .. name .. "\n")
	io.write("Target: " .. targetName .. "\n")
	io.write("Type: " .. reportType .. "\n")
	io.write("Reason: " .. reportReason .. "\n")
	io.write("Comment: " .. comment .. "\n")
	if reportType ~= REPORT_TYPE_BOT then
		io.write("Translation: " .. translation .. "\n")
	end
	io.write("------------------------------\n")
	io.close(file)
	self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Thank you for reporting %s. Your report will be processed by %s team as soon as possible.", targetName, configManager.getString(configKeys.SERVER_NAME)))
	return
end

function Player:onReportBug(message, position, category)
	if self:getAccountType() == ACCOUNT_TYPE_NORMAL then
		return false
	end

	local name = self:getName()
	local file = io.open("data/reports/bugs/" .. name .. " report.txt", "a")

	if not file then
		self:sendTextMessage(MESSAGE_EVENT_DEFAULT, "There was an error when processing your report, please contact a gamemaster.")
		return true
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Name: " .. name)
	if category == BUG_CATEGORY_MAP then
		io.write(" [Map position: " .. position.x .. ", " .. position.y .. ", " .. position.z .. "]")
	end
	local playerPosition = self:getPosition()
	io.write(" [Player Position: " .. playerPosition.x .. ", " .. playerPosition.y .. ", " .. playerPosition.z .. "]\n")
	io.write("Comment: " .. message .. "\n")
	io.close(file)

	self:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Your report has been sent to " .. configManager.getString(configKeys.SERVER_NAME) .. ".")
	return true
end

function Player:onTurn(direction)
	return true
end

function Player:onTradeRequest(target, item)
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

function Player:onTradeCompleted(target, item, targetItem, isSuccess)
	return
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)

		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end

	return exp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	if skill == SKILL_MAGLEVEL then
		return tries * configManager.getNumber(configKeys.RATE_MAGIC)
	end
	return tries * configManager.getNumber(configKeys.RATE_SKILL)
end

function Player:onWrapItem(item, position)
	local topCylinder = item:getTopParent()
	if not topCylinder then
		return
	end

	local tile = Tile(topCylinder:getPosition())
	if not tile then
		return
	end

	local house = tile:getHouse()
	if not house then
		self:sendCancelMessage("You can only wrap and unwrap this item inside a house.")
		return
	end

	if house ~= self:getHouse() and not string.find(house:getAccessList(SUBOWNER_LIST):lower(), "%f[%a]" .. self:getName():lower() .. "%f[%A]") then
		self:sendCancelMessage("You cannot wrap or unwrap items from a house, which you are only guest to.")
		return
	end

	local wrapId = item:getAttribute("wrapid")
	if wrapId == 0 then
		return
	end

	local oldId = item:getId()
	item:remove(1)
	local item = tile:addItem(wrapId)
	if item then
		item:setAttribute("wrapid", oldId)
	end
end

function Player:onInventoryUpdate(item, slot, equip)
    itemAttributes(self, item, slot, equip)
    ItemAbilities.internalInventoryUpdate(self, item, slot, equip)
    
    if hasEventCallback(EVENT_CALLBACK_ONINVENTORYUPDATE) then
        EventCallback(EVENT_CALLBACK_ONINVENTORYUPDATE, self, item, slot, equip)
    end
end

function Player.onMoveItem(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
-- This is used to clean the forge and send contents to the players depot if they leave it there for X amount of time
    function abandonedItem(playerId, anvilorworkbench, position)
        local itemtosend = false
        if anvilorworkbench == "workbench" then
            local workbench = Tile(position):getItemById(6047)
            if workbench and workbench:isContainer() then
                itemtosend = workbench:getItem(0)
            end
        elseif anvilorworkbench == "anvil" then
            local anvil = Tile(position):getItemById(6038)
            if anvil and anvil:isContainer() then
                itemtosend = anvil:getItem(0)
            end
        end
        if itemtosend then
            local player = false
            -- see if player is online
            for _, playersearch in ipairs(Game.getPlayers()) do
                if playersearch:getId() == playerId then
                    player = Player(playerId)
                end
            end
            -- player is online
            if player then
                local depot = player:getDepotChest(0, true)
                itemtosend:moveTo(depot)
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You have left an item unattended in the " .. anvilorworkbench .. " in the forge, it has been sent to your depot.")
                player:save()
                local resetstorage = 0
                if anvilorworkbench == "workbench" then
                    resetstorage = 30020
                elseif anvilorworkbench == "anvil" then
                    resetstorage = 30021
                end
                Game.setStorageValue(resetstorage, -1)
            else
                itemtosend:removeAttribute(ITEM_ATTRIBUTE_OWNER)
            end
        else
            return false
            -- Couldn't get item from anvil/forge for some reason
        end
    end
 
    if toCylinder and toCylinder:isItem() then
        -- Posições de workbench e anvil
        local workbenchPositions = {
            Position(32394, 32191, 7), -- Original
            Position(32389, 32191, 6), -- Nova
            Position(32399, 32191, 6), -- Nova
            Position(32108, 32177, 7)  -- Nova (pedido)
        }
        
        local anvilPositions = {
            Position(32397, 32191, 7), -- Original
            Position(32392, 32191, 6), -- Nova
            Position(32402, 32191, 6), -- Nova
            Position(32111, 32177, 7)  -- Nova (pedido)
        }

        if toCylinder:getId() == 6047 then -- Workbench
            -- Verificar se está colocando item em algum workbench
            for _, workbenchpos in ipairs(workbenchPositions) do
                if toPosition == workbenchpos then
                    local disenchantDesc = item:getAttribute(ITEM_ATTRIBUTE_ARTICLE)
                    if disenchantDesc:find "rare" or disenchantDesc:find "epic" or disenchantDesc:find "legendary" or disenchantDesc:find "dawnbreaker" then -- dawnbreaker is a custom weapon that may not exist on your server
                        item:setAttribute(ITEM_ATTRIBUTE_OWNER, self:getId())
                        Game.setStorageValue(30020, addEvent(abandonedItem, 60000, self:getId(), "workbench", workbenchpos))
                        return true
                    else
                        self:sendCancelMessage("You cannot disenchant regular items.")
                        return false
                    end
                end
            end
        elseif toCylinder:getId() == 6038 then -- Anvil
            -- Verificar se está colocando item em algum anvil
            for _, anvilpos in ipairs(anvilPositions) do
                if toPosition == anvilpos then
                    local disenchantDesc = item:getAttribute(ITEM_ATTRIBUTE_ARTICLE)
                    if disenchantDesc:find "rare" or disenchantDesc:find "epic" or disenchantDesc:find "legendary" or disenchantDesc:find "dawnbreaker" then
                        self:sendCancelMessage("This item is already enchanted.")
                        return false
                    elseif rollCheck(item) == false then
                        self:sendCancelMessage("This item cannot be enchanted here.")
                        return false
                    else
                        item:setAttribute(ITEM_ATTRIBUTE_OWNER, self:getId())
                        Game.setStorageValue(30021, addEvent(abandonedItem, 60000, self:getId(), "anvil", anvilpos))
                        return true
                    end
                end
            end
        end
    end
    if fromCylinder and fromCylinder:isItem() then -- trying to move item from workbench or anvil
        if fromCylinder:getId() == 6047 then -- Workbench
            local ownerId = item:getAttribute(ITEM_ATTRIBUTE_OWNER) -- check owner
            if ownerId ~= 0 then
                local myId = self:getId()
                if myId == ownerId then -- owner is trying to move their item
                    item:removeAttribute(ITEM_ATTRIBUTE_OWNER)
                    if Game.getStorageValue(30020) then
                        stopEvent(Game.getStorageValue(30020))
                        Game.setStorageValue(30020, -1)
                    end
                    return true
                else -- someone is trying to move someone elses item
                    self:sendCancelMessage("This item does not belong to you.")
                    return false
                end
            else -- item has been abandoned in the workbench for a while, you can have it
                self:sendTextMessage(MESSAGE_INFO_DESCR, "This item has been abandoned, it's now yours!")
            end
        elseif fromCylinder:getId() == 6038 then -- trying to move item from anvil
            local ownerId = item:getAttribute(ITEM_ATTRIBUTE_OWNER)
            if ownerId ~= 0 then
                local myId = self:getId()
                if myId == ownerId then
                    item:removeAttribute(ITEM_ATTRIBUTE_OWNER)
                    if Game.getStorageValue(30021) then
                        stopEvent(Game.getStorageValue(30021))
                        Game.setStorageValue(30021, -1)
                    end
                    return true
                else
                    self:sendCancelMessage("This item does not belong to you.")
                    return false
                end
            else
                self:sendTextMessage(MESSAGE_INFO_DESCR, "This item has been abandoned, it's now yours!")
            end
        end
    end
 
    return true
end