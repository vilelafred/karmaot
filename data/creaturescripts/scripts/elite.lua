function onDeath(cid, corpse, deathList, pos)

    if isMonster(cid) then
        -- Mapeamento de monstros para suas versões "Elite"
        local eliteMonsters = {
            ["Amazon"] = "Elite Amazon",	
			["Ancient Scarab"] = "Elite Ancient Scarab",
			["Ancient Giant Spider"] = "Elite Ancient Giant Spider",			
			["Assassin"] = "Elite Assassin",
			["Badger"] = "Elite Badger",
			["Bandit"] = "Elite Bandit",
			["Banshee"] = "Elite Banshee",
			["Morguthis"] = "Elite Morguthis",
			["Ashmunrah"] = "Elite Ashmunrah",					
			["Bear"] = "Elite Bear",
			["Bat"] = "Elite Bat",
			["Terran Belphegor"] = "Elite Terran Belphegor",			
			["Bear"] = "Elite Bear",			
			["Behemoth"] = "Elite Behemoth",
			["Beholder"] = "Elite Beholder",
			["Black Knight"] = "Elite Black Knight",
			["Blue Djinn"] = "Elite Blue Djinn",
			["Bonebeast"] = "Elite Bonebeast",
			["Bog Raider"] = "Elite Bog Raider",
			["Blood Crab"] = "Elite Blood Crab",			
			["Bug"] = "Elite Bug",
			["Carniphila"] = "Elite Carniphila",
			["Cave Rat"] = "Elite Cave Rat",
			["Centipede"] = "Elite Centipede", 
			["Belphegor"] = "Elite Belphegor",			
			["Brog"] = "Elite Brog",					
			["Cobra"] = "Elite Cobra",
			["Hellfire Fighter"] = "Elite Hellfire Fighter",			
			["Nature Golem"] = "Elite Nature Golem",			
			["Lory Keeper"] = "Elite Lory Keeper",
			["Lory Madam"] = "Elite Lory Madam",			
			["Crocodile"] = "Elite Crocodile",
			["Crypt Shambler"] = "Elite Crypt Shambler",
			["Cyclops"] = "Elite Cyclops",
			["Mystical Dragon"] = "Elite Mystical Dragon",			
			["Queen Medusa"] = "Elite Queen Medusa",
			["Medusa"] = "Elite Medusa",			
			["Black Demon"] = "Elite Black Demon",			
			["Dark Monk"] = "Elite Dark Monk",
			["Demon Skeleton"] = "Elite Demon Skeleton",
			["Skeleton Warrior"] = "Elite Skeleton Warrior",			
			["Demon"] = "Elite Demon",
			["Dragon Lord"] = "Elite Dragon Lord",
			["Red Magician"] = "Elite Red Magician",			
			["Dragon"] = "Elite Dragon",
			["Solar Dragon"] = "Elite Solar Dragon",			
			["Dwarf Geomancer"] = "Elite Dwarf Geomancer",
			["Dwarf Guard"] = "Elite Dwarf Guard",
			["Dwarf Soldier"] = "Elite Dwarf Soldier",
			["Dwarf"] = "Elite Dwarf",
			["Dworc Fleshhunter"] = "Elite Dworc Fleshhunter",
			["Dworc Venomsniper"] = "Elite Dworc Venomsniper",
			["Dworc Voodoomaster"] = "Elite Dworc Voodoomaster",
			["Dworc Fleshhunter"] = "Elite Dworc Fleshhunter",
			["Dworc Venomsniper"] = "Elite Dworc Venomsniper",
			["Dworc Voodoomaster"] = "Elite Dworc Voodoomaster",
			["Efreet"] = "Elite Efreet",
			["Golden Hero"] = "Elite Golden Hero",
			["Silver Hero"] = "Elite Silver Hero",
			["Jasmin Hero"] = "Elite Jasmin Hero",
			["Tark Trueblade"] = "Elite Tark Trueblade",				
			["Hellvain"] = "Elite Hellvain",
			["Vorgrath"] = "Elite Vorgrath",				
			["Elder Beholder"] = "Elite Elder Beholder",
			["Elephant"] = "Elite Elephant",
			["Elf Arcanist"] = "Elite Elf Arcanist",
			["Elf Scout"] = "Elite Elf Scout",
			["Elf"] = "Elite Elf",
			["Fire Devil"] = "Elite Fire Devil",
			["Fire Elemental"] = "Elite Fire Elemental",
			["Frost Troll"] = "Elite Frost Troll",
			["Frost Dragon"] = "Elite Frost Dragon",			
			["Frost Dragon Hatchling"] = "Elite Frost Dragon Hatchling",			
			["Gargoyle"] = "Elite Gargoyle",
			["Gazer"] = "Elite Gazer",
			["Ghost"] = "Elite Ghost",
			["Ghoul"] = "Elite Ghoul",
			["Giant Spider"] = "Elite Giant Spider",
			["Grim Reaper"] = "Elite Grim Reaper",			
			["Goblin"] = "Elite Goblin",
			["Green Djinn"] = "Elite Green Djinn",
			["Hero"] = "Elite Hero",
			["Hunter"] = "Elite Hunter",
			["Hyaena"] = "Elite Hyaena",
			["Hydra"] = "Elite Hydra",
			["Island Troll"] = "Elite Island Troll",				
			["Kongra"] = "Elite Kongra",
			["Larva"] = "Elite Larva",
			["Lich"] = "Elite Lich",
			["Lion"] = "Elite Lion",
			["Fury"] = "Elite Fury",			
			["Lizard Sentinel"] = "Elite Lizard Sentinel",
			["Lizard Snakecharmer"] = "Elite Lizard Snakecharmer",
			["Lizard Templar"] = "Elite Lizard Templar",
			["Marid"] = "Elite Marid",
			["Red Magician"] = "Elite Red Magician",			
			["Merlkin"] = "Elite Merlkin",
			["Minotaur Archer"] = "Elite Minotaur Archer",
			["Minotaur Guard"] = "Elite Minotaur Guard",
			["Minotaur Mage"] = "Elite Minotaur Mage",
			["Minotaur"] = "Elite Minotaur",
			["Monk"] = "Elite Monk",
			["Mummy"] = "Elite Mummy",
			["Necromancer"] = "Elite Necromancer",
			["Orc Berserker"] = "Elite Orc Berserker",
			["Orc Leader"] = "Elite Orc Leader",
			["Orc Rider"] = "Elite Orc Rider",
			["Orc Shaman"] = "Elite Orc Shaman",
			["Orc Spearman"] = "Elite Orc Spearman",
			["Orc Warlord"] = "Elite Orc Warlord",
			["Orc Warrior"] = "Elite Orc Warrior",
			["Orc"] = "Elite Orc",
			["Panda"] = "Elite Panda",
			["Poison Spider"] = "Elite Poison Spider",
			["Polar Bear"] = "Elite Polar Bear",
			["Priestess"] = "Elite Priestess",
			["Nokmir"] = "Elite Nokmir",			
			["Pirate Buccaneer"] = "Elite Pirate Buccaneer",
			["Pirate Corsair"] = "Elite Pirate Corsair",
			["Pirate Cutthroat"] = "Elite Pirate Cutthroat",
			["Pirate Ghost"] = "Elite Pirate Ghost",
			["Pirate Marauder"] = "Elite Pirate Marauder",
			["Pirate Skeleton"] = "Elite Pirate Skeleton",			
			["Rat"] = "Elite Rat",
			["Rotworm"] = "Elite Rotworm",
			["Scarab"] = "Elite Scarab",
			["Scorpion"] = "Elite Scorpion",
			["Serpent Spawn"] = "Elite Serpent Spawn",
			["Sibang"] = "Elite Sibang",
			["Skeleton"] = "Elite Skeleton",
			["Swamp Spider"] = "Elite Swamp Spider",
			["Skunk"] = "Elite Skunk",
			["Slime"] = "Elite Slime",
			["Smuggler"] = "Elite Smuggler",
			["Snake"] = "Elite Snake",
			["Spider"] = "Elite Spider",
			["Spit Nettle"] = "Elite Spit Nettle",
			["Stalker"] = "Elite Stalker",
			["Stone Golem"] = "Elite Stone Golem",
			["Swamp Troll"] = "Elite Swamp Troll",
			["Tarantula"] = "Elite Tarantula",
			["Terror Bird"] = "Elite Terror Bird",
			["Tiger"] = "Elite Tiger",
			["Troll"] = "Elite Troll",
			["Troll Constructor"] = "Elite Troll Constructor",
			["Valkyrie"] = "Elite Valkyrie",
			["Vampire"] = "Elite Vampire",
			["War Wolf"] = "Elite War Wolf",
			["Warlock"] = "Elite Warlock",
			["Wasp"] = "Elite Wasp",
			["Wild Warrior"] = "Elite Wild Warrior",
			["Winter Wolf"] = "Elite Winter Wolf",
			["Witch"] = "Elite Witch",
			["Milenar Dragon"] = "Elite Milenar Dragon",			
			["Wolf"] = "Elite Wolf",
			["Wyrm"] = "Elite Wyrm"					
			
            -- Adicione mais mapeamentos conforme necessário
        }

        local monsterName = getCreatureName(cid)

        -- Verifique se o monstro tem uma versão "Elite" no mapeamento
        local eliteMonster = eliteMonsters[monsterName]

        if eliteMonster then
            -- Defina a probabilidade desejada (por exemplo, 30% de chance)
            local chance = 5

            -- Gere um número aleatório entre 1 e 100
            local randomValue = math.random(1, 100)

            -- Verifique se o número aleatório está dentro da probabilidade desejada
            if randomValue <= chance then
                -- Exiba o efeito de teleport continuamente até que o monstro seja invocado
                local teleportEffect = 49 -- Substitua pelo efeito de teleport desejado
                local teleportPosition = getCreaturePosition(cid)

                local function showTeleportEffect()
                    doSendMagicEffect(teleportPosition, teleportEffect)
                end

                -- Agende a exibição contínua do efeito de teleport por 4 segundos
                for i = 1000, 4000, 1000 do
                    addEvent(showTeleportEffect, i)
                end

                -- Agende a invocação do monstro "Elite" com um atraso de 4 segundos (4000 milissegundos)
                addEvent(doSummonCreature, 4000, eliteMonster, teleportPosition)
            end
        end
    end

    return true
end
