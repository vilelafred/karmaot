-- Auto Loot Sell Item
-- Based on Thaddeus NPC system, but without the 20% bonus
-- Fixed version - sells items from main backpack and loot pouch (ID 5872)

-- List of sellable items (without the 20% bonus from Thaddeus)
local sellableItems = {
    -- Shadow Sceptre
    {itemId = 7576, price = 10000, name = "shadow sceptre"},
    -- Compass
    {itemId = 8069, price = 700, name = "compass"},
    -- Old Robe
    {itemId = 2655, price = 700, name = "old robe"},
    -- Red Robe
    {itemId = 5780, price = 80000, name = "red robe"},
    -- Alpha Scale Mail
    {itemId = 5799, price = 80000, name = "alpha scale mail"},
    -- Royal Crossbow
    {itemId = 7592, price = 150000, name = "royal crossbow"},
    -- Skullcracker Armor
    {itemId = 7624, price = 18000, name = "skullcracker armor"},
    -- Glacier Kilt
    {itemId = 7904, price = 11000, name = "glacier kilt"},
    -- Hammer of Wrath
    {itemId = 2444, price = 30000, name = "hammer of wrath"},
    -- Demon Horn
    {itemId = 5908, price = 10000, name = "demon horn"},
    -- Fiery Shield
    {itemId = 7633, price = 50000, name = "fiery shield"},
    -- Rainbow Shield
    {itemId = 7632, price = 90000, name = "rainbow shield"},
    -- Alpha Scale Armor
    {itemId = 6117, price = 50000, name = "alpha scale armor"},
    -- Robe of the Underworld
    {itemId = 7625, price = 60000, name = "robe of the underworld"},
    -- Earthborn Titan Armor
    {itemId = 7617, price = 60000, name = "earthborn titan armor"},
    -- Nightmare Blade
    {itemId = 7434, price = 35000, name = "nightmare blade"},
    -- Assassin Dagger
    {itemId = 7420, price = 20000, name = "assassin dagger"},
    -- Magma Set
    {itemId = 6872, price = 11000, name = "magma coat"},
    {itemId = 6873, price = 11000, name = "magma monocle"},
    {itemId = 6869, price = 11000, name = "magma legs"},
    {itemId = 6867, price = 11000, name = "magma boots"},
    -- Lightning Set
    {itemId = 6868, price = 11000, name = "lightning boots"},
    {itemId = 6874, price = 11000, name = "lightning glasses"},
    {itemId = 6871, price = 11000, name = "lightning armor"},
    {itemId = 6870, price = 11000, name = "lightning legs"},
    {itemId = 5810, price = 11000, name = "red legs"},	
    {itemId = 5796, price = 11000, name = "red magician hat"},		
    -- Terra Set
    {itemId = 6863, price = 11000, name = "terra legs"},
    {itemId = 6875, price = 2500, name = "terra hood"},
    {itemId = 6862, price = 11000, name = "terra mantle"},
    {itemId = 6865, price = 1500, name = "terra amulet"},
    -- Tempest Shield
    {itemId = 2542, price = 100000, name = "tempest shield"},
    -- Sword of Queen
    {itemId = 6183, price = 120000, name = "sword of queen"},
    -- Queen Set
    {itemId = 6178, price = 50000, name = "queen legs"},
    {itemId = 6177, price = 100000, name = "queen helmet"},
    -- Blue Items
    {itemId = 5966, price = 1000, name = "blue wing"},
    {itemId = 2576, price = 1000, name = "blue vase"},
    {itemId = 2138, price = 10000, name = "sapphire amulet"},
    {itemId = 5964, price = 2000, name = "blue scale"},
    -- Golden Items
    {itemId = 2130, price = 2000, name = "golden amulet"},
    {itemId = 2154, price = 900, name = "yellow gem"},
    {itemId = 2137, price = 3000, name = "golden fruits"},
    {itemId = 5968, price = 3000, name = "yellow scale"},
    {itemId = 5959, price = 900, name = "white xscale"},
    {itemId = 5969, price = 10000, name = "golden egg"},
    {itemId = 5970, price = 9000, name = "yellow wing"},
    -- Armors
    {itemId = 2503, price = 30000, name = "dwarven armor"},
    {itemId = 2466, price = 20000, name = "golden armor"},
    {itemId = 3968, price = 1000, name = "leopard armor"},
    {itemId = 2472, price = 90000, name = "magic plate armor"},
    {itemId = 2463, price = 400, name = "plate armor"},
    {itemId = 7626, price = 15000, name = "paladin armor"},	
    -- Shields
    {itemId = 5781, price = 30000, name = "dread shield"},
    {itemId = 6179, price = 30000, name = "dread armor"},
    {itemId = 2520, price = 30000, name = "demon shield"},
    {itemId = 2536, price = 9000, name = "medusa shield"},
    {itemId = 2540, price = 2000, name = "scarab shield"},
    {itemId = 2514, price = 50000, name = "mastermind shield"},
    -- Helmets
    {itemId = 3972, price = 7500, name = "beholder helmet"},
    {itemId = 2462, price = 1000, name = "devil helmet"},
    {itemId = 2493, price = 90000, name = "demon helmet"},
    {itemId = 5973, price = 90000, name = "black demon helmet"},
    -- Boots
    {itemId = 3892, price = 1000, name = "crocodile boots"},
    {itemId = 2645, price = 30000, name = "steel boots"},
    -- Weapons
    {itemId = 2439, price = 110, name = "daramanian mace"},
    {itemId = 2440, price = 1000, name = "daramanian waraxe"},
    {itemId = 2427, price = 11000, name = "guardian halberd"},
    {itemId = 6173, price = 30000, name = "dread helmet"},	
    {itemId = 2442, price = 90, name = "heavy machete"},
    {itemId = 2402, price = 500, name = "silver dagger"},
    {itemId = 2454, price = 9000, name = "war axe"},
    {itemId = 2142, price = 200, name = "ancient amulet"},
    {itemId = 7418, price = 15000, name = "dragon slayer"},
    {itemId = 2470, price = 70000, name = "golden legs"},	
    -- Amulets and Rings
    {itemId = 2125, price = 400, name = "crystal necklace"},
    {itemId = 2124, price = 250, name = "crystal ring"},
    {itemId = 2136, price = 32000, name = "demonbone amulet"},
    {itemId = 2127, price = 800, name = "emerald bangle"},
    {itemId = 2179, price = 8000, name = "golden ring"},
    {itemId = 2171, price = 2500, name = "platinum amulet"},
    {itemId = 2123, price = 30000, name = "ring of the sky"},
    {itemId = 2133, price = 2000, name = "ruby necklace"},
    {itemId = 2135, price = 200, name = "scarab amulet"},
    {itemId = 2134, price = 150, name = "silver brooch"},
    {itemId = 2151, price = 150, name = "talon"},	
    -- Dolls
    {itemId = 2100, price = 200, name = "doll"},
    {itemId = 3955, price = 400, name = "voodoo doll"},
    -- More Weapons
    {itemId = 2409, price = 900, name = "serpent sword"},
    {itemId = 2434, price = 2000, name = "dragon hammer"},
    {itemId = 2393, price = 17000, name = "giant sword"},
    {itemId = 2411, price = 50, name = "poison dagger"},
    {itemId = 2419, price = 150, name = "scimitar"},
    {itemId = 2436, price = 6000, name = "skull staff"},
    {itemId = 2430, price = 2000, name = "knight axe"},
    -- More Shields
    {itemId = 2528, price = 8000, name = "tower shield"},
    {itemId = 2529, price = 800, name = "black shield"},
    {itemId = 2532, price = 900, name = "ancient shield"},
    {itemId = 2534, price = 15000, name = "vampire shield"},
    -- More Armors
    {itemId = 2475, price = 5000, name = "warrior helmet"},
    {itemId = 2476, price = 5000, name = "knight armor"},
    {itemId = 2477, price = 5000, name = "knight legs"},
    {itemId = 2479, price = 500, name = "strange helmet"},
    {itemId = 2489, price = 400, name = "dark armor"},
    {itemId = 2490, price = 250, name = "dark helmet"},
    {itemId = 2663, price = 150, name = "mystic turban"},
    -- More Weapons
    {itemId = 2383, price = 1000, name = "spike sword"},
    {itemId = 2392, price = 4000, name = "fire sword"},
    {itemId = 2391, price = 1200, name = "war hammer"},
    {itemId = 2396, price = 1000, name = "ice rapier"},
    {itemId = 2413, price = 500, name = "broad sword"},
    {itemId = 2414, price = 9000, name = "dragon lance"},
    {itemId = 2425, price = 500, name = "obsidian lance"},
    {itemId = 2432, price = 8000, name = "fire axe"},
    -- More Shields
    {itemId = 2515, price = 2000, name = "guardian shield"},
    {itemId = 2516, price = 4000, name = "dragon shield"},
    {itemId = 2518, price = 1200, name = "beholder shield"},
    {itemId = 2519, price = 8000, name = "crown shield"},
    {itemId = 2539, price = 16000, name = "phoenix shield"},
    -- Crown Set
    {itemId = 2486, price = 900, name = "noble armor"},
    {itemId = 2487, price = 12000, name = "crown armor"},
    {itemId = 2488, price = 12000, name = "crown legs"},
    {itemId = 2491, price = 2500, name = "crown helmet"},
    -- More Helmets
    {itemId = 2497, price = 6000, name = "crusader helmet"},
    {itemId = 2498, price = 30000, name = "royal helmet"},
    {itemId = 5798, price = 35000, name = "grey helmet"},
    -- More Robes and Armors
    {itemId = 2656, price = 10000, name = "blue robe"},
    {itemId = 2195, price = 30000, name = "boots of haste"},
    {itemId = 2492, price = 40000, name = "dragon scale mail"},
    -- Magic Items
    {itemId = 2162, price = 35, name = "magic lightwand"},
    {itemId = 2198, price = 100, name = "elven amulet"},
    {itemId = 2199, price = 50, name = "garlic necklace"},
    {itemId = 2172, price = 50, name = "bronze amulet"},
    {itemId = 2178, price = 100, name = "mind stone"},
    {itemId = 2177, price = 50, name = "life crystal"},
    {itemId = 2176, price = 750, name = "orb"},
    -- Wands
    {itemId = 2190, price = 100, name = "wand of vortex"},
    {itemId = 2191, price = 200, name = "wand of dragonbreath"},
    {itemId = 2188, price = 1000, name = "wand of plague"},
    {itemId = 2189, price = 2000, name = "wand of cosmic energy"},
    {itemId = 2187, price = 3000, name = "wand of inferno"},
    {itemId = 6086, price = 5000, name = "sunfire wand"},
    -- More Amulets
    {itemId = 2170, price = 50, name = "silver amulet"},
    {itemId = 2161, price = 30, name = "strange talisman"},
    {itemId = 2200, price = 100, name = "protection amulet"},
    {itemId = 2201, price = 100, name = "dragon necklace"},
    {itemId = 2194, price = 50, name = "mysterious fetish"},
    {itemId = 2193, price = 100, name = "ankh"},
    -- Rods
    {itemId = 2182, price = 100, name = "snakebite rod"},
    {itemId = 2186, price = 200, name = "moonlight rod"},
    {itemId = 2185, price = 1000, name = "volcanic rod"},
    {itemId = 2181, price = 2000, name = "quagmire rod"},
    {itemId = 2183, price = 3000, name = "tempest rod"},
    -- Basic Weapons
    {itemId = 2377, price = 450, name = "two handed sword"},
    {itemId = 2378, price = 80, name = "battle axe"},
    {itemId = 2379, price = 2, name = "dagger"},
    {itemId = 2380, price = 4, name = "hand axe"},
    {itemId = 2381, price = 400, name = "halberd"},
    {itemId = 2384, price = 5, name = "rapier"},
    {itemId = 2385, price = 12, name = "sabre"},
    {itemId = 2389, price = 3, name = "spear"},
    {itemId = 2394, price = 90, name = "morning star"},
    {itemId = 2398, price = 30, name = "mace"},
    {itemId = 2406, price = 10, name = "short sword"},
    {itemId = 2417, price = 120, name = "battle hammer"},
    {itemId = 6154, price = 19000, name = "skull hammer"},
    {itemId = 2376, price = 25, name = "sword"},
    -- Gems and Coins
    {itemId = 2159, price = 100, name = "scarab coin"},
    {itemId = 2143, price = 160, name = "white pearl"},
    {itemId = 2144, price = 280, name = "black pearl"},
    {itemId = 2145, price = 300, name = "small diamond"},
    {itemId = 2146, price = 250, name = "small sapphire"},
    {itemId = 2147, price = 250, name = "small ruby"},
    {itemId = 2149, price = 250, name = "small emerald"},
    {itemId = 2150, price = 200, name = "small amethyst"},
    {itemId = 6172, price = 5000, name = "swamp amulet"},
    -- Brass Set
    {itemId = 2465, price = 150, name = "brass armor"},
    {itemId = 2478, price = 49, name = "brass legs"},
    {itemId = 2460, price = 30, name = "brass helmet"},
    {itemId = 2510, price = 45, name = "plate shield"},
    {itemId = 2511, price = 25, name = "brass shield"},
    -- Other Armors
    {itemId = 2483, price = 75, name = "scale armor"},
    {itemId = 2457, price = 250, name = "steel helmet"},
    {itemId = 2387, price = 260, name = "double axe"},
    {itemId = 2455, price = 120, name = "crossbow"},
    {itemId = 2648, price = 80, name = "chain legs"},
    {itemId = 2464, price = 70, name = "chain armor"},
    {itemId = 2388, price = 25, name = "hatchet"},
	{itemId = 2173, price = 30000, name = "amulet of loss"},
	{itemId = 2522, price = 120000, name = "old great shield"},
	{itemId = 2469, price = 150000, name = "dragon scale legs"},
	{itemId = 2506, price = 120000, name = "dragon scale helmet"},
	
}

