-- Animações de Raridade
local rare_popup = true
local rare_effect = true
local rare_effect_id = 56
local pouchContainerId = 5872 
-- check if player has loot pouch in backpack
function getLootPouch(player)
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack then
        return false
    end

    -- recursive function to check inside containers
    local function checkContainer(container)
        if not container:isContainer() then
            return false
        end

        for i = 0, container:getSize() - 1 do
            local item = container:getItem(i)
            if item then
                if item:getId() == pouchContainerId then
                    return item
                elseif item:isContainer() then
					local check = checkContainer(item)
                    if check then
                        return check
                    end
                end
            end
        end
        return false
    end

    return checkContainer(backpack)
end

local function scanContainer(cid, position)
    local player = Player(cid)
    if not player then
        return true
    end
    local corpse = Tile(position):getTopDownItem()
    if not corpse or not corpse:isContainer() then
        return true
    end
    if corpse:getType():isCorpse() and corpse:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == cid then
		if corpse:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == cid then
			for a = corpse:getSize() - 1, 0, -1 do
				local containerItem = corpse:getItem(a)
				if containerItem then
					for b = AUTOLOOT_STORAGE_START, AUTOLOOT_STORAGE_END do
						if player:getStorageValue(b) == containerItem:getId() then
							local pouch = getLootPouch(player)
							if pouch then
								containerItem:moveTo(pouch)
							else
								containerItem:moveTo(player)
							end
							player:sendTextMessage(MESSAGE_INFO_DESCR, "You have Auto-looted ".. containerItem:getCount() .."x ".. containerItem:getName() ..".")
						end              
					end
				end
			end
		end
    end
end

function Monster:onDropLoot(corpse)
    if not self or not isMonster(self) then return end
	local player = Player(corpse:getCorpseOwner())
    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then return end

    local monsterLvl = self:getMonsterLevel()
    if not monsterLvl then return end

    local customRate = 6
    local newLootRate = monsterLvl * customRate

    local mType = self:getType()

    local bonusRingUsed = false -- flag para saber se o lucky ring foi ativado

    if not player or player:getStamina() > 840 then
        local monsterLoot = mType:getLoot()

        for i = 1, #monsterLoot do
            local default = monsterLoot[i]

            -- Verifica se o Lucky Ring (ID 8323) está equipado
            local ring = player and player:getSlotItem(CONST_SLOT_RING)
            if ring and ring:getId() == 8323 and default.chance < 100000 then
                local bonus = math.floor(default.chance * 0.20)
                default.chance = math.min(100000, default.chance + bonus)
                bonusRingUsed = true
            end

            -- Aplica o rate baseado no nível do monstro
            if default.chance < 100000 then
                default.chance = default.chance + (newLootRate * (default.chance / 100))
            end

            -- Cria o item no corpo
            local item = corpse:createLootItem(default)
            if not item then
                print('[Warning] DropLoot:', 'Could not add loot item to corpse.')
            end
        end

        -- Aplica raridade visual se necessário
        if rollRarity(corpse) > 0 then
            if rare_popup then
                local spectators = Game.getSpectators(corpse:getPosition(), false, true, 7, 7, 5, 5)
                for i = 1, #spectators do
                    spectators[i]:say(rare_text, TALKTYPE_MONSTER_SAY, false, spectators[i], corpse:getPosition())
                end
            end
            if rare_effect then
                corpse:getPosition():sendMagicEffect(rare_effect_id)
            end
        end
    end

    if player then
        local text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())

        -- Anexa "(lucky ring activated)" se o bônus foi aplicado
        if bonusRingUsed then
            text = text .. " (lucky ring activated)"
        end

        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, text)
        end
	if player then
		player:updateKillTracker(self, corpse)
	end
	scanContainer(player:getId(), self:getPosition())
    end
end

function Monster:onSpawn(position, startup, artificial)
    self:registerEvent("rollHealth")
    self:registerEvent("rollMana")
    return true
end
