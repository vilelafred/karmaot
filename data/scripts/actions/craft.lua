local scrollsCraft = Action()

function capAll(str)
    return str:gsub("^(%a)", string.upper):gsub("([^%a]%a)", string.upper)
end
local config = {
    mainTitleMsg = "Crafting System",
    mainMsg = "Welcome to the Crafting Machine.\nPlease choose a category:",
 
    craftTitle = "Crafting System: ",
    craftMsg = "Click on Recipe to see the necessary items to craft.\n\nHere is a list of all items available to craft. Some crystals, diamonds and piece of ores are used to craft: ",
    needItems = "You do not have all the required items to make ",
    system = {
    [1] = {tiers = "Runecrafting",
            items = {
                [1] = {
                    item = "Sudden Death Rune",
                    itemID = 2268,
					count = 100,
                    reqItems = {
                        [1] = {item = 2260, count = 1}, -- 1 Blank rune
                        [2] = {item = 5937, count = 20}, -- 4 Iron ore
                    },
                },
                [2] = {
                    item = "Great Fireball Rune", -- Add the name of the new item
                    itemID = 2304, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [3] = {
                    item = "Fire Wall Rune", -- Add the name of the new item
                    itemID = 2303, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },	
                [4] = {
                    item = "Fire Ball Rune", -- Add the name of the new item
                    itemID = 2302, -- Add the ID of the new item
					count = 400,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },	
                [5] = {
                    item = "Fire Field Rune", -- Add the name of the new item
                    itemID = 2301, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },
                [6] = {
                    item = "Fire Bomb Rune", -- Add the name of the new item
                    itemID = 2305, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [7] = {
                    item = "Soulfire Rune", -- Add the name of the new item
                    itemID = 2308, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8118, count = 1}, -- 1 Red Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },
                [8] = {
                    item = "Disintegrate Rune", -- Add the name of the new item
                    itemID = 2310, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8119, count = 1}, -- 1 Purple Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },
                [9] = {
                    item = "Heavy Magic Missile Rune", -- Add the name of the new item
                    itemID = 2311, -- Add the ID of the new item
					count = 500,					
                    reqItems = {
                        [1] = {item = 8119, count = 1}, -- 1 Purple Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [10] = {
                    item = "Explosion Rune", -- Add the name of the new item
                    itemID = 2313, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8119, count = 1}, -- 1 Purple Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [11] = {
                    item = "Thunderstorm Rune", -- Add the name of the new item
                    itemID = 2315, -- Add the ID of the new item
					count = 200,					
                    reqItems = {
                        [1] = {item = 8119, count = 1}, -- 1 Purple Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [12] = {
                    item = "Ultimate Healing Rune", -- Add the name of the new item
                    itemID = 6675, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8114, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 20}, -- 2 Iron ore
                    },
                },
                [13] = {
                    item = "Alavanche Rune", -- Add the name of the new item
                    itemID = 2274, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8114, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 20}, -- 2 Iron ore
                    },
                },
                [14] = {
                    item = "Paralyze Rune", -- Add the name of the new item
                    itemID = 2278, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8115, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 40}, -- 2 Iron ore
                    },
                },
                [15] = {
                    item = "Energy Field Rune", -- Add the name of the new item
                    itemID = 2277, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8115, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },
                [16] = {
                    item = "Poison Field Rune", -- Add the name of the new item
                    itemID = 2285, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },
                [17] = {
                    item = "Poison Bomb Rune", -- Add the name of the new item
                    itemID = 2286, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },	
                [18] = {
                    item = "Light Magic Missile Rune", -- Add the name of the new item
                    itemID = 2287, -- Add the ID of the new item
					count = 500,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 5}, -- 2 Iron ore
                    },
                },	
                [19] = {
                    item = "Convince Creature Rune", -- Add the name of the new item
                    itemID = 2290, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },	
                [20] = {
                    item = "Envenom Rune", -- Add the name of the new item
                    itemID = 2292, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 10}, -- 2 Iron ore
                    },
                },
                [21] = {
                    item = "Chameleon Rune", -- Add the name of the new item
                    itemID = 2291, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 20}, -- 2 Iron ore
                    },
                },
                [22] = {
                    item = "Magic Wall Rune", -- Add the name of the new item
                    itemID = 2293, -- Add the ID of the new item
					count = 100,					
                    reqItems = {
                        [1] = {item = 8117, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 30}, -- 2 Iron ore
                    },
                },
                [23] = {
                    item = "Holy Missile Rune", -- Add the name of the new item
                    itemID = 2295, -- Add the ID of the new item
					count = 300,					
                    reqItems = {
                        [1] = {item = 8116, count = 1}, -- 1 Blue Blank rune
                        [2] = {item = 5937, count = 20}, -- 2 Iron ore
                    },
                },					
           },
       },
				[2] = {tiers = "Fletchery",
				items = {
                [1] = {item = "500x Arrows",
                        itemID = 2544,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },
                [2] = {item = "500x Poison Arrows",
                        itemID = 2545,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8149, count = 10}, -- 10 green crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore								
                            },
                        },	
                [3] = {item = "400x Bolts",
                        itemID = 2543,
						count = 400, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },	
                [4] = {item = "500x Piercing Bolts",
                        itemID = 7691,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 5937, count = 10}, -- 1 mystic ore
                            },
                        },	
                [5] = {item = "500x Infernal Bolts",
                        itemID = 6499,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8147, count = 100}, -- 10 red crystal
								[2] = {item = 5937, count = 100}, -- 1 mystic ore
                            },
                        },	
                [6] = {item = "500x Enchanted Bolts",
                        itemID = 6498,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8145, count = 100}, -- 10 red crystal
								[2] = {item = 5937, count = 100}, -- 1 mystic ore
                            },
                        },								
                [7] = {item = "300x Sniper Arrows",
                        itemID = 7692,
						count = 300, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },	
                [8] = {item = "500x Earth Arrows",
                        itemID = 7738,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8149, count = 10}, -- 10 green crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },
                [9] = {item = "500x Flaming Arrows",
                        itemID = 7690,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8147, count = 50}, -- 10 red crystal
								[2] = {item = 5937, count = 25}, -- 1 mystic ore
                            },
                        },
                [10] = {item = "500x Flash Arrows",
                        itemID = 7688,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8148, count = 10}, -- 10 yellow crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },
                [11] = {item = "500x Shiver Arrows",
                        itemID = 7689,
						count = 500, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8145, count = 10}, -- 10 blue crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },
                [12] = {item = "200x Burst Arrows",
                        itemID = 2546,
						count = 200, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8147, count = 10}, -- 10 red crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },
                [13] = {item = "200x Power Bolts",
                        itemID = 2547,
						count = 200, -- Quantidade do item que o jogador recebe
                        reqItems = {
								[1] = {item = 8145, count = 10}, -- 10 blue crystal
								[2] = {item = 5937, count = 1}, -- 1 mystic ore
                            },
                        },								
                },
            },	
    [3] = {tiers = "Jewelry",
            items = {
                [1] = {item = "Dwarven Ring",
                        itemID = 2213,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 1}, -- 1 mystic ore
                                [2] = {item = 8147, count = 2}, -- 2 blue crystal
                                [3] = {item = 8145, count = 2}, -- 2 red crystal
								[4] = {item = 8149, count = 2}, -- 2 blue crystal
                            },
                        },
                [2] = {item = "Life Ring",
                        itemID = 2168,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 5}, -- 5 mystic ore
                                [2] = {item = 8149, count = 20}, -- 20 green crystal
                            },
                        },
                [3] = {item = "Axe Ring",
                        itemID = 2208,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 3}, -- 3 mystic ore
                                [2] = {item = 8144, count = 10}, -- 10 white crystal
                            },
                        },
                [4] = {item = "Sword Ring",
                        itemID = 2207,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 3}, -- 3 mystic ore
                                [2] = {item = 8147, count = 20}, -- 20 green crystal
								[3] = {item = 8148, count = 20}, -- 20 green crystal
                            },
                        },	
                [14] = {item = "Sword Ring",
                        itemID = 2207,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 3}, -- 3 mystic ore
                                [2] = {item = 8147, count = 20}, -- 20 red crystal
								[3] = {item = 8148, count = 20}, -- 20 yellow crystal
                            },
                        },		
                [5] = {item = "Club Ring",
                        itemID = 2209,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 1}, -- 1 mystic ore
                                [2] = {item = 8144, count = 20}, -- 20 white crystal
								[3] = {item = 8147, count = 20}, -- 20 red crystal
                            },
                        },
                [6] = {item = "Ring of Healing",
                        itemID = 2214,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 12}, -- 12 mystic ore
                                [2] = {item = 8147, count = 40}, -- 20 red crystal
                            },
                        },
                [7] = {item = "Energy Ring",
                        itemID = 2167,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 20}, -- 20 mystic ore
                                [2] = {item = 8145, count = 20}, -- 20 blue crystal
                            },
                        },	
                [8] = {item = "Time Ring",
                        itemID = 2169,
						count = 4,						
                        reqItems = {
                                [1] = {item = 5937, count = 8}, -- 8 mystic ore
                                [2] = {item = 8145, count = 10}, -- 10 blue crystal
					            [3] = {item = 8147, count = 10}, -- 10 red crystal
					            [4] = {item = 8148, count = 10}, -- 10 green crystal								
                            },
                        },	
                [9] = {item = "Silver Amulet",
                        itemID = 2170,
						count = 200,						
                        reqItems = {
                                [1] = {item = 5937, count = 2}, -- 2 mystic ore
                                [2] = {item = 2145, count = 5}, -- 5 smaill diamond							
                            },
                        },	
                [10] = {item = "Bronze Amulet",
                        itemID = 2172,
						count = 200,						
                        reqItems = {
                                [1] = {item = 5937, count = 2}, -- 2 mystic ore
                                [2] = {item = 2145, count = 5}, -- 5 smaill diamond								
                            },
                        },
                [11] = {item = "Garlic Necklace",
                        itemID = 2199,
						count = 150,						
                        reqItems = {
                                [1] = {item = 5937, count = 2}, -- 2 mystic ore
                                [2] = {item = 2145, count = 5}, -- 5 smaill diamond							
                            },
                        },
                [12] = {item = "Protection Amulet",
                        itemID = 2200,
						count = 250,						
                        reqItems = {
                                [1] = {item = 5937, count = 2}, -- 2 mystic ore
                                [2] = {item = 8144, count = 10}, -- 10 white crystal
								[3] = {item = 2145, count = 2}, -- 2 smaill diamond											
                            },
                        },
                [13] = {item = "Dragon Necklace",
                        itemID = 2201,
						count = 200,						
                        reqItems = {
                                [1] = {item = 5937, count = 2}, -- 2 mystic ore
                                [2] = {item = 8149, count = 20}, -- 20 green crystal
								[3] = {item = 2149, count = 2}, -- 2 small emerald									
                            },
                        },
                [14] = {item = "Elven Amulet",
                        itemID = 2198,
						count = 50,						
                        reqItems = {
                                [1] = {item = 5937, count = 3}, -- 3 mystic ore
                                [2] = {item = 2146, count = 4}, -- 4 small sapphires
								[3] = {item = 2149, count = 4}, -- 4 small emerald
								[4] = {item = 2145, count = 4}, -- 4 small diamonds									
                            },
                        },							
                },
            },
    [4] = {tiers = "Mining",
            items = {
                [1] = {item = "Mining Pick",
                        itemID = 8206,
						count = 1,						
                        reqItems = {
                                [1] = {item = 5937, count = 20}, -- 20 mystic ore
                            },
                        },
                [2] = {item = "Golden Mining Pick",
                        itemID = 8178,
						count = 1,						
                        reqItems = {
                                [1] = {item = 5937, count = 100}, -- 100 mystic ore
                                [2] = {item = 8148, count = 100}, -- 100 green crystal
                            },
                        },
                [3] = {item = "Diamond Mining Pick",
                        itemID = 8177,
						count = 1,						
                        reqItems = {
                                [1] = {item = 5937, count = 200}, -- 200 mystic ore
                                [2] = {item = 8145, count = 200}, -- 100 blue crystal								
                            },
                        },							
                },
            },			
            [5] = {tiers = "Alchemy",
            items = {
                [1] = {item = "Mana Rune",
                        itemID = 2281,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 500}, -- 500 mystic ore
                            },
                        },	
                [2] = {item = "Mana Rune +2",
                        itemID = 6656,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 700}, -- 700 mystic ore
                            },
                        },								
                [3] = {item = "Mana Rune +3",
                        itemID = 2284,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 900}, -- 900 mystic ore
                            },
                        },		
                [4] = {item = "Mana Rune +4",
                        itemID = 6659,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 1100}, -- 1100 mystic ore
                            },
                        },
                [5] = {item = "Mana Rune +5",
                        itemID = 6660,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 1300}, -- 1300 mystic ore
                            },
                        },								
                [6] = {item = "Holy Mana Rune",
                        itemID = 2300,
						count = 500,						
                        reqItems = {
                                [1] = {item = 5937, count = 700}, -- 700 mystic ore
                            },
                        },							
                [7] = {item = "Magic Sulphur",
                        itemID = 6846,
						count = 1,						
                        reqItems = {
                                [1] = {item = 5937, count = 500}, -- 500 mystic ore
                            },
                        },
                [8] = {item = "Mana Potion",
                        itemID = 6147,
						count = 50,						
                        reqItems = {
                                [1] = {item = 5937, count = 5}, -- 5 mystic ore
                            },
                        },						
                [9] = {
                    item = "Health Potion", -- Add the name of the new item
                    itemID = 6146, -- Add the ID of the new item
					count = 50,					
                    reqItems = {
                        [1] = {item = 5937, count = 5}, -- 1 mystic ore
                    },
                },
                [10] = {
                    item = "Blue Blank Rune", -- Add the name of the new item
                    itemID = 8114, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8145, count = 5}, -- 5 blue crystal
                    },
                },
                [11] = {
                    item = "Babyblue Blank Rune", -- Add the name of the new item
                    itemID = 8115, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8145, count = 5}, -- 5 blue crystal
                    },
                },	
                [12] = {
                    item = "Green Blank Rune", -- Add the name of the new item
                    itemID = 8116, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8149, count = 5}, -- 5 green crystal
                    },
                },
                [13] = {
                    item = "Yellow Blank Rune", -- Add the name of the new item
                    itemID = 8117, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8148, count = 5}, -- 5 yellow crystal
                    },
                },
                [14] = {
                    item = "Red Blank Rune", -- Add the name of the new item
                    itemID = 8118, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8147, count = 5}, -- 5 red crystal
                    },
                },
                [15] = {
                    item = "Purple Blank Rune", -- Add the name of the new item
                    itemID = 8119, -- Add the ID of the new item
					count = 5,					
                    reqItems = {
                        [1] = {item = 5937, count = 1}, -- 1 mystic ore
						[2] = {item = 8146, count = 5}, -- 5 purple crystal
                    },
                },						
            },
        },
        -- Add other categories as needed
    },
}
 
function scrollsCraft.onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)
        player:sendMainCraftWindow(config)
        return true
end
scrollsCraft:id(7729)
scrollsCraft:register()