-- Create a lookup table for faster access
local sellableItemsLookup = {}
for _, itemInfo in ipairs(sellableItems) do
    sellableItemsLookup[itemInfo.itemId] = itemInfo
end

-- Function to count items in main backpack only (no nested containers)
local function countItemsInMainBackpack(player, itemId)
    if not player or not itemId then
        return 0
    end
    
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack then
        return 0
    end
    
    local count = 0
    local size = backpack:getSize()
    
    for i = 0, size-1 do
        local item = backpack:getItem(i)
        if item and item:getId() == itemId then
            count = count + item:getCount()
        end
    end
    
    return count
end

-- Function to remove items from main backpack only (no nested containers)
local function removeItemsFromMainBackpack(player, itemId, count)
    if not player or not itemId or count <= 0 then
        return 0
    end
    
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack then
        return 0
    end
    
    local removed = 0
    local size = backpack:getSize()
    
    for i = size-1, 0, -1 do
        if removed >= count then
            break
        end
        
        local item = backpack:getItem(i)
        if item and item:getId() == itemId then
            local itemCount = item:getCount()
            local toRemove = math.min(itemCount, count - removed)
            
            if toRemove >= itemCount then
                item:remove()
                removed = removed + itemCount
            else
                item:setCount(itemCount - toRemove)
                removed = removed + toRemove
            end
        end
    end
    
    return removed
