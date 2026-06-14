-- Karma Stones Shop - Craft System Style
-- Use item ID 6001 to open

local PRICE_FIRST = 10000000  -- 10kk
local PRICE_SECOND = 15000000 -- 15kk  
local PRICE_CLEANSING = 5000000 -- 5kk

-- Get total stone count (inventory + active on amulet) for pricing
-- This prevents exploit: player can't buy all stones at 10kk by storing them
local function getStoneCount(player)
    local stoneIds = {8277, 8280, 8276, 8282, 8278, 8283, 8279} -- Protection stones only
    local inventoryCount = 0
    
    -- Count stones in inventory/backpack
    for _, stoneId in ipairs(stoneIds) do
        inventoryCount = inventoryCount + player:getItemCount(stoneId)
    end
    
    -- Count active stones on equipped amulet
    local activeCount = 0
    local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
    if amulet then
        local itemId = amulet:getId()
        if itemId == 6161 or itemId == 6550 or itemId == 6525 then
            local data = amulet:getCustomAttribute("karma_stones")
            if data and data ~= "" then
                local success, stones = pcall(json.decode, data)
                if success and type(stones) == "table" then
                    for _, stone in pairs(stones) do
                        if stone.remaining and stone.remaining > 0 then
                            activeCount = activeCount + 1
                        end
                    end
                end
            end
        end
    end
    
    return inventoryCount + activeCount
end

-- Get active stone count from equipped amulet (for display)
local function getActiveStoneCount(player)
    local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
    if not amulet then
        return 0
    end
    
    local itemId = amulet:getId()
    if itemId ~= 6161 and itemId ~= 6550 and itemId ~= 6525 then
        return 0
    end
    
    local data = amulet:getCustomAttribute("karma_stones")
    if not data or data == "" then
        return 0
    end
    
    local success, stones = pcall(json.decode, data)
    if not success or type(stones) ~= "table" then
        return 0
    end
    
    local count = 0
    for _, stone in pairs(stones) do
        if stone.remaining and stone.remaining > 0 then
            count = count + 1
        end
    end
    
    return count
end

