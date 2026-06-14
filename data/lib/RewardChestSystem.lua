-- Reward system created by luanluciano93 for TFS 0.4, function adapted by Mateus Roberto for TFS 1.3+ using RevScripts.

REWARDCHEST = {
    rewardBagId = 6745,
    formula = {hit = 9, block = 9, support = 15},
    storageExhaust = 60000,
    town_id = 1,
    top1VeryRareGate = 90, -- % de chance do top1 poder rolar veryRare
    nonTopVeryRareGate = 90, -- % de chance dos demais ranks poderem rolar veryRare
    debugPrint = true, -- habilita prints de debug no console
    bosses = {
        ["dreadfiend"] = -- the boss's entire name in lower case.
        {
            common = {
                {5832, 1, 100}, -- green gem
                {5937, 10, 100}, -- mystic ore
            },

            semiRare = {
                {5855, 1, 100}, -- smoke bag
				{7594, 1, 100}, -- the ironworker
            },

            rare = {
                {6692, 1, 100}, -- casino token			
                {6217, 1, 100}, -- dreadfiend boots
				{7637, 1, 100}, -- underworld rod
            },

            veryRare = {
                {6166, 1, 100}, -- dreadfiend robe
                {7600, 1, 100}, -- ultimate robe
            },
        
            always = {
                {2160, 25, 100}, -- crystal coin
			    {5937, 30, 100}, -- mystic ore
            },
        
            storage = 65479,
        },
    
        ["lag witch"] = -- the boss's entire name in lower case.
        {
			 common = {
					{6846, 10, 100}, -- crystal coin
					{6088, 1, 100},  -- bless checker
					{6562, 1, 100},  -- smith hammer
					{6840, 1, 100},  -- surprise chest	
					{2523, 1, 100},  -- rainbow shield
					{6846, 5, 100},  -- magic sulphur
					{5804, 1, 100},  -- karma ring
					{6836, 1, 100},  -- 100 karma points
					{8243, 1, 100},  -- magic feather aura					
				},

				semiRare = {
					{6818, 1, 100},  -- temple scroll
					{7632, 1, 100},  -- rainbow shield
					{6755, 1, 100},  -- backpack vol 40
					{6756, 1, 100},  -- backpack vol 40
					{6763, 1, 100},  -- cupid backpack 40vol
					{6155, 1, 100},  -- training book	
					{6610, 1, 100},  -- ultimate surprise bag						
				},

				rare = {

					{6708, 1, 100},  -- royal customer outfit
					{8323, 1, 100},  -- lucky ring (+loot)
					{5807, 1, 100},  -- blessed ring
					{5806, 1, 100},  -- love ring
					{6721, 1, 100},  -- elf outfit
					{6794, 1, 100},  -- mino outfit					
				},

				veryRare = {
					{6836, 1, 100},  -- 100 karma points		
					{6836, 1, 100},  -- 100 karma points
					{2474, 1, 100},  -- winged helmet
					{2640, 1, 100},  -- karma boots
					{7731, 1, 100},  -- food fluid
					{6835, 1, 100},  -- rashid scroll

				},

				always = {
					{8238, 5, 100}, -- jasmin coin
					{6562, 1, 100},  -- mining pick		
					{6838, 1, 100},  -- bless scroll	
					{6698, 1, 100},  -- exp boost	
					{6835, 1, 100},  -- rashid scroll			
				
				},
        
            storage = 65480,
        },
		
        ["terragor"] = -- the boss's entire name in lower case.
        {
            common = {
                {2160, 5, 100}, -- crystal coin
                {2160, 5, 100}, -- crystal coin
            },

            semiRare = {
                {2160, 5, 100}, -- crystal coin
            },

            rare = {
                {6692, 1, 100}, -- casino ticket
            },

            veryRare = {
                {6610, 1, 100}, -- ultimate bag
                {6692, 1, 100}, -- casino ticket
                {8238, 1, 100}, -- jasmin coin			
            },
        
            always = {
                {2160, 5, 100}, --  crystal coin
            },
        
            storage = 65481,
        },	

        ["infernal dreadlord"] = -- the boss's entire name in lower case.
        {
            common = {
                {2160, 25, 100}, -- crystal coin
                {2160, 25, 100}, -- crystal coin
            },

            semiRare = {
                {2160, 25, 100}, -- crystal coin
            },

            rare = {
                {6692, 1, 100}, -- casino ticket
            },

			veryRare = {
				{6167, 1, 100}, -- karma hat
				{6225, 1, 100}, -- karma axe
				{6118, 1, 100}, -- karma sword
				{5791, 1, 100}, -- karma crossbow
				{6128, 1, 100}, -- karma shield
				{6196, 1, 100}, -- karma staff
				{6176, 1, 100}, -- karma legs
				{7630, 1, 100}, -- karma spellbook
				{5818, 1, 100}, -- karma cape
				{6221, 1, 100}, -- karma hammer
				{6174, 1, 100}, -- karma bow
				{6127, 1, 100}  -- karma armor
			},
        
            always = {
                {6692, 1, 100}, -- casino ticket
                {2160, 15, 100}, --  crystal coin
            },
        
            storage = 6581,
        },			
    
        ["ferumbras"] = -- the boss's entire name in lower case.
        {
            common = {
                {2143, 10, 100}, -- white pearl
                {2146, 10, 100}, -- small sapphire
                {2145, 10, 100}, -- small diamond
                {2144, 10, 100}, -- black pearl
                {2149, 10, 100}, -- small emeralds
                {7416, 1, 100}, -- bloody edge
                {7896, 1, 100}, -- glacier kilt
                {2432, 1, 100}, -- fire axe
                {2462, 1, 100}, -- devil helmet
                {7590, 1, 100}, -- great mana potion
                {2179, 1, 100}, -- gold ring
                {2151, 1, 100}, -- talon
            },

            semiRare = {
                {2195, 1, 100}, -- boots of haste
                {2472, 1, 100}, -- magic plate armor
                {2393, 1, 100}, -- giant sword
                {2470, 1, 100}, -- golden legs
                {2514, 1, 100}, -- mastermind shield
            },

            rare = {
                {2520, 1, 100}, -- demon shield
                {2160, 10, 100}, -- emerald sword
                {2522, 1, 100}, -- great shield
                {2421, 1, 100}, -- thunder hammer
            },

            veryRare = {
                {2523, 1, 100}, -- ferumbras' hat
            },
        
            always = {
                {2171, 1, 100}, -- platinum amulet
                {2148, 90, 100}, -- gold coin
                {2146, 10, 100}, -- small sapphire
            },
        
            storage = 65482,
        },
        ["balrog"] = -- the boss's entire name in lower case.
        {
            common = {
                {2143, 10, 100}, -- white pearl
                {2146, 10, 100}, -- small sapphire
                {2145, 10, 100}, -- small diamond
                {2144, 10, 100}, -- black pearl
                {2149, 10, 100}, -- small emeralds
                {7416, 1, 100}, -- bloody edge
                {7896, 1, 100}, -- glacier kilt
                {2432, 1, 100}, -- fire axe
                {2462, 1, 100}, -- devil helmet
                {7590, 1, 100}, -- great mana potion
                {2179, 1, 100}, -- gold ring
                {2151, 1, 100}, -- talon
            },

            semiRare = {
                {2195, 1, 100}, -- boots of haste
                {2472, 1, 100}, -- magic plate armor
                {5901, 1, 100}, -- black demon legs
                {2470, 1, 100}, -- golden legs
                {2514, 1, 100}, -- mastermind shield
            },

            rare = {
                {2520, 1, 100}, -- demon shield
                {8930, 1, 100}, -- emerald sword

            },

            veryRare = {
                {2522, 1, 100}, -- great shield
                {2421, 1, 100}, -- thunder hammer
            },
        
            always = {
                {2171, 1, 100}, -- platinum amulet
                {2148, 90, 100}, -- gold coin
                {2146, 10, 100}, -- small sapphire
            },
        
            storage = 65483,
        },
        ["basilisk"] = -- the boss's entire name in lower case.
        {
            common = {
                {2143, 10, 100}, -- white pearl
                {2146, 10, 100}, -- small sapphire
                {2145, 10, 100}, -- small diamond
                {2144, 10, 100}, -- black pearl
                {2149, 10, 100}, -- small emeralds
                {7416, 1, 100}, -- bloody edge
                {5989, 1, 100}, -- glacier kilt
                {5949, 1, 100}, -- fire axe
                {5948, 1, 100}, -- devil helmet
                {7590, 1, 100}, -- great mana potion
                {6110, 1, 100}, -- gold ring
                {2151, 1, 100}, -- talon
            },

            semiRare = {
                {2195, 1, 100}, -- boots of haste
                {2472, 1, 100}, -- magic plate armor
                {5901, 1, 100}, -- black demon legs
                {2470, 1, 100}, -- golden legs
                {2514, 1, 100}, -- mastermind shield
            },

            rare = {
                {2520, 1, 100}, -- demon shield
                {8930, 1, 100}, -- emerald sword

            },

            veryRare = {
                {6182, 1, 100}, -- great shield
                {5826, 1, 100}, -- thunder hammer
            },
        
            always = {
                {2171, 1, 100}, -- platinum amulet
                {2148, 90, 100}, -- gold coin
                {2146, 10, 100}, -- small sapphire
            },
        
            storage = 65484,
        },		
        ["swamp spider"] = --- the boss's entire name in lower case.
        {
            common = {
                {2155, 1, 100}, -- green gem
                {5937, 15, 100}, -- mystic shard
                {7549, 1, 100}, -- swamp club
            },

            semiRare = {
                {7598, 1, 100}, -- swamp bow
				{7724, 250, 100}, -- ultimate swamp amulet
            },

            rare = {
                {5830, 1, 100}, -- green blood hern
				{7636, 1, 100}, -- swamp shield
            },

            veryRare = {
                {6692, 1, 100}, -- casino token
                {7615, 1, 100}, -- ultimate swamp armor
            },
        
            always = {
                {5830, 1, 100}, -- green blood hern			
                {2160, 10, 100}, -- crystal coin
                {5937, 15, 100}, -- mystic ore
            },
        
            storage = 65485,
        },
        ["mozradek"] = --- the boss's entire name in lower case.
        {
            common = {
                {6692, 1, 100}, -- casino token					
                {5937, 25, 100}, -- mystic shard
            },

            semiRare = {
                {6771, 1, 100}, -- fire backpack
				{5787, 1, 100}, -- fire boots
            },

            rare = {
	
                {7581, 1, 100}, -- mozradek boots
				{6114, 1, 100}, -- underworld rod
            },

            veryRare = {
                {8179, 1, 100}, -- casino token
                {7661, 1, 100}, -- ultimate robe
            },
        
            always = {
                {2160, 30, 100}, -- crystal coin
			    {5937, 25, 100}, -- mystic ore
            },
        
            storage = 65486,
        },		
        ["revenge incarnate"] = -- the boss's entire name in lower case.
        {
            common = {
                {8238, 1, 100}, -- jasmin coin
                {2160, 50, 100}, -- crystal coin
                {8281, 1, 100}, -- clean buff					
            },

            semiRare = {
                {8276, 1, 100}, -- earth buff	
                {8277, 1, 100}, -- physical buff
                {8278, 1, 100}, -- ice buff		
                {8279, 1, 100}, -- holy buff	
                {8280, 1, 100}, -- energy buff			
                {8281, 1, 100}, -- clean buff					
                {8282, 1, 100}, -- fire buff					
                {8283, 1, 100}, -- death buff					
            },

            rare = {
                {6692, 1, 100}, -- casino ticket
                {6610, 1, 100}, -- ultimate bag				
            },

            veryRare = {
                {8238, 5, 100}, -- jasmin coin			
            },
        
            always = {
                {2160, 50, 100}, --  crystal coin
                {8243, 1, 100}, --  magic feather aura				
            },
            storage = 65487,
        },
    }
}