end

-- Function to find loot pouch in player's inventory
local function findLootPouch(player)
    if not player then
        return nil
    end
    
    -- Check main backpack
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if backpack then
        local size = backpack:getSize()
        for i = 0, size-1 do
            local item = backpack:getItem(i)
            if item and item:getId() == 5872 then -- Loot Pouch ID
                return item
            end
        end
    end
    
    return nil
end

-- Function to count items in loot pouch
local function countItemsInLootPouch(player, itemId)
    if not player or not itemId then
        return 0
    end
    
    local lootPouch = findLootPouch(player)
    if not lootPouch then
        return 0
    end
    
    local count = 0
    local size = lootPouch:getSize()
    
    for i = 0, size-1 do
        local item = lootPouch:getItem(i)
        if item and item:getId() == itemId then
            count = count + item:getCount()
        end
    end
    
    return count
end

-- Function to remove items from loot pouch
local function removeItemsFromLootPouch(player, itemId, count)
    if not player or not itemId or count <= 0 then
        return 0
    end
    
    local lootPouch = findLootPouch(player)
    if not lootPouch then
        return 0
    end
    
    local removed = 0
    local size = lootPouch:getSize()
    
    for i = size-1, 0, -1 do
        if removed >= count then
            break
        end
        
        local item = lootPouch:getItem(i)
        if item and item:getId() == itemId then
            local itemCount = item:getCount()
            local toRemove = math.min(itemCount, count - removed)
            
            if toRemove >= itemCount then
                item:remove()
                removed = removed + itemCount
            else
                item:setCount(itemCount - toRemove)
                removed = removed + toRemove
            end
        end
    end
    
    return removed
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not player or not item then
        return false
    end
    
    -- Check if player has loot pouch
    local hasLootPouch = findLootPouch(player) ~= nil
    
    -- Show info message
    if hasLootPouch then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto Loot Sell: Selling items from main backpack and loot pouch.")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Auto Loot Sell: Selling only items from main backpack (equipped).")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Items in nested backpacks will NOT be sold.")
    end
    
    local totalGold = 0
    local soldItems = {}
    local soldCount = 0
    local processedItems = {} -- Track processed items to avoid duplication
    
    -- Process each sellable item
    for itemId, itemInfo in pairs(sellableItemsLookup) do
        local totalCount = 0
        local backpackCount = 0
        local lootPouchCount = 0
        
        -- Count items in main backpack
        backpackCount = countItemsInMainBackpack(player, itemId)
        
        -- Count items in loot pouch (if exists)
        if hasLootPouch then
            lootPouchCount = countItemsInLootPouch(player, itemId)
        end
        
        totalCount = backpackCount + lootPouchCount
        
        if totalCount > 0 then
            local totalPrice = itemInfo.price * totalCount
            local totalRemoved = 0
            
            -- Remove items from main backpack first
            if backpackCount > 0 then
                local removedFromBackpack = removeItemsFromMainBackpack(player, itemId, backpackCount)
                totalRemoved = totalRemoved + removedFromBackpack
            end
            
            -- Remove items from loot pouch
            if hasLootPouch and lootPouchCount > 0 then
                local removedFromLootPouch = removeItemsFromLootPouch(player, itemId, lootPouchCount)
                totalRemoved = totalRemoved + removedFromLootPouch
            end
            
            -- Only add to total if items were actually removed
            if totalRemoved > 0 then
                totalGold = totalGold + (itemInfo.price * totalRemoved)
                table.insert(soldItems, totalRemoved .. "x " .. itemInfo.name .. " (" .. (itemInfo.price * totalRemoved) .. " gp)")
                soldCount = soldCount + 1
                
                -- Mark this item as processed to prevent duplication
                processedItems[itemId] = true
            end
        end
    end
    
    -- Add money to player (only once to prevent duplication)
    if totalGold > 0 then
        player:addMoney(totalGold)
        
        -- Show sales report
        local message = "Auto Loot Sell - Items sold:\n"
        for i, soldItem in ipairs(soldItems) do
            message = message .. soldItem .. "\n"
        end
        message = message .. "\nTotal received: " .. totalGold .. " gold coins"
        
        if hasLootPouch then
            message = message .. "\n(Processed from main backpack and loot pouch)"
        end
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message)
        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        
        -- Log successful transaction
        print("[Auto Sell] Player " .. player:getName() .. " sold " .. soldCount .. " items for " .. totalGold .. " gold" .. (hasLootPouch and " (including loot pouch)" or ""))
    else
        local noItemsMessage = "Auto Loot Sell: No sellable items found"
        if hasLootPouch then
            noItemsMessage = noItemsMessage .. " in your main backpack or loot pouch."
        else
            noItemsMessage = noItemsMessage .. " in your main backpack (equipped)."
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, noItemsMessage)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
    
    return true
end
