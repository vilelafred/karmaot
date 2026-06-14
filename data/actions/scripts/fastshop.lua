function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local aid = item.actionid

	local shopItems = {
		-- 🧿 Amuletos, varinhas, anéis e rods
		[7001] = {2201, 1, 1000, 200},
		[7002] = {2200, 1, 700, 250},
		[7003] = {2199, 1, 15000, 150},
		[7004] = {2197, 1, 25000, 5},
		[7005] = {2171, 1, 5000},
		[7006] = {2173, 1, 50000},
		[7007] = {2190, 1, 500},
		[7008] = {2191, 1, 100},
		[7009] = {2188, 1, 5000},
		[7010] = {2189, 1, 10000},
		[7011] = {2187, 1, 30000},
		[7012] = {2182, 1, 500},
		[7013] = {2181, 1, 3000},
		[7014] = {2185, 1, 4000},
		[7015] = {2186, 1, 1500},
		[7016] = {2183, 1, 30000},
		[7017] = {2164, 1, 25000, 20},
		[7018] = {2168, 1, 900},
		[7019] = {2214, 1, 2000},
		[7020] = {2281, 100, 45000},		
		[7021] = {6656, 100, 100000},	
		[7022] = {2284, 100, 180000},
		[7023] = {2300, 100, 130000},	
		[7024] = {6659, 100, 300000},	
		[7025] = {6660, 100, 400000},				
		
		-- 🏹 Arrows, Bolts e Stars
		[6999] = {7738, 100, 9000},   -- Earth Arrows
		[6998] = {7688, 100, 9000},   -- Energy Arrows (Flash)
		[6997] = {7689, 100, 90000},   -- Ice Arrows (Shiver)
		[6996] = {7690, 100, 90000},   -- Flame Arrows
		[6995] = {7692, 100, 9000},   -- Sniper Arrows
		[6994] = {7693, 100, 9000},   -- Onyx Arrows (Simples)
		[6993] = {7691, 100, 25000},  -- Piercing Bolts
		[6992] = {7694, 100, 9000},   -- Viper Stars
		[6991] = {7696, 100, 10000},  -- Assassin Stars
		[6990] = {2547, 100, 700},    -- Power Bolts
		[6989] = {2543, 100, 300},    -- Bolts
		[6988] = {2545, 100, 10000},  -- Poison Arrows
		[6987] = {2546, 100, 25000},  -- Burst Arrows
		[6986] = {2169, 1, 2000},  -- Time Ring
		
		-- 🎒 Alchemist Style Backpacks
		[7199] = {5865, 1, 50000}, -- Alchemist's Backpack
		[7198] = {5866, 1, 50000}, -- Venomous Flask Backpack
		[7197] = {5867, 1, 50000}, -- Mystic Essence Backpack
		[7196] = {5868, 1, 50000}, -- Pyromancer's Backpack
		[7195] = {5869, 1, 50000}, -- Solar Flask Backpack
		[7194] = {5870, 1, 50000}, -- Shadow Alchemy Backpack
		[7193] = {5871, 1, 50000}, -- Arcane Explorer Backpack
		
		-- 🎒 Custom Style Backpacks (500k cada)
		-- [7189] = {6604, 1, 500000}, -- Nike Explorer Backpack
		[7187] = {6499, 100, 150000}, -- infernal bolt
		[7186] = {6498, 100, 120000}, -- enchanted bolt		
		[7190] = {6605, 1, 500000}, -- SD Backpack
		[7191] = {6612, 1, 500000}, -- YOUTUBE Backpack		
				
		-- 💍 Rings
		[6985] = {2207, 1, 2500},     -- Sword Ring
		[6984] = {2208, 1, 2500},     -- Axe Ring
		[6983] = {2209, 1, 2500},     -- Club Ring
		[6982] = {2213, 1, 5000},     -- Dwarven Ring
		[6981] = {2165, 1, 25000},    -- Stealth Ring
		
		
		-- 🏳️ Foods		
		[7301] = {2795, 100, 2000},
		[7302] = {2789, 100, 1000},		

		-- 🏳️ Tapestries
		[7101] = {6723, 1, 500000}, [7102] = {6724, 1, 500000}, [7103] = {6725, 1, 500000},
		[7104] = {6726, 1, 500000}, [7105] = {6727, 1, 500000}, [7106] = {6738, 1, 500000},
		[7107] = {6736, 1, 500000}, [7108] = {6399, 1, 500000}, [7109] = {6731, 1, 500000},
		[7110] = {6735, 1, 500000}, [7111] = {6739, 1, 500000}, [7112] = {6737, 1, 500000},
		[7113] = {6732, 1, 500000},

		-- 🎒 Decorate Backpacks
		[7201] = {5874, 1, 2000}, [7202] = {5875, 1, 2000}, [7203] = {5876, 1, 2000},
		[7204] = {5877, 1, 2000}, [7205] = {5878, 1, 2000}, [7206] = {5879, 1, 2000},
		[7207] = {5880, 1, 2000}, [7208] = {5881, 1, 2000}, [7209] = {5882, 1, 2000},
		[7210] = {5883, 1, 2000}, [7211] = {5884, 1, 2000}, [7212] = {5885, 1, 2000},
		[7213] = {5886, 1, 2000},
	}

	local config = shopItems[aid]
	if not config then
		player:sendCancelMessage("This lever is not configured.")
		return true
	end

	local itemId, count, price, charges = config[1], config[2], config[3], config[4]
	local itemType = ItemType(itemId)
	local itemWeight = itemType:getWeight(count)

	if player:getFreeCapacity() < itemWeight then
		player:sendCancelMessage("You don't have enough capacity to carry this item.")
		return true
	end

	if not player:removeTotalMoney(price) then
		player:sendCancelMessage("You don't have enough gold.")
		return true
	end

	local added = player:addItem(itemId, count)
	if added and charges then
		added:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)
	elseif not added then
		local tile = Tile(player:getPosition())
		if tile then
			added = tile:addItem(itemId, count)
			if added and charges then
				added:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)
			end
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You bought " .. count .. "x " .. itemType:getName() .. " for " .. price .. " gold.")

	if item.itemid == 1945 then
		item:transform(1946)
	else
		item:transform(1945)
	end

	return true
end
