--[[ --------------------------------------------------------------------------------------------------------------------------------------
		Author: Leo32
		File: lib/attributes.lua
		
		This is the attributes & rarity library.
		It contains all the functions used to roll 'rare', 'epic' or 'legendary' on items & apply the custom buff conditions (+Skill, +Max Health)
		(!) Rolls that affect combat require the file creatureevents/scripts/attributes.lua
		
		Config:
		stats {}

			stats[i].attribute
			stats[i].base
			stats[i].items
		
			[i] = { 
				attribute = {
					name = 'Attack',
					rare = {1, 3}, -- Customize roll numbers here
					epic = {4, 6},
					legendary = {7, 10},
				},
				value = "Percent" -- What type of roll is it? Percent/Static/Damage/Duration
				base = ITEM_ATTRIBUTE_ATTACK, -- If attribute is a vanilla stat, it should have a default or 'base' amount, what is it? (rollBase)
				items = {
					2392, -- These are specifically targeted items, that can roll this attribute.
					2414 
				}
			},
--]] --------------------------------------------------------------------------------------------------------------------------------------

local stats = { -- Define the attribute and their rolls
	[1] = { -- Attack
		attribute = {
			name = 'Attack',
			rare = {1, 3}, -- Customize roll numbers here
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_ATTACK -- If attribute is a vanilla stat, it should have a default or 'base' amount, what is it?
	},
	[2] = { -- Defense
		attribute = {
			name = 'Defense',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_DEFENSE
	},
	[3] = { -- Extra Defense
		attribute = {
			name = 'Extra Defense',
			rare = {1, 1},
			epic = {2, 3},
			legendary = {4, 5},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_EXTRADEFENSE	
	},
	[4] = { -- Armor
		attribute = {
			name = 'Armor',
			rare = {1, 1},
			epic = {2, 3},
			legendary = {4, 5},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_ARMOR
	},
	[5] = { -- Accuracy
		attribute = {
			name = 'Accuracy',
			rare = {1, 5},
			epic = {6, 10},
			legendary = {11, 15},
		},
		value = "Percent",
		base = ITEM_ATTRIBUTE_HITCHANCE
	},
	[6] = { -- Range
		attribute = {
			name = 'Range',
			rare = {1, 1},
			epic = {2, 2},
			legendary = {3, 3},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_SHOOTRANGE
	},
	[7] = { -- Equipment with < 50 charges
		attribute = {
			name = 'Charges',
			rare = {5, 10},
			epic = {15, 20},
			legendary = {31, 35},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_CHARGES
	},
	[8] = { -- Equipment with >= 50 charges
		attribute = {
			name = 'Charges',
			rare = {100, 250},
			epic = {350, 500},
			legendary = {1000, 2000},
		},
		value = "Static",
		base = ITEM_ATTRIBUTE_CHARGES
	},
	[9] = { -- Time
		attribute = {
			name = 'Time',
			rare = {300000, 300000},
			epic = {900000, 900000},
			legendary = {2700000, 2700000},
		},
		value = "Duration",
		base = ITEM_ATTRIBUTE_DURATION
	},
	[10] = { -- Crit Chance
		attribute = {
			name = 'Crit Chance',
			rare = {1, 3},
			epic = {3, 5},
			legendary = {5, 10},
		},
		value = "Percent",
		items = { -- These are specifically targeted items, that can roll this attribute.
		
			5818, -- karma spellbook		
			6128, -- karma shield
			6747, -- quiver +2		
			8326, -- quiver
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2			
			6494, -- karma shield	+2		
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots		
			7723, -- karma torch		
			6176, -- karma armor				
			6127, -- karma armor		
			6167, -- karma hat
			8323, -- lucky ring 			
			8324, -- lucky ring+2			
			2499, -- Amazon Helmet
			2500, -- Amazon Armor					
			2523, -- blessed shield		
			2496, -- Horned Helmet		
			5790,  -- dragon crossbow		
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace
			6116, -- firewalker boots
			5901, -- black demon legs
			5903, -- winged boots		
			8321, -- karma boots +4		
			5780, -- red robe			
			8240, -- karma boots +3	
			2518, -- Beholder Shield
			5973, -- black dh helmet			
			6185, -- red ring of the sky
			2640, -- karma boots
			8239, -- karma boots +2		
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients
		}
	},
	[11] = { -- Crit Amount (Currently Unused)
		attribute = {
			name = 'Crit Amount',
			rare = {10, 30},
			epic = {35, 60},
			legendary = {65, 100},
		},
		value = "Percent",
	},
	-- [12] = { -- Fire Damage
		-- attribute = {
			-- name = 'Enhanced Fire Damage',
			-- rare = {15, 30},
			-- epic = {30, 45},
			-- legendary = {45, 60},
		-- },
		-- value = "Damage",
		-- items = {
			-- 2518, -- Beholder Shield
			-- 2535, -- Castle Shield
			-- 2540, -- Scarab Shield
			-- 2479, -- Strange Helmet
			-- 3971, -- Charmer's Tiara
			-- 3972, -- Beholder Helmet
			-- 2664, -- Wood Cape
			-- 3982, -- Crocodile Boots
			-- 2123, -- Ring of the Sky
			-- 2135, -- Scarab Amulet
			-- 2508, -- Native Armor
			-- 2414, -- Dragon Lance
			-- 2444, -- Hammer of Wrath
			-- 2514, -- Mastermind Shield
			-- 2542, -- Tempest Shield
			-- 2424, -- Silver Mace
			-- 2516, -- Dragon Shield
			-- 2520, -- Demon Shield
			-- 2539, -- Phoenix Shield
			-- 2519, -- Crown Shield
			-- 2491, -- Crown Helmet
			-- 2493, -- Demon Helmet
			-- 2494, -- Demon Armor
			-- 2495, -- Demon Legs
			-- 2487, -- Crown Armor
			-- 2488, -- Crown Legs
			-- 2492, -- Dragon Scale Mail
			-- 2498, -- Royal Helmet
			-- 2655, -- Red Robe
			-- 2133, -- Ruby Necklace
			-- 2508, -- Native Armor
			-- 2123, -- Ring of the Sky	
			-- 2514, -- Mastermind Shield
			-- 2528, -- Tower Shield
			-- 2535, -- Castle Shield
			-- 2536, -- Medusa Shield
			-- 2532, -- Ancient Shield
			-- 2497, -- Crusader Helmet
			-- 3969, -- Horse Helmet
			-- 2472, -- Magic Plate Armor
			-- 2466, -- Golden Armor
			-- 3968, -- Leopard Armor
			-- 2470, -- Golden Legs
			-- 2645, -- Steel Boots
			-- 2179, -- Gold Ring
			-- 2503, -- Dwarven Armor
			-- 2508, -- Native Armor
			-- 7600, -- Dark Lord's Cape
			-- 7601, -- Robe of the Ice Queen
			-- 7602, -- Dragon Robe
			-- 7603, -- Velvet Mantle
			-- 7604, -- Greenwood Coat
			-- 7605, -- Spirit Cloak
			-- 7606, -- Focus Cape
			-- 7607, -- Belted Cape
			-- 7608, -- Hibiscus Dress
			-- 7609, -- Summer Dress
			-- 7610, -- Tunic
			-- 7611, -- Girl's Dress
			-- 7627, -- Spellbook of Enlightenment
			-- 7628, -- Spellbook of Warding
			-- 7629, -- Spellbook of Mind Control
			-- 7630, -- Spellbook of Lost Souls
			-- 7631, -- Spellscroll of Prophecies
			-- 7632, -- Rainbow Shield
			-- 7633, -- Fiery Rainbow Shield
			-- 7634, -- Icy Rainbow Shield
			-- 7635, -- Sparking Rainbow Shield
			-- 7636, -- Terran Rainbow Shield
			-- 7661, -- Royal Draken Mail
			-- 7662, -- Royal Scale Robe
			-- 7663, -- Shield of Corruption
			-- 7664, -- Elite Draken Helmet
			-- 7665, -- Draken Boots
			-- 7666, -- Snake God's Wristguard
			-- 7667, -- Snake God's Sceptre
			-- 7668, -- Blade of Corruption
			-- 7450, -- Royal Axe
			-- 7451, -- Impaler
			-- 7452, -- Angelic Axe
			-- 7453, -- Sapphire Hammer
			-- 7454, -- Elvish Bow
			-- 7574, -- Crystal Sword
			-- 7575, -- Hammer of Prophecy
			-- 7576, -- Shadow Sceptre
			-- 7577, -- Spiked Squelcher
			-- 7578, -- Executioner
			-- 7579, -- Glorious Axe
			-- 7580, -- Mythril Axe
			-- 7581, -- Noble Axe
			-- 7582, -- Fur Boots
			-- 7583, -- Fur Cap
			-- 7584, -- Pair of Earmuffs
			-- 7585, -- Norse Shield
			-- 7586, -- Krimhorn Helmet
			-- 7587, -- Ragnir Helmet
			-- 7588, -- Mammoth Fur Cape
			-- 7589, -- Mammoth Fur Shorts	
			-- 7411, -- Mercenary Sword
			-- 7412, -- Diamond Sceptre
			-- 7413, -- Vile Axe
			-- 7414, -- Heroic Axe
			-- 7415, -- The Justice Seeker
			-- 7416, -- Thaian Sword
			-- 7417, -- Orcish Maul
			-- 7419, -- Berserker
			-- 7420, -- Assassin Dagger
			-- 7421, -- Havoc Blade
			-- 7422, -- Blacksteel Sword
			-- 7423, -- Haunted Blade
			-- 7424, -- Wyvern Fang
			-- 7425, -- Northern Star
			-- 7426, -- Queen's Sceptre
			-- 7427, -- Ornamented Axe
			-- 7428, -- Butcher's Axe
			-- 7429, -- Titan Axe
			-- 7430, -- Abyss Hammer
			-- 7431, -- Cranial Basher
			-- 7432, -- Bloody Edge
			-- 7433, -- Runed Sword
			-- 7434, -- Nightmare Blade
			-- 7435, -- Dreaded Cleaver
			-- 7436, -- Reaper's Axe
			-- 7437, -- Onyx Flail
			-- 7438, -- Jade Hammer
			-- 7439, -- Skullcrusher
			-- 7440, -- Lunar Staff
			-- 7441, -- Taurus Mace
			-- 7442, -- Amber Staff
			-- 7443, -- Chaos Mace
			-- 7444, -- Bonebreaker
			-- 7445, -- Blessed Sceptre
			-- 7446, -- Dragonbone Staff
			-- 7447, -- Demonbone
			-- 7448, -- Furry Club
			-- 7449, -- Ravenwing
			-- 7404, -- Brutetamer's Staff
			-- 7405, -- Headchopper
			-- 7406, -- Mammoth Whopper
			-- 7407, -- Demonrage Sword
			-- 7408, -- Relic Sword
			-- 7409, -- Mystic Blade
			-- 7410, -- Crimson Sword
			-- 7590, -- Modified Crossbow
			-- 7591, -- Chain Bolter
			-- 7592, -- Royal Crossbow
			-- 7593, -- The Devileye
			-- 7594, -- The Ironworker
			-- 7595, -- Warsinger Bow
			-- 7596, -- Composite Hornbow
			-- 7597, -- Yol's Bow
			-- 7598, -- Silkweaver Bow
			-- 7599, -- Elethriel's Elemental Bow
			-- 7612, -- Lavos Armor
			-- 7613, -- Crystalline Armor
			-- 7614, -- Voltage Armor
			-- 7615, -- Swamplair Armor
			-- 7616, -- Fireborn Giant Armor
			-- 7617, -- Earthborn Titan Armor
			-- 7618, -- Windborn Colossus Armor
			-- 7619, -- Oceanborn Leviathan Armor
			-- 7620, -- Divine Plate
			-- 7621, -- Molten Plate
			-- 7622, -- Frozen Plate
			-- 7623, -- Master Archer's Armor
			-- 7624, -- Skullcracker Armor
			-- 7625, -- Robe of the Underworld
			-- 7578, -- Raging Tempest Axe
			-- 7579, -- Inferno Axe
			-- 7580, -- Frostbite Hewer
			-- 7581, -- Thunderstorm Axe
			-- 5782, -- White Swamp Shield
			-- 6172, -- Swamp Amulet
			-- 6179, -- Dread Armor
			-- 6180, -- Dread Legs
			-- 6173, -- Dread Helmet
			-- 6158, -- Dread Amulet
			-- 5781, -- Dread Shield
			-- 6840, -- Daily Reward
			-- 7653, -- Zaoan Helmet
			-- 7652, -- Zaoan Armor
			-- 7655, -- Zaoan Legs
			-- 7654, -- Zaoan Shoes
			-- 7626, -- Paladin Armor
			-- 6866, -- Magma Amulet
			-- 6870, -- Magma Boots
			-- 6869, -- Magma Legs
			-- 6872, -- Magma Coat
			-- 6873, -- Magma Monocle
			-- 6868, -- Lightning Boots
			-- 6871, -- Lightning Legs
			-- 6874, -- Lightning Glasses
			-- 5796, -- Red Magician Hat
			-- 5797, -- Blue Royal Helmet
			-- 5798, -- Royal Helmet
			-- 5799, -- Alpha Dragon Scale Mail
			-- 5800, -- Galea
			-- 5801, -- Princess Tiara
			-- 5802, -- Dark Ring
			-- 5803, -- Eternal Life Ring
			-- 5804, -- Karma Ring
			-- 5805, -- Silver Ring
			-- 5806, -- Love Ring
			-- 5807, -- Glowing Golden Ring
			-- 5808, -- The Death Ring
			-- 5809, -- Blue Pants
			-- 5810, -- Red Legs
			-- 5811, -- Princess Legs
			-- 5812, -- Rebellion
			-- 5813, -- Giant Flameblade
			-- 5815, -- Light Sword
			-- 5090, -- Skull Dragon Shield
			-- 5774, -- Amulet of Life
			-- 5775, -- Amulet of Mana
			-- 6181, -- Mana Amulet
			-- 6188, -- Sword Amulet
			-- 5776, -- Belfegor Armor
			-- 5777, -- Magic Golden Armor
			-- 6192, -- Omega Magic Armor
			-- 5786, -- Skull Staff
			-- 5789, -- Silver Bow
			-- 5792, -- The Iron Worker
			-- 5793, -- Royal Helmet
			-- 5795 -- Magic Helmet of Ancients		
		-- }
	-- },
	-- [13] = { -- Ice Damage
		-- attribute = {
			-- name = 'Enhanced Ice Damage',
			-- rare = {10, 15},
			-- epic = {15, 25},
			-- legendary = {25, 35},
		-- },
		-- value = "Damage",
		-- items = {
			-- 7386, -- Merc Sword
			-- 7453, -- Executioner
			-- 2445, -- Crystal Mace
			-- 7428, -- Bonebreaker
			-- 7407, -- Haunted Blade
			-- 7437, -- Sapphire Hammer
			-- 7387, -- Diamond Hammer
			-- 7455, -- Mythril Axe
			-- 21696,-- Icicle Bow
			-- 7390, -- Justice Seeker
			-- 21697,-- Runic Ice Shield
			-- 8858, -- Elemental Bow
			-- 7410, -- Queen's Sceptre
			-- 8927, -- Dark Trinity Mace
			-- 2534,  -- Vampire Shield
			-- 7600, -- Dark Lord's Cape
			-- 7601, -- Robe of the Ice Queen
			-- 7602, -- Dragon Robe
			-- 7603, -- Velvet Mantle
			-- 7604, -- Greenwood Coat
			-- 7605, -- Spirit Cloak
			-- 7606, -- Focus Cape
			-- 7607, -- Belted Cape
			-- 7608, -- Hibiscus Dress
			-- 7609, -- Summer Dress
			-- 7610, -- Tunic
			-- 7611, -- Girl's Dress
			-- 7627, -- Spellbook of Enlightenment
			-- 7628, -- Spellbook of Warding
			-- 7629, -- Spellbook of Mind Control
			-- 7630, -- Spellbook of Lost Souls
			-- 7631, -- Spellscroll of Prophecies
			-- 7632, -- Rainbow Shield
			-- 7633, -- Fiery Rainbow Shield
			-- 7634, -- Icy Rainbow Shield
			-- 7635, -- Sparking Rainbow Shield
			-- 7636, -- Terran Rainbow Shield
			-- 7661, -- Royal Draken Mail
			-- 7662, -- Royal Scale Robe
			-- 7663, -- Shield of Corruption
			-- 7664, -- Elite Draken Helmet
			-- 7665, -- Draken Boots
			-- 7666, -- Snake God's Wristguard
			-- 7667, -- Snake God's Sceptre
			-- 7668 -- Blade of Corruption
		-- }
	-- },
	-- [14] = { -- Energy Damage
		-- attribute = {
			-- name = 'Enhanced Energy Damage',
			-- rare = {50, 75},
			-- epic = {100, 125},
			-- legendary = {200, 250},
		-- },
		-- value = "Damage",
		-- items = {
			-- 2414, -- Dragon Lance
			-- 2444, -- Hammer of Wrath
			-- 2514, -- Mastermind Shield
			-- 2542, -- Tempest Shield
			-- 2424, -- Silver Mace
			-- 2516, -- Dragon Shield
			-- 2520, -- Demon Shield
			-- 2539, -- Phoenix Shield
			-- 2519, -- Crown Shield
			-- 2491, -- Crown Helmet
			-- 2493, -- Demon Helmet
			-- 2494, -- Demon Armor
			-- 2495, -- Demon Legs
			-- 2487, -- Crown Armor
			-- 2488, -- Crown Legs
			-- 2492, -- Dragon Scale Mail
			-- 2498, -- Royal Helmet
			-- 2655, -- Red Robe
			-- 2133, -- Ruby Necklace
			-- 2508, -- Native Armor
			-- 2123, -- Ring of the Sky		
			-- 2518, -- Beholder Shield
			-- 2535, -- Castle Shield
			-- 2540, -- Scarab Shield
			-- 2479, -- Strange Helmet
			-- 3971, -- Charmer's Tiara
			-- 3972, -- Beholder Helmet
			-- 2664, -- Wood Cape
			-- 3982, -- Crocodile Boots
			-- 2123, -- Ring of the Sky
			-- 2135, -- Scarab Amulet
			-- 2508, -- Native Armor
			-- 2414, -- Dragon Lance
			-- 2444, -- Hammer of Wrath
			-- 2514, -- Mastermind Shield
			-- 2542, -- Tempest Shield
			-- 8924, -- Hellforged Axe
			-- 2424, -- Silver Mace
			-- 2516, -- Dragon Shield
			-- 2520, -- Demon Shield
			-- 2539, -- Phoenix Shield
			-- 2519, -- Crown Shield
			-- 2491, -- Crown Helmet
			-- 2493, -- Demon Helmet
			-- 2494, -- Demon Armor
			-- 2495, -- Demon Legs
			-- 2487, -- Crown Armor
			-- 2488, -- Crown Legs
			-- 2492, -- Dragon Scale Mail
			-- 2498, -- Royal Helmet
			-- 2655, -- Red Robe
			-- 2133, -- Ruby Necklace
			-- 2508, -- Native Armor
			-- 2123, -- Ring of the Sky	
			-- 2514, -- Mastermind Shield
			-- 2528, -- Tower Shield
			-- 2535, -- Castle Shield
			-- 2536, -- Medusa Shield
			-- 2532, -- Ancient Shield
			-- 2497, -- Crusader Helmet
			-- 3969, -- Horse Helmet
			-- 2472, -- Magic Plate Armor
			-- 2466, -- Golden Armor
			-- 3968, -- Leopard Armor
			-- 2470, -- Golden Legs
			-- 2645, -- Steel Boots
			-- 2179, -- Gold Ring
			-- 2503, -- Dwarven Armor
			-- 2508, -- Native Armor
			-- 7600, -- Dark Lord's Cape
			-- 7601, -- Robe of the Ice Queen
			-- 7602, -- Dragon Robe
			-- 7603, -- Velvet Mantle
			-- 7604, -- Greenwood Coat
			-- 7605, -- Spirit Cloak
			-- 7606, -- Focus Cape
			-- 7607, -- Belted Cape
			-- 7608, -- Hibiscus Dress
			-- 7609, -- Summer Dress
			-- 7610, -- Tunic
			-- 7611, -- Girl's Dress
			-- 7627, -- Spellbook of Enlightenment
			-- 7628, -- Spellbook of Warding
			-- 7629, -- Spellbook of Mind Control
			-- 7630, -- Spellbook of Lost Souls
			-- 7631, -- Spellscroll of Prophecies
			-- 7632, -- Rainbow Shield
			-- 7633, -- Fiery Rainbow Shield
			-- 7634, -- Icy Rainbow Shield
			-- 7635, -- Sparking Rainbow Shield
			-- 7636, -- Terran Rainbow Shield
			-- 7661, -- Royal Draken Mail
			-- 7662, -- Royal Scale Robe
			-- 7663, -- Shield of Corruption
			-- 7664, -- Elite Draken Helmet
			-- 7665, -- Draken Boots
			-- 7666, -- Snake God's Wristguard
			-- 7667, -- Snake God's Sceptre
			-- 7668, -- Blade of Corruption	
			-- 2518, -- Beholder Shield
			-- 2535, -- Castle Shield
			-- 2540, -- Scarab Shield
			-- 2479, -- Strange Helmet
			-- 3971, -- Charmer's Tiara
			-- 3972, -- Beholder Helmet
			-- 2664, -- Wood Cape
			-- 3982, -- Crocodile Boots
			-- 2123, -- Ring of the Sky
			-- 2135, -- Scarab Amulet
			-- 2508, -- Native Armor
			-- 2414, -- Dragon Lance
			-- 2444, -- Hammer of Wrath
			-- 2514, -- Mastermind Shield
			-- 2542, -- Tempest Shield
			-- 2424, -- Silver Mace
			-- 2516, -- Dragon Shield
			-- 2520, -- Demon Shield
			-- 2539, -- Phoenix Shield
			-- 2519, -- Crown Shield
			-- 2491, -- Crown Helmet
			-- 2493, -- Demon Helmet
			-- 2494, -- Demon Armor
			-- 2495, -- Demon Legs
			-- 2487, -- Crown Armor
			-- 2488, -- Crown Legs
			-- 2492, -- Dragon Scale Mail
			-- 2498, -- Royal Helmet
			-- 2655, -- Red Robe
			-- 2133, -- Ruby Necklace
			-- 2508, -- Native Armor
			-- 2123, -- Ring of the Sky	
			-- 2514, -- Mastermind Shield
			-- 2528, -- Tower Shield
			-- 2535, -- Castle Shield
			-- 2536, -- Medusa Shield
			-- 2532, -- Ancient Shield
			-- 2497, -- Crusader Helmet
			-- 3969, -- Horse Helmet
			-- 2472, -- Magic Plate Armor
			-- 2466, -- Golden Armor
			-- 3968, -- Leopard Armor
			-- 2470, -- Golden Legs
			-- 2645, -- Steel Boots
			-- 2179, -- Gold Ring
			-- 2503, -- Dwarven Armor
			-- 2508, -- Native Armor
			-- 7600, -- Dark Lord's Cape
			-- 7601, -- Robe of the Ice Queen
			-- 7602, -- Dragon Robe
			-- 7603, -- Velvet Mantle
			-- 7604, -- Greenwood Coat
			-- 7605, -- Spirit Cloak
			-- 7606, -- Focus Cape
			-- 7607, -- Belted Cape
			-- 7608, -- Hibiscus Dress
			-- 7609, -- Summer Dress
			-- 7610, -- Tunic
			-- 7611, -- Girl's Dress
			-- 7627, -- Spellbook of Enlightenment
			-- 7628, -- Spellbook of Warding
			-- 7629, -- Spellbook of Mind Control
			-- 7630, -- Spellbook of Lost Souls
			-- 7631, -- Spellscroll of Prophecies
			-- 7632, -- Rainbow Shield
			-- 7633, -- Fiery Rainbow Shield
			-- 7634, -- Icy Rainbow Shield
			-- 7635, -- Sparking Rainbow Shield
			-- 7636, -- Terran Rainbow Shield
			-- 7661, -- Royal Draken Mail
			-- 7662, -- Royal Scale Robe
			-- 7663, -- Shield of Corruption
			-- 7664, -- Elite Draken Helmet
			-- 7665, -- Draken Boots
			-- 7666, -- Snake God's Wristguard
			-- 7667, -- Snake God's Sceptre
			-- 7668, -- Blade of Corruption
			-- 7450, -- Royal Axe
			-- 7451, -- Impaler
			-- 7452, -- Angelic Axe
			-- 7453, -- Sapphire Hammer
			-- 7454, -- Elvish Bow
			-- 7574, -- Crystal Sword
			-- 7575, -- Hammer of Prophecy
			-- 7576, -- Shadow Sceptre
			-- 7577, -- Spiked Squelcher
			-- 7578, -- Executioner
			-- 7579, -- Glorious Axe
			-- 7580, -- Mythril Axe
			-- 7581, -- Noble Axe
			-- 7582, -- Fur Boots
			-- 7583, -- Fur Cap
			-- 7584, -- Pair of Earmuffs
			-- 7585, -- Norse Shield
			-- 7586, -- Krimhorn Helmet
			-- 7587, -- Ragnir Helmet
			-- 7588, -- Mammoth Fur Cape
			-- 7589, -- Mammoth Fur Shorts	
			-- 7411, -- Mercenary Sword
			-- 7412, -- Diamond Sceptre
			-- 7413, -- Vile Axe
			-- 7414, -- Heroic Axe
			-- 7415, -- The Justice Seeker
			-- 7416, -- Thaian Sword
			-- 7417, -- Orcish Maul
			-- 7419, -- Berserker
			-- 7420, -- Assassin Dagger
			-- 7421, -- Havoc Blade
			-- 7422, -- Blacksteel Sword
			-- 7423, -- Haunted Blade
			-- 7424, -- Wyvern Fang
			-- 7425, -- Northern Star
			-- 7426, -- Queen's Sceptre
			-- 7427, -- Ornamented Axe
			-- 7428, -- Butcher's Axe
			-- 7429, -- Titan Axe
			-- 7430, -- Abyss Hammer
			-- 7431, -- Cranial Basher
			-- 7432, -- Bloody Edge
			-- 7433, -- Runed Sword
			-- 7434, -- Nightmare Blade
			-- 7435, -- Dreaded Cleaver
			-- 7436, -- Reaper's Axe
			-- 7437, -- Onyx Flail
			-- 7438, -- Jade Hammer
			-- 7439, -- Skullcrusher
			-- 7440, -- Lunar Staff
			-- 7441, -- Taurus Mace
			-- 7442, -- Amber Staff
			-- 7443, -- Chaos Mace
			-- 7444, -- Bonebreaker
			-- 7445, -- Blessed Sceptre
			-- 7446, -- Dragonbone Staff
			-- 7447, -- Demonbone
			-- 7448, -- Furry Club
			-- 7449, -- Ravenwing
			-- 7404, -- Brutetamer's Staff
			-- 7405, -- Headchopper
			-- 7406, -- Mammoth Whopper
			-- 7407, -- Demonrage Sword
			-- 7408, -- Relic Sword
			-- 7409, -- Mystic Blade
			-- 7410, -- Crimson Sword
			-- 7590, -- Modified Crossbow
			-- 7591, -- Chain Bolter
			-- 7592, -- Royal Crossbow
			-- 7593, -- The Devileye
			-- 7594, -- The Ironworker
			-- 7595, -- Warsinger Bow
			-- 7596, -- Composite Hornbow
			-- 7597, -- Yol's Bow
			-- 7598, -- Silkweaver Bow
			-- 7599, -- Elethriel's Elemental Bow
			-- 7612, -- Lavos Armor
			-- 7613, -- Crystalline Armor
			-- 7614, -- Voltage Armor
			-- 7615, -- Swamplair Armor
			-- 7616, -- Fireborn Giant Armor
			-- 7617, -- Earthborn Titan Armor
			-- 7618, -- Windborn Colossus Armor
			-- 7619, -- Oceanborn Leviathan Armor
			-- 7620, -- Divine Plate
			-- 7621, -- Molten Plate
			-- 7622, -- Frozen Plate
			-- 7623, -- Master Archer's Armor
			-- 7624, -- Skullcracker Armor
			-- 7625, -- Robe of the Underworld
			-- 7578, -- Raging Tempest Axe
			-- 7579, -- Inferno Axe
			-- 7580, -- Frostbite Hewer
			-- 7581, -- Thunderstorm Axe
			-- 5782, -- White Swamp Shield
			-- 6172, -- Swamp Amulet
			-- 6179, -- Dread Armor
			-- 6180, -- Dread Legs
			-- 6173, -- Dread Helmet
			-- 6158, -- Dread Amulet
			-- 5781, -- Dread Shield
			-- 6840, -- Daily Reward
			-- 7653, -- Zaoan Helmet
			-- 7652, -- Zaoan Armor
			-- 7655, -- Zaoan Legs
			-- 7654, -- Zaoan Shoes
			-- 7626, -- Paladin Armor
			-- 6868, -- Lightning Boots
			-- 6871, -- Lightning Legs
			-- 6874, -- Lightning Glasses
			-- 5796, -- Red Magician Hat
			-- 5797, -- Blue Royal Helmet
			-- 5798, -- Royal Helmet
			-- 5799, -- Alpha Dragon Scale Mail
			-- 5800, -- Galea
			-- 5801, -- Princess Tiara
			-- 5802, -- Dark Ring
			-- 5803, -- Eternal Life Ring
			-- 5804, -- Karma Ring
			-- 5805, -- Silver Ring
			-- 5806, -- Love Ring
			-- 5807, -- Glowing Golden Ring
			-- 5808, -- The Death Ring
			-- 5809, -- Blue Pants
			-- 5810, -- Red Legs
			-- 5811, -- Princess Legs
			-- 5812, -- Rebellion
			-- 5813, -- Giant Flameblade
			-- 5815, -- Light Sword
			-- 5090, -- Skull Dragon Shield
			-- 5774, -- Amulet of Life
			-- 5775, -- Amulet of Mana
			-- 6181, -- Mana Amulet
			-- 6188, -- Sword Amulet
			-- 5776, -- Belfegor Armor
			-- 5777, -- Magic Golden Armor
			-- 6192, -- Omega Magic Armor
			-- 5786, -- Skull Staff
			-- 5789, -- Silver Bow
			-- 5792, -- The Iron Worker
			-- 5793, -- Royal Helmet
			-- 5795 -- Magic Helmet of Ancients			
		-- }
	-- },
	[15] = { -- Fire Resistance
		attribute = {
			name = 'Fire Resistance',
			rare = {2, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- karma torch		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat		
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield	
			2496, -- Horned Helmet
			5790,  -- dragon crossbow			
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2414, -- Dragon Lance
			5973, -- black dh helmet			
			6185, -- red ring of the sky			
			2640, -- karma boots
			8239, -- karma boots +2					
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients		
		}
	},
[16] = { -- Ice Resistance
    attribute = {
        name = 'Ice Resistance',
        rare = {6, 7},
        epic = {8, 9},
        legendary = {10, 10},
    },
    value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- torch karma		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor					
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			3973, -- Tusk Shield		
			2125, -- Crystal Necklace
			2124,  -- Crystal Ring
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients		
		}
	},
	[17] = { -- Energy Resistance
		attribute = {
			name = 'Energy Resistance',
			rare = {2, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- karma torch		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2515, -- Guardian Shield
			5973, -- black dh helmet			
			2528, -- Tower Shield
			2535, -- Castle Shield
			2475, -- Warrior Helmet
			2497, -- Crusader Helmet
			2472, -- Magic Plate Armor
			2476, -- Knight Helmet
			2492, -- Dragon Scale Mail
			2477, -- Knight Legs
			2123, -- Ring of the Sky
			2508, -- Native Armor
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			8927, -- Dark Trinity Mace
			7384, -- Mystic Blade
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			8867, -- Dragon Robe
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients		
		}
	},
	[18] = { -- Earth Resistance
		attribute = {
			name = 'Earth Resistance',
			rare = {2, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- torch karma
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795, -- Magic Helmet of Ancients
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
			
		}
	},
	[19] = { -- Physical Resistance
		attribute = {
			name = 'Physical Resistance',
			rare = {2, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- karma torch		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			5790,  -- dragon crossbow			
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2514, -- Mastermind Shield
			6185, -- red ring			
			2640, -- karma boots
			8239, -- karma boots +2					
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
			
		}
	},
	[20] = { -- Death Resistance
		attribute = {
			name = 'Death Resistance',
			rare = {2, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- karma torch		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2521, -- Dark Shield
			2529, -- Black Shield
			2532, -- Ancient Shield
			2536, -- Medusa Shield
			2462, -- Devil Helmet
			2490, -- Dark Helmet
			2489, -- Dark Helmet
			5462, -- Pirate Boots
			2129, -- Wolf Tooth Chain
			2508, -- Native Armor
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
		}
	},

[14] = { -- Holy Resistance
    attribute = {
        name = 'Holy Resistance',
        rare = {6, 7},
        epic = {8, 9},
        legendary = {10, 10},
    },
    value = "Percent",
    -- Reutiliza a mesma cobertura de itens da Ice Resistance
    items = (function()
        return stats and stats[16] and stats[16].items or {}
    end)()
},
	[21] = { -- Spell Damage
		attribute = {
			name = 'Spell Damage',
			rare = {2, 5},
			epic = {5, 7},
			legendary = {7, 10},
		},
		value = "Percent",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5791, -- karma crossbow			
			6174, -- karma bow
			6416, -- karma bow +2
			6474, -- karma bow +2 (alt id)
			6221, -- karma club			
			6118, -- karma sword			
			6225, -- karma axe			
			5803, -- karma ring +2			
			6181, -- mana amulet		
			7630, -- karma spellbook
			5818, -- karma spellbook			
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7723, -- karma torch		
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2499, -- Amazon Helmet
			2500, -- Amazon Armor			
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2123, -- Ring of the Sky
			5795 -- Magic Helmet of Ancients			
		}
	},
	[22] = { -- Multi Shot
		attribute = {
			name = 'Multi Shot',
			rare = {1, 1},
			epic = {2, 2},
			legendary = {3, 3},
		},
		value = "Static"
		-- Items targeted by this attribute are defined in a different way below.
	},
	[23] = { -- Stun Chance
		attribute = {
			name = 'Stun Chance',
			rare = {3, 5},
			epic = {6, 10},
			legendary = {11, 15},
		},
		value = "Percent"
	},
	[24] = { -- Mana Shield
		attribute = {
			name = 'Mana Shield',
			rare = {5, 10},
			epic = {11, 20},
			legendary = {21, 30},
		},
		value = "Percent"
	},
	[25] = { -- Sword Skill
		attribute = {
			name = 'Sword Skill',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
			8881, -- Fireborn
			12644 -- Shield of Corruption
		}
	},
	[26] = { -- Skill Axe
		attribute = {
			name = 'Axe Skill',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
			8882 -- Earthborn
		}
	},
	[27] = { -- Skill Club
		attribute = {
			name = 'Club Skill',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
			8883 -- Windborn
		}
	},
	[28] = { -- Skill Melee
		attribute = {
			name = 'Melee Skills',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6187,  -- yalahari shotter
			6169,  --yalahari king	
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			8240, -- karma boots +3		
			2342, -- HOTA
			2471, -- Golden Helmet
			2640, -- karma boots
			8239, -- karma boots +2					
			15406, -- Ornate Armor
			15412, -- Ornate Legs
			2494, -- Demon Armor
			9776, -- Yalahari Armor
			21692, -- Albino Plate
			2537, -- Amazon Shield
			2522, -- Great Shield
			6391 -- Nightmare Shield
		}
	},
	[29] = { -- Skill Distance
		attribute = {
			name = 'Distance Skill',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			5790,  -- dragon crossbow			
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			8240, -- karma boots +3		
			2499, -- Amazon Helmet
			6185, -- red ring			
			2640, -- karma boots
			8239, -- karma boots +2					
			2474, -- Winged Helmet
			2500, -- Amazon Armor
			2505, -- Elven Mail
			2218, -- Paw Amulet
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
		}
	},
	[30] = { -- Skill Shielding
		attribute = {
			name = 'Shield Skill',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 6},
		},
		value = "Static",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6175,  -- bow of flame	
			6115,  -- magic robe
			5783, -- red magician axe		
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			8240, -- karma boots +3		
			2195, -- Boots of Haste			
			2640, -- karma boots
			8239, -- karma boots +2					
			2503, -- Dwarven Armor
			2505, -- Elven Armor
			2502, -- Dwarven Helmet
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
		}
	},
	[31] = { -- Magic Level
		attribute = {
			name = 'Magic Level',
			rare = {1, 2},
			epic = {2, 3},
			legendary = {3, 4},
		},
		value = "Static",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6747, -- quiver +2		
			8326, -- quiver		
			6187,  -- yalahari shotter
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots					
			6176, -- karma legs				
			6127, -- karma armor		
			6167, -- karma hat			
			8323, -- lucky ring 			
			8324, -- lucky ring+2		
			2523, -- blessed shield			
			2496, -- Horned Helmet		
			6175,  -- bow of flame	
			6115,  -- magic robe	
			2124,  -- Crystal Ring
			2125, -- Crystal Necklace		
			6116, -- firewalker boots
			5901, -- black demon legs		
			5903, -- winged boots		
			8321, -- karma boots +4			
			5780, -- red robe			
			8240, -- karma boots +3		
			2323, -- Hat of the Mad
			5973, -- black dh helmet			
			6185, -- red ring			
			2662, -- Magician Hat
			2640, -- karma boots
			8239, -- karma boots +2					
			2506, -- Dragon Scale Helmet
			2542, -- Tempest Shield
			2501, -- Ceremonial Mask
			2139, -- Ancient Tiara
			2518, -- Beholder Shield
			2535, -- Castle Shield
			2540, -- Scarab Shield
			2479, -- Strange Helmet
			3971, -- Charmer's Tiara
			3972, -- Beholder Helmet
			2664, -- Wood Cape
			3982, -- Crocodile Boots
			2123, -- Ring of the Sky
			2135, -- Scarab Amulet
			2508, -- Native Armor
			2414, -- Dragon Lance
			2444, -- Hammer of Wrath
			2514, -- Mastermind Shield
			2542, -- Tempest Shield
			2424, -- Silver Mace
			2516, -- Dragon Shield
			2520, -- Demon Shield
			2539, -- Phoenix Shield
			2519, -- Crown Shield
			2491, -- Crown Helmet
			2493, -- Demon Helmet
			2494, -- Demon Armor
			2495, -- Demon Legs
			2487, -- Crown Armor
			2488, -- Crown Legs
			2492, -- Dragon Scale Mail
			2498, -- Royal Helmet
			2655, -- Red Robe
			2133, -- Ruby Necklace
			2508, -- Native Armor
			2123, -- Ring of the Sky	
			2514, -- Mastermind Shield
			2528, -- Tower Shield
			2535, -- Castle Shield
			2536, -- Medusa Shield
			2532, -- Ancient Shield
			2497, -- Crusader Helmet
			3969, -- Horse Helmet
			2472, -- Magic Plate Armor
			2466, -- Golden Armor
			3968, -- Leopard Armor
			2470, -- Golden Legs
			2645, -- Steel Boots
			2179, -- Gold Ring
			2503, -- Dwarven Armor
			2508, -- Native Armor
			7600, -- Dark Lord's Cape
			7601, -- Robe of the Ice Queen
			7602, -- Dragon Robe
			7603, -- Velvet Mantle
			7604, -- Greenwood Coat
			7605, -- Spirit Cloak
			7606, -- Focus Cape
			7607, -- Belted Cape
			7608, -- Hibiscus Dress
			7609, -- Summer Dress
			7610, -- Tunic
			7611, -- Girl's Dress
			7627, -- Spellbook of Enlightenment
			7628, -- Spellbook of Warding
			7629, -- Spellbook of Mind Control
			7630, -- Spellbook of Lost Souls
			7631, -- Spellscroll of Prophecies
			7632, -- Rainbow Shield
			7633, -- Fiery Rainbow Shield
			7634, -- Icy Rainbow Shield
			7635, -- Sparking Rainbow Shield
			7636, -- Terran Rainbow Shield
			7661, -- Royal Draken Mail
			7662, -- Royal Scale Robe
			7663, -- Shield of Corruption
			7664, -- Elite Draken Helmet
			7665, -- Draken Boots
			7666, -- Snake God's Wristguard
			7667, -- Snake God's Sceptre
			7668, -- Blade of Corruption
			7450, -- Royal Axe
			7451, -- Impaler
			7452, -- Angelic Axe
			7453, -- Sapphire Hammer
			7454, -- Elvish Bow
			7574, -- Crystal Sword
			7575, -- Hammer of Prophecy
			7576, -- Shadow Sceptre
			7577, -- Spiked Squelcher
			7578, -- Executioner
			7579, -- Glorious Axe
			7580, -- Mythril Axe
			7581, -- Noble Axe
			7582, -- Fur Boots
			7583, -- Fur Cap
			7584, -- Pair of Earmuffs
			7585, -- Norse Shield
			7586, -- Krimhorn Helmet
			7587, -- Ragnir Helmet
			7588, -- Mammoth Fur Cape
			7589, -- Mammoth Fur Shorts	
			7411, -- Mercenary Sword
			7412, -- Diamond Sceptre
			7413, -- Vile Axe
			7414, -- Heroic Axe
			7415, -- The Justice Seeker
			7416, -- Thaian Sword
			7417, -- Orcish Maul
			7419, -- Berserker
			7420, -- Assassin Dagger
			7421, -- Havoc Blade
			7422, -- Blacksteel Sword
			7423, -- Haunted Blade
			7424, -- Wyvern Fang
			7425, -- Northern Star
			7426, -- Queen's Sceptre
			7427, -- Ornamented Axe
			7428, -- Butcher's Axe
			7429, -- Titan Axe
			7430, -- Abyss Hammer
			7431, -- Cranial Basher
			7432, -- Bloody Edge
			7433, -- Runed Sword
			7434, -- Nightmare Blade
			7435, -- Dreaded Cleaver
			7436, -- Reaper's Axe
			7437, -- Onyx Flail
			7438, -- Jade Hammer
			7439, -- Skullcrusher
			7440, -- Lunar Staff
			7441, -- Taurus Mace
			7442, -- Amber Staff
			7443, -- Chaos Mace
			7444, -- Bonebreaker
			7445, -- Blessed Sceptre
			7446, -- Dragonbone Staff
			7447, -- Demonbone
			7448, -- Furry Club
			7449, -- Ravenwing
			7404, -- Brutetamer's Staff
			7405, -- Headchopper
			7406, -- Mammoth Whopper
			7407, -- Demonrage Sword
			7408, -- Relic Sword
			7409, -- Mystic Blade
			7410, -- Crimson Sword
			7590, -- Modified Crossbow
			7591, -- Chain Bolter
			7592, -- Royal Crossbow
			7593, -- The Devileye
			7594, -- The Ironworker
			7595, -- Warsinger Bow
			7596, -- Composite Hornbow
			7597, -- Yol's Bow
			7598, -- Silkweaver Bow
			7599, -- Elethriel's Elemental Bow
			7612, -- Lavos Armor
			7613, -- Crystalline Armor
			7614, -- Voltage Armor
			7615, -- Swamplair Armor
			7616, -- Fireborn Giant Armor
			7617, -- Earthborn Titan Armor
			7618, -- Windborn Colossus Armor
			7619, -- Oceanborn Leviathan Armor
			7620, -- Divine Plate
			7621, -- Molten Plate
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
			
		}
	},
	[32] = { -- Max Health (+100)
		attribute = {
			name = 'Max Health',
			rare = {300, 500},
			epic = {600, 900},
			legendary = {1000, 2000},
		},
		value = "Static",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			6494, -- karma shield	+2				
			5818, -- karma spellbook		
			6128, -- karma shield		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
		}
	},
	[33] = { -- Max Mana (+100)
		attribute = {
			name = 'Max Mana',
			rare = {300, 500},
			epic = {600, 900},
			legendary = {1000, 2000},
		},
		value = "Static",
		items = {
			6489, -- karma armor +2
			6514, -- karma ranger shield
			6513, -- karma ranger shield +2
			6491, -- karma ranger armor
			6490, -- karma ranger armor +2		
			5818, -- karma spellbook		
			6128, -- karma shield		
			6187,  -- yalahari shotter
			6169,  --yalahari king
			6184,  -- yalahari mage		
			7549,  -- silkweaver bow
			7598,  -- swamp hammer
			7724,  -- swamp armor
			7636,  -- terran rainbow shield
			5830,  -- steel helmet
			7615,  -- sacred tree amulet
			7637,  -- undead rod
			5855,  -- smoke bag
			7594,  -- the ironworker
			6217,  -- dreadfiend cape
			6488, -- karma boots +5
			6487, -- karma legs +2
			6489, -- karma armor +2
			6485, -- karma hat +2
			5897, -- karma spellbook +2
			6197, -- karma staff +2
			6486, -- karma cape +2
			6522, -- karma axe +2
			6523, -- karma hammer +2
			6198, -- karma sword +2
			7600,  -- ultimate dreadfiend cape
			6166,  -- dreadfiend boots
			5787,  -- jungle staff
			6771,  -- greenwood legs
			7581,  -- emerald crystal amulet
			6114,  -- lightning axe
			8179,  -- redborn robe
			7661,  -- forbidden boots			
			7622, -- Frozen Plate
			7623, -- Master Archer's Armor
			7624, -- Skullcracker Armor
			7625, -- Robe of the Underworld
			7578, -- Raging Tempest Axe
			7579, -- Inferno Axe
			7580, -- Frostbite Hewer
			7581, -- Thunderstorm Axe
			5782, -- White Swamp Shield
			6172, -- Swamp Amulet
			6179, -- Dread Armor
			6180, -- Dread Legs
			6173, -- Dread Helmet
			6158, -- Dread Amulet
			5781, -- Dread Shield
			6840, -- Daily Reward
			7653, -- Zaoan Helmet
			7652, -- Zaoan Armor
			7655, -- Zaoan Legs
			7654, -- Zaoan Shoes
			7626, -- Paladin Armor
			6862, -- Terra Mantle
			6863, -- Terra Legs
			6875, -- Terra Hood
			6864, -- Terra Boots
			6865, -- Terra Amulet
			6866, -- Magma Amulet
			6870, -- Magma Boots
			6869, -- Magma Legs
			6872, -- Magma Coat
			6873, -- Magma Monocle
			6868, -- Lightning Boots
			6871, -- Lightning Legs
			6874, -- Lightning Glasses
			5796, -- Red Magician Hat
			5797, -- Blue Royal Helmet
			5798, -- Royal Helmet
			5799, -- Alpha Dragon Scale Mail
			5800, -- Galea
			5801, -- Princess Tiara
			5802, -- Dark Ring
			5803, -- Eternal Life Ring
			5804, -- Karma Ring
			5805, -- Silver Ring
			5806, -- Love Ring
			5807, -- Glowing Golden Ring
			5808, -- The Death Ring
			5809, -- Blue Pants
			5810, -- Red Legs
			5811, -- Princess Legs
			5812, -- Rebellion
			5813, -- Giant Flameblade
			5815, -- Light Sword
			5090, -- Skull Dragon Shield
			5774, -- Amulet of Life
			5775, -- Amulet of Mana
			6181, -- Mana Amulet
			6188, -- Sword Amulet
			5776, -- Belfegor Armor
			5777, -- Magic Golden Armor
			6192, -- Omega Magic Armor
			5786, -- Skull Staff
			5789, -- Silver Bow
			5792, -- The Iron Worker
			5793, -- Royal Helmet
			5795 -- Magic Helmet of Ancients			
		}
	},
	[34] = { -- Max Health % (+10%)
		attribute = {
			name = 'Max Health',
			rare = {1, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent"
	},
	[35] = { -- Max Mana % (+10%)
		attribute = {
			name = 'Max Mana',
			rare = {1, 3},
			epic = {4, 6},
			legendary = {7, 10},
		},
		value = "Percent",
	},
	[36] = { -- Life Leech Chance (Currently Unused)
		attribute = {
			name = 'Life Leech',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 7},
		},
		value = "Percent",
		-- Items targeted by this attribute are defined in a different way below.
	},
	-- [37] = { -- Life Leech Amount
		-- attribute = {
			-- name = 'Life Leech',
			-- rare = {3, 5},
			-- epic = {6, 10},
			-- legendary = {11, 20},
		-- },
		-- value = "Percent"
		-- Items targeted by this attribute are defined in a different way below.
	-- },
	[38] = { -- Mana Leech Chance (Currently Unused)
		attribute = {
			name = 'Mana Leech',
			rare = {1, 2},
			epic = {3, 4},
			legendary = {5, 7},
		},
		value = "Percent",
		-- Items targeted by this attribute are defined in a different way below.
	},
	-- [39] = { -- Mana Leech Amount
		-- attribute = {
			-- name = 'Mana Leech',
			-- rare = {3, 5},
			-- epic = {6, 10},
			-- legendary = {11, 20},
		-- },
		-- value = "Percent"
		-- Items targeted by this attribute are defined in a different way below.
	-- }
}
local cannotroll = { -- These items are special and cannot be rolled rare/epic/legendary
	8905, -- Rainbow shield
	8906,
	8907,
	8908,
	8909,
	7744, -- These are the standard and transformed Dawnbreaker weapons
	7763,
	7751,
	7770,
	7756,
	7775
}

-- Check if item can be rolled (this is for use outside of this lib, actions, quests etc)
function rollCheck(item)
	local itemtype = ItemType(item:getId())
	local itemid = itemtype:getId()
	if table.contains(cannotroll, itemid) then
		return false
	end
	for k,v in pairs(stats) do
		if v.items ~= nil then
			if table.contains(v.items, itemid) then
				return true
			end
		end
	end
	local weapontype = itemtype:getWeaponType()
	if weapontype > 0 then
		if itemtype:isStackable() then
			return false
		else
			return true
		end
	elseif itemtype:getArmor() > 0 then
		return true
	end
	return false
end

-- Get duration literally
function rollBaseDuration(item)
	local it_id = item:getId()
	local tid = ItemType(it_id):getTransformEquipId()
	if tid > 0 then
		item:transform(tid)
		local vx = item:getAttribute(ITEM_ATTRIBUTE_DURATION)
		item:transform(it_id)
		--item:removeAttribute(ITEM_ATTRIBUTE_DURATION)
		return vx
	end
	return 0
end

-- Get base/stock stat
function rollBase(item, attr)
	local id = ItemType(item:getId())
	local v = {
		[ITEM_ATTRIBUTE_ATTACK] = id:getAttack(),
		[ITEM_ATTRIBUTE_DEFENSE] = id:getDefense(),
		[ITEM_ATTRIBUTE_EXTRADEFENSE] = id:getExtraDefense(),
		[ITEM_ATTRIBUTE_ARMOR] = id:getArmor(),
		[ITEM_ATTRIBUTE_HITCHANCE] = id:getHitChance(),
		[ITEM_ATTRIBUTE_SHOOTRANGE] = id:getShootRange(),
		[ITEM_ATTRIBUTE_CHARGES] = id:getCharges(),
		[ITEM_ATTRIBUTE_DURATION] = rollBaseDuration(item)
	}
	return v[attr]
end

-- Roll a container or item
function rollRarity(container, forced)
	-- Tiers
	local tiers = {
		[1] = {
			prefix = 'rare',
			chance = {
				[1] = 360, -- 7.5% chance to roll
				[2] = 2000 -- 20% chance for second stat
			}
		},

		[2] = {
			prefix = 'epic',
			chance = {
				[1] = 180, -- 3.75% chance to roll
				[2] = 4000 -- 50% chance for second stat
			}
		},

		[3] = {
			prefix = 'legendary',
			chance = {
				[1] = 90, -- 2% chance to roll
				[2] = 4000 -- 100% chance for second stat
			}
		},
	}
	local rares = 0
	local available_stats = {}
	local it_u = container
	local it_id = ItemType(it_u:getId())
	if it_u:isContainer() then
		local h = it_u:getItemHoldingCount()
		if h > 0 then
			local i = 1 
			while i <= h do
				local bagitem = it_u:getItem(i - 1)
				if bagitem:isContainer() then
					h = h - bagitem:getItemHoldingCount()
				end
				local manualroll = forced or false
				local crares = rollRarity(bagitem, manualroll)
				rares = rares + crares
				i = i + 1
			end
		end
	else
		if not it_id:isStackable() then
			-- Lista de itens que NÃO devem ter atributos
			local excluded_items = {
				-- Bones (2230-2250)
				2230, 2231, 2033, 2232, 2233, 2234, 2235, 2236, 2237, 2238, 2239, 2240, 2241, 2242, 2243, 2244, 2245, 2246, 2247, 2248, 2249, 2250,
				-- Runes (2148-2229)
				2148, 2149, 2150, 2151, 2152, 2153, 2154, 2155, 2156, 2157, 2158, 2159, 2160, 2161, 2162, 2163, 2164, 2165, 2166, 2167, 2168, 2169, 2170, 2171, 2172, 2173, 2174, 2175, 2176, 2177, 2178, 2179, 2180, 2181, 2182, 2183, 2184, 2185, 2186, 2187, 2188, 2189, 2190, 2191, 2192, 2193, 2194, 2195, 2196, 2197, 2198, 2199, 2200, 2201, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2216, 2217, 2218, 2219, 2220, 2221, 2222, 2223, 2224, 2225, 2226, 2227, 2228, 2229
			}
			
			-- Verifica se o item está na lista de exclusão
			if table.contains(excluded_items, it_u:getId()) then
				-- Item excluído, não aplica atributos
			else
				local wp = it_id:getWeaponType()
			if wp > 0 then
				-- Shields
				if wp == WEAPON_SHIELD then
					table.insert(available_stats, stats[2]) -- Defense
					table.insert(available_stats, stats[30]) -- Skill Shield
				
				-- Distance Items
				elseif wp == WEAPON_DISTANCE then
					table.insert(available_stats, stats[1]) -- Attack
					table.insert(available_stats, stats[6]) -- Range
					--table.insert(available_stats, stats[10]) -- Critical Chance
					table.insert(available_stats, stats[29]) -- Skill Distance
					--table.insert(available_stats, stats[5]) -- Accuracy
					if it_u:getId() ~= 5907 then -- Slingshot
						table.insert(available_stats, stats[22]) -- Multi Shot
					end
					-- Add both Leech types to Distance Weapons
					table.insert(available_stats, stats[36]) -- Life Leech Chance
					table.insert(available_stats, stats[38]) -- Mana Leech Chance
				
				-- Wands and Rods
				elseif wp == WEAPON_WAND then -- type wand
					table.insert(available_stats, stats[21]) -- Spell Damage
					table.insert(available_stats, stats[33]) -- Max Mana
					table.insert(available_stats, stats[31]) -- Magic Level
					table.insert(available_stats, stats[38]) -- Mana Leech Chance
					table.insert(available_stats, stats[36]) -- Life Leech Chance
				
				-- Sword, Clubs and Axes
				elseif table.contains({WEAPON_SWORD, WEAPON_CLUB, WEAPON_AXE}, wp) then -- Melee Weapon
					
					if wp == WEAPON_SWORD then
						table.insert(available_stats, stats[25]) -- Sword Skill
					elseif wp == WEAPON_AXE then
						table.insert(available_stats, stats[26]) -- Axe Skill
					elseif wp == WEAPON_CLUB then
						table.insert(available_stats, stats[27]) -- Club Skill
					end
					
					if it_id:getAttack() > 0 then
						table.insert(available_stats, stats[1]) -- Attack
					end
		
					if it_id:getSlotPosition() == 2096 then -- Two-handed Weapon
						table.insert(available_stats, stats[2]) -- Defense
					end
		
					if it_id:getSlotPosition() == 48 then -- One-handed Weapon
						table.insert(available_stats, stats[3]) -- Extra Defense
					end
					--table.insert(available_stats, stats[10]) -- Critical Chance
					table.insert(available_stats, stats[36]) -- Life Leech Chance
					table.insert(available_stats, stats[38]) -- Mana Leech Chance
				end
			else -- Armors, Amulets, Runes and Rings
				if it_id:getArmor() > 0 then -- Ignore clothing/things with no armor stat
					table.insert(available_stats, stats[4]) -- Armor
				end

				-- Duration
				local eq_id = it_id:getTransformEquipId()
				if eq_id > 0 then
					table.insert(available_stats, stats[9]) -- Time
				end
				
				-- Add both Leech types to armors and accessories
				table.insert(available_stats, stats[36]) -- Life Leech Chance
				table.insert(available_stats, stats[38]) -- Mana Leech Chance
				
				-- Charges
				local chargecount = it_id:getCharges()
				if chargecount > 0  and it_u.itemid ~= 2173 then -- Ignore AOL
					if chargecount >= 50 then -- If its base charge is greater than 50
						table.insert(available_stats, stats[8]) -- High Charges
					else -- Its base charge is less than 50
						table.insert(available_stats, stats[7]) -- Low Charges
					end
				end
			end
			
			-- Specifically Targeted Items
			for k,v in pairs(stats) do
				if v.items ~= nil then
					if table.contains(v.items, it_u.itemid) then
						table.insert(available_stats, stats[k])
					end
				end
			end
			end -- Fecha o else da verificação de itens excluídos
		end
	end
	if #available_stats > 0 then -- Skips it all if it's empty
		local tier = 0 -- Normal item
		local rarity = math.random(1, 10000)
		-- Manual trigger
		if type(forced) == "string" then -- rollRarity(item, "rare")  OR  /roll legendary
			for i = 1, #tiers do
				if forced == tiers[i].prefix then
					tier = i
				end
			end
		elseif forced == true then -- rollRarity(item, true)  OR  /roll
			tier = math.random(1,#tiers)
		-- Natural rolls
		else
			for i = 1, #tiers do -- Get best roll
				if rarity <= tiers[i].chance[1] then
					tier = i -- Rolled a rare/epic/legendary
				end
			end
		end
		if tier > 0 then -- Item has rolled rare or higher
			local stats_used = {}
			for stat = 1, #tiers[tier].chance do
				if #available_stats > 0 then
					local roll = math.random(1, 10000)
					if stat == 1 then -- First stat is guaranteed
						roll = tiers[tier].chance[stat]
					end
					if roll <= tiers[tier].chance[stat] then -- All other stats are rolled by chance
						local selected_stat = math.random(1, #available_stats)
						table.insert(stats_used, available_stats[selected_stat])
						table.remove(available_stats, selected_stat)
					end
				end
			end
			if #stats_used > 0 then
				rares = rares + 1
				local stat_desc = {}
				for stat = 1, #stats_used do
					if stats_used[stat] then
						local statmin = 0
						local statmax = 0
						if tiers[tier].prefix == tiers[3].prefix then
							statmin = stats_used[stat].attribute.legendary[1]
							statmax = stats_used[stat].attribute.legendary[2]
						elseif tiers[tier].prefix == tiers[2].prefix then
							statmin = stats_used[stat].attribute.epic[1]
							statmax = stats_used[stat].attribute.epic[2]
						else
							statmin = stats_used[stat].attribute.rare[1]
							statmax = stats_used[stat].attribute.rare[2]
						end

						
						-- Apply Attribute
						local critv = math.random(statmin, statmax) -- The actual roll amount
						if stats_used[stat].value ~= nil then -- Is the value type defined?
							local basestat = 0
							-- Fill basestat
							if stats_used[stat].base ~= nil then
								basestat = rollBase(it_u, stats_used[stat].base) -- This is the base/stock value of the stat
							end
							-- Static
							if stats_used[stat].value == "Static" then
								table.insert(stat_desc, '[' .. stats_used[stat].attribute.name .. ': +' .. critv .. ']') -- Standard value "+10"
							-- Percentage
							elseif stats_used[stat].value == "Percent" then
								table.insert(stat_desc, '[' .. stats_used[stat].attribute.name ..': +' .. critv .. '%]') -- Percent value "+10%"
							-- Damage
							elseif stats_used[stat].value == "Damage" then
								local minimumDmg = 1 -- the item roll is the MAX damage, how do we get a minimim damage?
								if stats_used[stat].attribute.name == "Enhanced Fire Damage" then
									minimumDmg = (critv - math.random(3,5)) -- 3-5 less than the maximum damage
								elseif stats_used[stat].attribute.name == "Enhanced Ice Damage" then
									minimumDmg = (critv - math.random(5,9)) -- 5-9 less than the maxximum damage
								end -- "Enhanced Energy Damage" always has 1 as minimumDmg
								table.insert(stat_desc, '[' .. stats_used[stat].attribute.name ..': '.. minimumDmg .. '-' .. critv .. ']') -- Damage value "13-35"
							-- Duration
							elseif stats_used[stat].value == "Duration" then
								local timeconvert = critv / 60000
								table.insert(stat_desc, '[' .. stats_used[stat].attribute.name .. ': +' .. timeconvert .. ' minutes]') -- Duration value "+15 minutes"
							end
							-- If this is a vanilla attribute, overwrite it with new roll
							if basestat > 0 then
								it_u:setAttribute(stats_used[stat].base, basestat + critv)
							end
							
						end
					end
				end
				-- Rarity prefix
				if it_id:getArticle() ~= "" then -- Replace article if exists
					if tiers[tier].prefix == "epic" then
						it_u:setAttribute(ITEM_ATTRIBUTE_ARTICLE, "an " .. tiers[tier].prefix)
					else
						it_u:setAttribute(ITEM_ATTRIBUTE_ARTICLE, "a " .. tiers[tier].prefix)
					end
				else -- Add rarity prefix to item article (this allows for easy identification of rolled items in scripts outside of this lib 'item:getArticle():find("rare")')
					it_u:setAttribute(ITEM_ATTRIBUTE_ARTICLE, tiers[tier].prefix)
				end
				it_u:setCustomAttribute("rarity",tier)
				-- If item has a description, retain it instead of over-writing it
				if it_id:getDescription() == "" then
					it_u:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "\n" .. table.concat(stat_desc, "\n"))
				else
					it_u:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, it_id:getDescription() .. "\n" .. "\n" .. table.concat(stat_desc, "\n"))
				end
				-- Capitalize tier.prefix to be used for the animated text above corpses
				rare_text = (tiers[tier].prefix:gsub("^%l", string.upper) .. "!")
			end
		end
	end
	return rares
end

-- Apply condition
function rollCondition(player, item, slot)
	local attributes = {
		 [1] = {"%[" .. stats[25].attribute.name .. ": ", CONDITION_PARAM_SKILL_SWORD}, -- "[Sword Skill: "
		 [2] = {"%[" .. stats[26].attribute.name .. ": ", CONDITION_PARAM_SKILL_AXE},
		 [3] = {"%[" .. stats[27].attribute.name .. ": ", CONDITION_PARAM_SKILL_CLUB},
		 [4] = {"%[" .. stats[28].attribute.name .. ": ", CONDITION_PARAM_SKILL_MELEE},
		 [5] = {"%[" .. stats[29].attribute.name .. ": ", CONDITION_PARAM_SKILL_DISTANCE},
		 [6] = {"%[" .. stats[30].attribute.name .. ": ", CONDITION_PARAM_SKILL_SHIELD},
		 [7] = {"%[" .. stats[31].attribute.name .. ": ", CONDITION_PARAM_STAT_MAGICPOINTS},
		 [8] = {"%[" .. stats[32].attribute.name .. ": ", CONDITION_PARAM_STAT_MAXHITPOINTS},
		 [9] = {"%[" .. stats[33].attribute.name .. ": ", CONDITION_PARAM_STAT_MAXMANAPOINTS},
		[10] = {"%[" .. stats[34].attribute.name .. ": ", CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, percent = true, absolute = true},
		[11] = {"%[" .. stats[35].attribute.name .. ": ", CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT, percent = true, absolute = true},
		[12] = {"%[" .. stats[11].attribute.name .. ": ", CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, percent = true, absolute = true},
		--[13] = {"%[" .. stats[10].attribute.name .. ": ", CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, percent = true},
		--[14] = {"%[" .. stats[36].attribute.name .. ": ", CONDITION_PARAM_SKILL_LIFE_LEECH_CHANCE, percent = true},
		--[15] = {"%[" .. stats[37].attribute.name .. ": ", CONDITION_PARAM_SKILL_LIFE_LEECH_AMOUNT, percent = true, absolute = true},
		--[16] = {"%[" .. stats[38].attribute.name .. ": ", CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, percent = true},
		--[17] = {"%[" .. stats[39].attribute.name .. ": ", CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, percent = true, absolute = true},
	}
	local itemDesc = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
	for k = 1,#attributes do
		local skillBonus = 0 -- reset
		local attributeSearchValue = "%+(%d+)%]" -- "+10]"
		if attributes[k].percent ~= nil then
			attributeSearchValue = "%+(%d+)%%%]" -- "+10%]"
			if attributes[k].absolute ~= nil then
				skillBonus = 100 -- These conditions require absolutes (108%, 145% etc.)
			end
		end
		local attributeString = attributes[k][1] .. attributeSearchValue -- "%[Attack: %+(%d+)%]"
		if string.match(itemDesc, attributeString) ~= nil then -- "[Attack: +10]"
			local offset = (10 * k) + slot -- ((CONST_SLOT_LAST) * k) + slot
			local skillBonus = skillBonus + tonumber(string.match(itemDesc, attributeString)) -- Raw (%d+) value
			
			if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, offset) == nil then
				local condition = Condition(CONDITION_ATTRIBUTES)
				condition:setParameter(CONDITION_PARAM_SUBID, offset)
				condition:setParameter(CONDITION_PARAM_TICKS, -1)
				condition:setParameter(attributes[k][2], skillBonus)
				player:addCondition(condition)
			else
				player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, offset)
			end
		end
	end
end
			
-- Get item attributes
function itemAttributes(player, item, slot, equip)
	-- Check if item is rolled
	if item:getArticle() ~= "" then
		if item:getArticle():find("rare") or item:getArticle():find("epic") or item:getArticle():find("legendary") then
			local appropriateSlot = false
			local slotType = ItemType(item.itemid):getSlotPosition()
			-- What slots do we want to check? this ignores CONST_SLOT_AMMO and CONST_SLOT_BACKPACK
			local raritySlots = {
				[CONST_SLOT_LEFT] = {validPositions = {[1] = SLOTP_LEFT,[2] = SLOTP_RIGHT,[3] = SLOTP_TWO_HAND}},
				[CONST_SLOT_RIGHT] = {validPositions = {[1] = SLOTP_LEFT,[2] = SLOTP_RIGHT,[3] = SLOTP_TWO_HAND}},
				[CONST_SLOT_HEAD] = {validPositions = {[1] = SLOTP_HEAD}},
				[CONST_SLOT_NECKLACE] = {validPositions = {[1] = SLOTP_NECKLACE}},
				[CONST_SLOT_ARMOR] = {validPositions = {[1] = SLOTP_ARMOR}},
				[CONST_SLOT_LEGS] = {validPositions = {[1] = SLOTP_LEGS}},
				[CONST_SLOT_FEET] = {validPositions = {[1] = SLOTP_FEET}},
				[CONST_SLOT_RING] = {validPositions = {[1] = SLOTP_RING}}
			}
			-- If slot is one that we check
			if raritySlots[slot] ~= nil then
				-- Validate that item is being equipped to the right slot
				if slot == CONST_SLOT_LEFT or slot == CONST_SLOT_RIGHT then
					local weapon = ItemType(item.itemid):getWeaponType()
					if weapon ~= WEAPON_NONE then
						if weapon ~= WEAPON_AMMO then
							appropriateSlot = true
						end
					end
				else
					for i = 1,#raritySlots[slot].validPositions do
						if bit.band(slotType, raritySlots[slot].validPositions[i]) ~= 0 then	
							appropriateSlot = true
							break
						end
					end
				end
				if appropriateSlot then -- Item is in the wrong slotType
					-- Checks have all passed, run apply/remove attribute
					rollCondition(player, item, slot)
				end
			end
		end
	end
end

--[[	Legacy version of itemAttributes
-- Apply skill conditions
function rollRarityConditions(player, skill, slot, searchString, conditionGuid, bonus)
	-- Finish loop, player logged out
	if not Player(player) then
		return false
	end
	local player = Player(player)
	-- Check slot
	if player:getSlotItem(slot) then
		local itemDesc = player:getSlotItem(slot):getDescription()
		if itemDesc:find(searchString) then
			-- Validate bonus amount, check if player has replaced the item to one with a different value
			local skillBonus = tonumber(string.match(itemDesc, searchString .. ": %+(%d+)%]"))
			if bonus then
				if bonus ~= skillBonus then -- skillBonus is not the same, player has replaced item
					if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, slot + conditionGuid) then
						player:removeCondition(CONDITION_ATTRIBUTES, condition, slot + conditionGuid)
					end
				end
			end
			-- Validate player has condition before adding it
			if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, slot + conditionGuid) == nil then
				local condition = Condition(CONDITION_ATTRIBUTES)
				condition:setParameter(CONDITION_PARAM_SUBID, slot + conditionGuid)
				condition:setParameter(CONDITION_PARAM_TICKS, -1)
				--condition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
				condition:setParameter(skill, skillBonus)
				player:addCondition(condition)
			end
			-- Loop again in 2000ms to re-check if item equipped
			addEvent(rollRarityConditions, 2000, player.uid, skill, slot, searchString, conditionGuid, skillBonus)
			
		else
			-- Finish loop, item has been unequipped
			if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, slot + conditionGuid) then
				player:removeCondition(CONDITION_ATTRIBUTES, condition, slot + conditionGuid)
			end
		end
	else
		-- Finish loop, item has been unequipped
		if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, slot + conditionGuid) then
			player:removeCondition(CONDITION_ATTRIBUTES, condition, slot + conditionGuid)
		end
	end
	return true
end

-- Activate skill bonuses (check for events/player.lua and creatureevents/login.lua)
function rollRarityConditionsActivate(player, slot)
	if not Player(player) then
		return false
	end
	local player = Player(player)
	-- Validate slot
	local slotCount = 0
	for i = 1,#raritySlots do
		if raritySlots[i][1] == slot then
			slotCount = i
			break
		end
	end
	-- Valid slot
	if slotCount > 0 then
		-- Check slot
		if player:getSlotItem(slot) ~= nil then
			local item = player:getSlotItem(slot)
			local itemDesc = item:getDescription()
			local slotType = ItemType(item.itemid):getSlotPosition()
			-- Validate equipment is equipped to the right slotType before activating (This stops equipment like rings or armor from buffing you if placed in hand slots etc)
			local appropriateSlot = false
			if slot == CONST_SLOT_LEFT or slot == CONST_SLOT_RIGHT then
				local weapon = ItemType(item.itemid):getWeaponType()
				if weapon ~= WEAPON_NONE then
					if weapon ~= WEAPON_AMMO then
						appropriateSlot = true
					end
				end
			else
				for j = 1,#raritySlots[slotCount].validPositions do
					if bit.band(slotType, raritySlots[slotCount].validPositions[j]) ~= 0 then
						appropriateSlot = true
						break
					end
				end
			end
			-- Item is in the right slotType
			if appropriateSlot then
				local offset = 0
				local attributes = {
					[1] = {"%[Sword Skill", CONDITION_PARAM_SKILL_SWORD},
					[2] = {"%[Axe Skill", CONDITION_PARAM_SKILL_AXE},
					[3] = {"%[Club Skill", CONDITION_PARAM_SKILL_CLUB},
					[4] = {"%[Melee Skills", CONDITION_PARAM_SKILL_MELEE},
					[5] = {"%[Distance Skill", CONDITION_PARAM_SKILL_DISTANCE},
					[6] = {"%[Shield Skill", CONDITION_PARAM_SKILL_SHIELD},
					[7] = {"%[Magic Level", CONDITION_PARAM_STAT_MAGICPOINTS},
					[8] = {"%[Max Health", CONDITION_PARAM_STAT_MAXHITPOINTS},
					[9] = {"%[Max Mana", CONDITION_PARAM_STAT_MAXMANAPOINTS}
				}
				-- Search item for attributes
				for k = 1,#attributes do
					if itemDesc:find(attributes[k][1]) then
						offset = 12 * k -- This is used for the CONDITION_PARAM_SUBID and allows all slots to have 1 of each attribute active
						-- Check condition not already applied
						if player:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, slot + offset) == nil then
							rollRarityConditions(player.uid, attributes[k][2], slot, attributes[k][1], offset)
						end
					end
				end
			end
		end
	end
	return true
end
--]]