local config = {
    mainTitleMsg = "Karma Stone Shop",
    mainMsg = "Welcome to the Karma Stone Shop!\n\nProtection Stones add elemental protection to your Karma Amulet.\n\nPlease choose a category:",
    
    stoneTitle = "Karma Stones: ",
    stoneMsg = "Select a stone to view details.\n\nAvailable stones in category: ",
    needItems = "You don't have enough gold to buy ",
    
    system = {
        [1] = {
            tiers = "Protection Stones",
            items = {
                [1] = {
                    item = "Physical Protection Stone",
                    itemID = 8277,
                    count = 1,
                    element = "physical",
                    description = "+10% physical damage reduction for 4 hours of active use.\n\nBest for: Melee hunts, tanking heavy physical damage.\n\nRecommended: Knights, physical boss fights.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [2] = {
                    item = "Fire Protection Stone",
                    itemID = 8282,
                    count = 1,
                    element = "fire",
                    description = "+10% fire damage reduction for 4 hours of active use.\n\nBest for: Demon hunts, dragon spawns, fire bosses.\n\nRecommended: Ferumbras, Goshnar, Dragons.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [3] = {
                    item = "Ice Protection Stone",
                    itemID = 8278,
                    count = 1,
                    element = "ice",
                    description = "+10% ice damage reduction for 4 hours of active use.\n\nBest for: Frost dragon hunts, crystal spider spawns.\n\nRecommended: Ice-based hunts and bosses.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [4] = {
                    item = "Energy Protection Stone",
                    itemID = 8280,
                    count = 1,
                    element = "energy",
                    description = "+10% energy damage reduction for 4 hours of active use.\n\nBest for: Warlock spawns, energy bosses.\n\nRecommended: Lightning creatures, energy-based hunts.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [5] = {
                    item = "Earth Protection Stone",
                    itemID = 8276,
                    count = 1,
                    element = "earth",
                    description = "+10% earth damage reduction for 4 hours of active use.\n\nBest for: Poison/earth monster hunts.\n\nRecommended: Serpent hunts, earth elemental bosses.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [6] = {
                    item = "Death Protection Stone",
                    itemID = 8283,
                    count = 1,
                    element = "death",
                    description = "+10% death damage reduction for 4 hours of active use.\n\nBest for: Undead/necromantic hunts.\n\nRecommended: Vampire, lich, and death-based bosses.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                },
                [7] = {
                    item = "Holy Protection Stone",
                    itemID = 8279,
                    count = 1,
                    element = "holy",
                    description = "+10% holy damage reduction for 4 hours of active use.\n\nBest for: Holy-based monster hunts.\n\nRecommended: Inquisition spawns, angelic/demonic hunts.",
                    price = function(player) 
                        return getStoneCount(player) == 0 and PRICE_FIRST or PRICE_SECOND 
                    end
                }
            }
        },
        [2] = {
            tiers = "Special Stones",
            items = {
                [1] = {
                    item = "Cleansing Stone",
                    itemID = 8281,
                    count = 1,
                    element = "cleansing",
                    description = "Removes ALL active Protection Stones from a Karma Amulet.\n\nUse this to change your protection build without buying a new amulet.\n\nFixed price: 5kk (cheaper than protection stones!)",
                    price = function(player) 
                        return PRICE_CLEANSING 
                    end,
                    isCleansing = true
                }
            }
        }
    }
}

-- Main window (categories)
function Player:sendMainKarmaWindow(config)
    local function buttonCallback(button, choice)
        if button.text == "Select" then
            self:sendKarmaStoneWindow(config, choice.id)
        end
    end
    
    local window = ModalWindow {
        title = config.mainTitleMsg,
        message = config.mainMsg.."\n\n"
    }
    
    window:addButton("Select", buttonCallback)
    window:addButton("Exit", buttonCallback)
    
    for i = 1, #config.system do
        window:addChoice(config.system[i].tiers)
    end
    
    window:setDefaultEnterButton("Select")
    window:setDefaultEscapeButton("Exit")
    window:sendToPlayer(self)
end

-- Stone selection window
function Player:sendKarmaStoneWindow(config, lastChoice)
    local function buttonCallback(button, choice)
        if button.text == "Back" then
            self:sendMainKarmaWindow(config)
        end
        
        if button.text == "Details" then
            local stoneInfo = config.system[lastChoice].items[choice.id]
            local stoneCount = getStoneCount(self)
            local price = type(stoneInfo.price) == "function" and stoneInfo.price(self) or stoneInfo.price
            local priceText = string.format("%.0fkk", price / 1000000)
            
            local details = stoneInfo.item.."\n"
            details = details.."================================\n\n"
            details = details..stoneInfo.description
            details = details.."\n\n================================\n"
            details = details.."\nPrice: "..priceText
            
            if not stoneInfo.isCleansing then
                details = details.."\n(First stone: 10kk | Second stone: 15kk)"
            end
            
            local window = ModalWindow {
                title = "Stone Details",
                message = details,
            }
            window:addButton("Go Back", function() self:sendKarmaStoneWindow(config, lastChoice) end)
            window:sendToPlayer(self)
        end
        
        if button.text == "Buy" then
            local stoneInfo = config.system[lastChoice].items[choice.id]
            local price = type(stoneInfo.price) == "function" and stoneInfo.price(self) or stoneInfo.price
            
            -- Check capacity
            if self:getFreeCapacity() < 10 then
                self:say("You don't have enough capacity.", TALKTYPE_MONSTER_SAY)
                self:getPosition():sendMagicEffect(CONST_ME_POFF)
                return false
            end
            
            -- Check gold
            if not self:removeTotalMoney(price) then
                local priceText = string.format("%.0fkk", price / 1000000)
                self:say("You need "..priceText.." to buy this stone.", TALKTYPE_MONSTER_SAY)
                self:getPosition():sendMagicEffect(CONST_ME_POFF)
                return false
            end
            
            -- Give item
            local stoneItem = self:addItem(stoneInfo.itemID, stoneInfo.count)
            if not stoneItem then
                self:addMoney(price) -- Refund
                self:say("You don't have enough space in your inventory.", TALKTYPE_MONSTER_SAY)
                self:getPosition():sendMagicEffect(CONST_ME_POFF)
                return false
            end
            
            -- Success
            local priceText = string.format("%.0fkk", price / 1000000)
            self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You purchased "..stoneInfo.item.." for "..priceText.."!")
            self:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        end
    end
    
    local window = ModalWindow {
        title = config.stoneTitle..config.system[lastChoice].tiers,
        message = config.stoneMsg..config.system[lastChoice].tiers..".\n\n",
    }
    
    window:addButton("Back", buttonCallback)
    window:addButton("Exit")
    window:addButton("Details", buttonCallback)
    window:addButton("Buy", buttonCallback)
    window:setDefaultEnterButton("Buy")
    window:setDefaultEscapeButton("Exit")
    
    for i = 1, #config.system[lastChoice].items do
        window:addChoice(config.system[lastChoice].items[i].item)
    end
    
    window:sendToPlayer(self)
end

-- Action to open shop
local karmaStoneShop = Action()

function karmaStoneShop.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
    player:sendMainKarmaWindow(config)
    return true
end

karmaStoneShop:id(6108)
karmaStoneShop:register()

