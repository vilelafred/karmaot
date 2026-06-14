local taskPointStorage = 5151 -- which player storage holds task points.

local configTasks = {
	[1] = { 
		nameOfTheTask = "Brown Witch",
		looktype = { type = 395 },
		killsRequired = 1000,
		rewards = {
			expReward = 28000000,
		}
	},
	[2] = { 
		nameOfTheTask = "Ancient Giant Spider",
		looktype = { type = 38 },
		killsRequired = 300,
		rewards = {
			expReward = 2262500,
		}
	},
	[3] = { 
		nameOfTheTask = "Bog Raider",
		looktype = { type = 726 },
		killsRequired = 500,
		rewards = {
			expReward = 3500000,
		}
	},
	[4] = { 
		nameOfTheTask = "Behemoth",
		looktype = { type = 55 },
		killsRequired = 300,
		rewards = {
			expReward = 2812500,
		}
	},
	[5] = { 
		nameOfTheTask = "Ladies of red rose",
		looktype = { type = 137 },
		killsRequired = 1000,
		rewards = {
			expReward = 28000000,
		}
	},
	[6] = { 
		nameOfTheTask = "Black knight",
		looktype = { type = 131 },
		killsRequired = 300,
		rewards = {
			expReward = 1800000,
		}
	},
	[7] = { 
		nameOfTheTask = "Spider Queen",
		looktype = { type = 367 },
		killsRequired = 1000,
		rewards = {
			expReward = 28000000,
		}
	},
	[8] = { 
		nameOfTheTask = "Dark Warrior",
		looktype = { type = 667 },
		killsRequired = 1000,
		rewards = {
			expReward = 60000000,
		}
	},
	[9] = { 
		nameOfTheTask = "Red legion soldier",
		looktype = { type = 137 },
		killsRequired = 1000,
		rewards = {
			expReward = 28000000,
		}
	},
	[10] = { 
		nameOfTheTask = "Demon",
		looktype = { type = 35 },
		killsRequired = 666,
		rewards = {
			expReward = 6666666,
		}
	},
	[11] = { 
		nameOfTheTask = "Dragon",
		looktype = { type = 34 },
		killsRequired = 300,
		rewards = {
			expReward = 1312500,
		}
	},
	[12] = { 
		nameOfTheTask = "Dragon lord",
		looktype = { type = 39 },
		killsRequired = 300,
		rewards = {
			expReward = 2362500,
		}
	},
	[13] = { 
		nameOfTheTask = "Skeleton Warrior",
		looktype = { type = 348 },
		killsRequired = 1000,
		rewards = {
			expReward = 55000000,
		}
	},
	[14] = { 
		nameOfTheTask = "Burning Demon Skeleton",
		looktype = { type = 462 },
		killsRequired = 500,
		rewards = {
			expReward = 5000000,
		}
	},
	[15] = { 
		nameOfTheTask = "Abyssal Tempest",
		looktype = { type = 292 },
		killsRequired = 1000,
		rewards = {
			expReward = 65000000,
		}
	},
	[16] = { 
		nameOfTheTask = "Frost Dragon",
		looktype = { type = 714 },
		killsRequired = 300,
		rewards = {
			expReward = 2362500,
		}
	},
	[62] = { 
		nameOfTheTask = "Frozen Hero",
		looktype = { type = 329 },
		killsRequired = 350,
		rewards = {
			expReward = 2200000,
		}
	},
	[64] = { 
		nameOfTheTask = "Queen Medusa",
		looktype = { type = 465 },
		killsRequired = 400,
		rewards = {
			expReward = 8200000,
		}
	},
	[65] = { 
		nameOfTheTask = "Black Demon",
		looktype = { type = 256 },
		killsRequired = 400,
		rewards = {
			expReward = 8000000,
		}
	},
	[66] = { 
		nameOfTheTask = "Mystical Dragon",
		looktype = { type = 260 },
		killsRequired = 400,
		rewards = {
			expReward = 8500000,
		}
	},
	[67] = { 
		nameOfTheTask = "Dark Torturer",
		looktype = { type = 256 },
		killsRequired = 400,
		rewards = {
			expReward = 3000000,
		}
	},
	[68] = { 
		nameOfTheTask = "Grim Reaper",
		looktype = { type = 341 },
		killsRequired = 350,
		rewards = {
			expReward = 3500000,
		}
	},	
	[69] = { 
		nameOfTheTask = "Darkness Skeleton",
		looktype = { type = 339 },
		killsRequired = 350,
		rewards = {
			expReward = 2500000,
		}
	},
	[84] = { 
		nameOfTheTask = "Skull Dragon",
		looktype = { type = 346 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},
	[70] = { 
		nameOfTheTask = "Ashmunrah",
		looktype = { type = 87 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},	
	[71] = { 
		nameOfTheTask = "Morguthis",
		looktype = { type = 90 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},		
	[72] = { 
		nameOfTheTask = "Golden Hero",
		looktype = { type = 431 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},
	[73] = { 
		nameOfTheTask = "Water Sorcerer",
		looktype = { type = 384 },
		killsRequired = 500,
		rewards = {
			expReward = 9500000,
		}
	},
	[74] = { 
		nameOfTheTask = "Water Golem",
		looktype = { type = 372 },
		killsRequired = 500,
		rewards = {
			expReward = 9500000,
		}
	},		
	[75] = { 
		nameOfTheTask = "White Magician",
		looktype = { type = 323 },
		killsRequired = 500,
		rewards = {
			expReward = 15500000,
		}
	},	
	[76] = { 
		nameOfTheTask = "Omruc",
		looktype = { type = 90 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},	
	[77] = { 
		nameOfTheTask = "Dipthrah",
		looktype = { type = 87 },
		killsRequired = 500,
		rewards = {
			expReward = 10500000,
		}
	},
	[78] = { 
		nameOfTheTask = "Revenge Spirit",
		looktype = { type = 273 },
		killsRequired = 1000,
		rewards = {
			expReward = 80000000,
		}
	},		
	[79] = { 
		nameOfTheTask = "Brog",
		looktype = { type = 285 },
		killsRequired = 1000,
		rewards = {
			expReward = 70000000,
		}
	},
	[80] = { 
		nameOfTheTask = "Iron Golem",
		looktype = { type = 233 },
		killsRequired = 1000,
		rewards = {
			expReward = 75000000,
		}
	},
	[81] = { 
		nameOfTheTask = "Pirate Marauder",
		looktype = { type = 130 },
		killsRequired = 1000,
		rewards = {
			expReward = 8500000,
		}
	},	
	[82] = { 
		nameOfTheTask = "Pirate Skeleton",
		looktype = { type = 731 },
		killsRequired = 1000,
		rewards = {
			expReward = 10000000,
		}
	},	
	[83] = { 
		nameOfTheTask = "Barbarian Skullhunter",
		looktype = { type = 746 },
		killsRequired = 500,
		rewards = {
			expReward = 15000000,
		}
	},
	[85] = { 
		nameOfTheTask = "Barbarian Brutetamer",
		looktype = { type = 756 },
		killsRequired = 500,
		rewards = {
			expReward = 15000000,
		}
	},
	[86] = { 
		nameOfTheTask = "Hellvain",
		looktype = { type = 471 },
		killsRequired = 500,
		rewards = {
			expReward = 17500000,
		}
	},	
	[87] = { 
		nameOfTheTask = "Vorgrath",
		looktype = { type = 472 },
		killsRequired = 500,
		rewards = {
			expReward = 17500000,
		}
	},
	[88] = { 
		nameOfTheTask = "Silver Hero",
		looktype = { type = 432 },
		killsRequired = 500,
		rewards = {
			expReward = 15000000,
		}
	},	
	[89] = { 
		nameOfTheTask = "Jasmin Hero",
		looktype = { type = 433 },
		killsRequired = 500,
		rewards = {
			expReward = 16500000,
		}
	},	
	[90] = { 
		nameOfTheTask = "Tark Trueblade",
		looktype = { type = 371 },
		killsRequired = 500,
		rewards = {
			expReward = 17500000,
		}
	},	
	[91] = { 
		nameOfTheTask = "Lory Madam",
		looktype = { type = 774 },
		killsRequired = 500,
		rewards = {
			expReward = 15000000,
		}
	},	
	[92] = { 
		nameOfTheTask = "Lory Keeper",
		looktype = { type = 773 },
		killsRequired = 500,
		rewards = {
			expReward = 15000000,
		}
	},
	[63] = { 
		nameOfTheTask = "Fury",
		looktype = { type = 139 },
		killsRequired = 500,
		rewards = {
			expReward = 3200000,
		}
	},	
	[17] = { 
		nameOfTheTask = "Hellfire Fighter",
		looktype = { type = 302 },
		killsRequired = 1000,
		rewards = {
			expReward = 35000000,
		}
	},
	[18] = { 
		nameOfTheTask = "Goshnar",
		looktype = { type = 245 },
		killsRequired = 1000,
		rewards = {
			expReward = 60000000,
		}
	},
	[19] = { 
		nameOfTheTask = "Terran Belphegor",
		looktype = { type = 373 },
		killsRequired = 1000,
		rewards = {
			expReward = 55000000,
		}
	},
	[20] = { 
		nameOfTheTask = "Giant spider",
		looktype = { type = 38 },
		killsRequired = 300,
		rewards = {
			expReward = 1900000,
		}
	},
	[21] = { 
		nameOfTheTask = "Belphegor",
		looktype = { type = 242 },
		killsRequired = 1000,
		rewards = {
			expReward = 40000000,
		}
	},
	[22] = { 
		nameOfTheTask = "Hellspawn",
		looktype = { type = 336 },
		killsRequired = 350,
		rewards = {
			expReward = 2925000,
		}
	},
	[23] = { 
		nameOfTheTask = "Hero",
		looktype = { type = 73 },
		killsRequired = 300,
		rewards = {
			expReward = 1800000,
		}
	},
	[24] = { 
		nameOfTheTask = "Hydra",
		looktype = { type = 121 },
		killsRequired = 300,
		rewards = {
			expReward = 2362500,
		}
	},
	[25] = { 
		nameOfTheTask = "Sister Marwen",
		looktype = { type = 392 },
		killsRequired = 1000,
		rewards = {
			expReward = 28000000,
		}
	},
	[26] = { 
		nameOfTheTask = "Nature Golem",
		looktype = { type = 380 },
		killsRequired = 1000,
		rewards = {
			expReward = 10500000,
		}
	},
	[27] = { 
		nameOfTheTask = "Minotaur",
		looktype = { type = 25 },
		killsRequired = 100,
		rewards = {
			expReward = 187500,
		}
	},
	[61] = { 
		nameOfTheTask = "Milenar Dragon",
		looktype = { type = 261 },
		killsRequired = 400,
		rewards = {
			expReward = 4950000,
		}
	},	
	[28] = { 
		nameOfTheTask = "Minotaur archer",
		looktype = { type = 24 },
		killsRequired = 200,
		rewards = {
			expReward = 195000,
		}
	},
	[29] = { 
		nameOfTheTask = "Minotaur guard",
		looktype = { type = 29 },
		killsRequired = 200,
		rewards = {
			expReward = 420000,
		}
	},
	[30] = { 
		nameOfTheTask = "Minotaur mage",
		looktype = { type = 23 },
		killsRequired = 200,
		rewards = {
			expReward = 393750,
		}
	},
	[31] = { 
		nameOfTheTask = "Mummy",
		looktype = { type = 65 },
		killsRequired = 400,
		rewards = {
			expReward = 393750,
		}
	},
	[32] = { 
		nameOfTheTask = "Necromancer",
		looktype = { type = 9 },
		killsRequired = 300,
		rewards = {
			expReward = 1087500,
		}
	},
	[33] = { 
		nameOfTheTask = "Nokmir",
		looktype = { type = 708 },
		killsRequired = 350,
		rewards = {
			expReward = 2812500,
		}
	},
	[34] = { 
		nameOfTheTask = "Orc",
		looktype = { type = 5 },
		killsRequired = 100,
		rewards = {
			expReward = 93750,
		}
	},
	[35] = { 
		nameOfTheTask = "Orc rider",
		looktype = { type = 4 },
		killsRequired = 100,
		rewards = {
			expReward = 330000,
		}
	},
	[36] = { 
		nameOfTheTask = "Orc shaman",
		looktype = { type = 6 },
		killsRequired = 100,
		rewards = {
			expReward = 330000,
		}
	},
	[37] = { 
		nameOfTheTask = "Orc spearman",
		looktype = { type = 50 },
		killsRequired = 100,
		rewards = {
			expReward = 142500,
		}
	},
	[38] = { 
		nameOfTheTask = "Orc warlord",
		looktype = { type = 2 },
		killsRequired = 100,
		rewards = {
			expReward = 1256250,
		}
	},
	[39] = { 
		nameOfTheTask = "Orc warrior",
		looktype = { type = 7 },
		killsRequired = 100,
		rewards = {
			expReward = 187500,
		}
	},
	[40] = { 
		nameOfTheTask = "Poison spider",
		looktype = { type = 36 },
		killsRequired = 100,
		rewards = {
			expReward = 82500,
		}
	},
	[41] = { 
		nameOfTheTask = "Priestess",
		looktype = { type = 58 },
		killsRequired = 100,
		rewards = {
			expReward = 787500,
		}
	},
	[42] = { 
		nameOfTheTask = "Rat",
		looktype = { type = 21 },
		killsRequired = 100,
		rewards = {
			expReward = 18750,
		}
	},
	[43] = { 
		nameOfTheTask = "Red magician",
		looktype = { type = 240 },
		killsRequired = 350,
		rewards = {
			expReward = 2872500,
		}
	},
	[44] = { 
		nameOfTheTask = "Rotworm",
		looktype = { type = 26 },
		killsRequired = 100,
		rewards = {
			expReward = 150000,
		}
	},
	[45] = { 
		nameOfTheTask = "Scarab",
		looktype = { type = 83 },
		killsRequired = 100,
		rewards = {
			expReward = 360000,
		}
	},
	[46] = { 
		nameOfTheTask = "Mahrdis",
		looktype = { type = 90 },
		killsRequired = 1000,
		rewards = {
			expReward = 12500000,
		}
	},
	[47] = { 
		nameOfTheTask = "Darkness Dragon",
		looktype = { type = 264 },
		killsRequired = 350,
		rewards = {
			expReward = 5250000,
		}
	},
	[48] = { 
		nameOfTheTask = "Serpent Spawn",
		looktype = { type = 220 },
		killsRequired = 350,
		rewards = {
			expReward = 2250000,
		}
	},
	[49] = { 
		nameOfTheTask = "Hand of Cursed Fate",
		looktype = { type = 313 },
		killsRequired = 1000,
		rewards = {
			expReward = 12500000,
		}
	},
	[50] = { 
		nameOfTheTask = "Pirate Ghost",
		looktype = { type = 732 },
		killsRequired = 1000,
		rewards = {
			expReward = 8500000,
		}
	},
	[51] = { 
		nameOfTheTask = "Solar dragon",
		looktype = { type = 262 },
		killsRequired = 350,
		rewards = {
			expReward = 4462500,
		}
	},
	[52] = { 
		nameOfTheTask = "Pirate Corsair",
		looktype = { type = 731 },
		killsRequired = 1000,
		rewards = {
			expReward = 12500000,
		}
	},
	[53] = { 
		nameOfTheTask = "Pirate Cutthroat",
		looktype = { type = 711 },
		killsRequired = 1000,
		rewards = {
			expReward = 8500000,
		}
	},
	[54] = { 
		nameOfTheTask = "Crystal Spider",
		looktype = { type = 718 },
		killsRequired = 1000,
		rewards = {
			expReward = 7500000,
		}
	},
	[55] = { 
		nameOfTheTask = "Pirate Marauder",
		looktype = { type = 130 },
		killsRequired = 1000,
		rewards = {
			expReward = 8500000,
		}
	},
	[56] = { 
		nameOfTheTask = "Dark Magician",
		looktype = { type = 130 },
		killsRequired = 1000,
		rewards = {
			expReward = 65000000,
		}
	},
	[57] = { 
		nameOfTheTask = "Warlock",
		looktype = { type = 130 },
		killsRequired = 300,
		rewards = {
			expReward = 3000000,
		}
	},
	[58] = { 
		nameOfTheTask = "Shade Leviathan",
		looktype = { type = 363 },
		killsRequired = 1000,
		rewards = {
			expReward = 85000000,
		}
	},
	[59] = { 
		nameOfTheTask = "Shiny Demon",
		looktype = { type = 315 },
		killsRequired = 1000,
		rewards = {
			expReward = 50000000,
		}
	},
	[60] = { 
		nameOfTheTask = "Wyrm",
		looktype = { type = 291 },
		killsRequired = 300,
		rewards = {
			expReward = 1743750,
		}
	},
}

TaskSystem = {
    list = {},
    baseStorage = 1500,
    maximumTasks = 100,
    countForParty = true,
    maxDist = 7,
    players = {},
    loadDatabase = function()
        if (#TaskSystem.list > 0) then
            return true
        end
		
		-- Preenche lista a partir de chaves numéricas esparsas (IDs podem estar fora de ordem)
		-- Mantém os mesmos IDs e ordena apenas para exibição estável, sem afetar storages
		local keys = {}
		for k in pairs(configTasks) do
			if type(k) == 'number' then
				table.insert(keys, k)
			end
		end
		table.sort(keys, function(a, b) return a < b end)
		for _, i in ipairs(keys) do
            local cfg = configTasks[i]
            TaskSystem.list[#TaskSystem.list + 1] = {
                id = i,
                name = '' .. cfg.nameOfTheTask .. '',
                looktype = cfg.looktype,
                kills = cfg.killsRequired,
                exp = cfg.rewards.expReward,
				taskPoints = cfg.rewards.pointsReward,
            }
        end
        return true
    end,
    getCurrentTasks = function(player)
        local tasks = {}

        for _, task in ipairs(TaskSystem.list) do
            local storageValue = player:getStorageValue(TaskSystem.baseStorage + task.id)
            if (storageValue > 0 and storageValue <= task.kills + 1) then
                local playerTask = {}
                -- Deep copy the task to avoid modifying the original
                for k, v in pairs(task) do
                    playerTask[k] = v
                end
                playerTask.left = storageValue
                playerTask.done = playerTask.kills - (playerTask.left - 1)
                table.insert(tasks, playerTask)
            end
        end

        return tasks
    end,
    getPlayerTaskIds = function(player)
        local tasks = {}

        for _, task in ipairs(TaskSystem.list) do
            local storageValue = player:getStorageValue(TaskSystem.baseStorage + task.id)
            if (storageValue > 0 and storageValue <= task.kills + 1) then
                table.insert(tasks, task.id)
            end
        end

        return tasks
    end,
    getTaskNames = function(player)
        local tasks = {}

        for _, task in ipairs(TaskSystem.list) do
            table.insert(tasks, '{' .. task.name:lower() .. '}')
        end

        return table.concat(tasks, ', ')
    end,
onAction = function(player, data)
    if (data['action'] == 'info') then
        TaskSystem.sendData(player)
        TaskSystem.players[player.uid] = 1
    elseif (data['action'] == 'hide') then
        TaskSystem.players[player.uid] = nil
    elseif (data['action'] == 'start') then
        local playerTaskIds = TaskSystem.getPlayerTaskIds(player)

        -- Check if the player already has the maximum number of tasks (5)
        if (#playerTaskIds >= 3) then
            return player:sendExtendedJSONOpcode(215, {
                message = "You can't take more tasks. Max limit: 3.",
                color = 'red'
            })
        end

        for _, task in ipairs(TaskSystem.list) do
            if (task.id == data['entry']) then
                if (table.contains(playerTaskIds, task.id)) then
                    return player:sendExtendedJSONOpcode(215, {
                        message = 'You already have this task active.',
                        color = 'red'
                    })
                end

                player:setStorageValue(TaskSystem.baseStorage + task.id, task.kills + 1)
                player:sendExtendedJSONOpcode(215, {
                    message = 'Task started.',
                    color = 'green'
                })

                return TaskSystem.sendData(player)
            end
        end

            return player:sendExtendedJSONOpcode(215, {
                message = 'Unknown task.',
                color = 'red'
            })
        elseif (data['action'] == 'cancel') then
            for _, task in ipairs(TaskSystem.list) do
                if (task.id == data['entry']) then
                    local playerTaskIds = TaskSystem.getPlayerTaskIds(player)

                    if (not table.contains(playerTaskIds, task.id)) then
                        return player:sendExtendedJSONOpcode(215, {
                            message = "You don't have this task active.",
                            color = 'red'
                        })
                    end

                    player:setStorageValue(TaskSystem.baseStorage + task.id, -1)
                    player:sendExtendedJSONOpcode(215, {
                        message = 'Task aborted.',
                        color = 'green'
                    })

                    return TaskSystem.sendData(player)
                end
            end

            return player:sendExtendedJSONOpcode(215, {
                message = 'Unknown task.',
                color = 'red'
            })
        elseif (data['action'] == 'finish') then
            for _, task in ipairs(TaskSystem.list) do
                if (task.id == data['entry']) then
                    local playerTaskIds = TaskSystem.getPlayerTaskIds(player)

                    if (not table.contains(playerTaskIds, task.id)) then
                        return player:sendExtendedJSONOpcode(215, {
                            message = "You don't have this task active.",
                            color = 'red'
                        })
                    end

                    local left = player:getStorageValue(TaskSystem.baseStorage + task.id)

                    if (left > 1) then
                        return player:sendExtendedJSONOpcode(215, {
                            message = "Task isn't completed yet.",
                            color = 'red'
                        })
                    end

                    player:setStorageValue(TaskSystem.baseStorage + task.id, -1)
                    player:addExperience(task.exp)
                    --player:setStorageValue(taskPointStorage, (player:getStorageValue(taskPointStorage) + task.taskPoints))
                    player:sendExtendedJSONOpcode(215, {
                        message = 'Task finished.',
                        color = 'green'
                    })

                    return TaskSystem.sendData(player)
                end
            end

            return player:sendExtendedJSONOpcode(215, {
                message = 'Unknown task.',
                color = 'red'
            })
        end
    end,
    killForPlayer = function(player, task)
        local left = player:getStorageValue(TaskSystem.baseStorage + task.id)
        
        -- Verificar se a task ainda está ativa
        if (left <= 0 or left > task.kills + 1) then
            return false
        end

        if (left == 1) then
            if (TaskSystem.players[player.uid]) then
                player:sendExtendedJSONOpcode(215, {
                    message = 'Task finished. Use finish command to collect reward.',
                    color = 'green'
                })
            end
            -- Não resetar o storage aqui, deixar para a função finish
            return true
        end

        player:setStorageValue(TaskSystem.baseStorage + task.id, left - 1)
        
        -- Mostra mensagem no chat com o progresso
        local newLeft = left - 1
        local message = string.format("Task progress: %s (%d/%d)", task.name, task.kills - (newLeft - 1), task.kills)
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, message)

        if (TaskSystem.players[player.uid]) then
            return TaskSystem.sendData(player)
        end
        
        return true
    end,
    onKill = function(player, target)
        local targetName = target:getName():lower()

        for _, task in ipairs(TaskSystem.list) do
            if (task.name:lower() == targetName) then
                local playerTaskIds = TaskSystem.getPlayerTaskIds(player)

                if (not table.contains(playerTaskIds, task.id)) then
                    return true
                end

                local party = player:getParty()
                local tpos = target:getPosition()
                local playersToUpdate = {}

                if (TaskSystem.countForParty and party and party:getMembers()) then
                    -- Adicionar membros da party que estão na distância
                    for i, creature in pairs(party:getMembers()) do
                        local pos = creature:getPosition()
                        if (pos.z == tpos.z and pos:getDistance(tpos) <= TaskSystem.maxDist) then
                            local memberTaskIds = TaskSystem.getPlayerTaskIds(creature)
                            if (table.contains(memberTaskIds, task.id)) then
                                table.insert(playersToUpdate, creature)
                            end
                        end
                    end

                    -- Adicionar o líder da party se estiver na distância
                    local leader = party:getLeader()
                    local leaderPos = leader:getPosition()
                    if (leaderPos.z == tpos.z and leaderPos:getDistance(tpos) <= TaskSystem.maxDist) then
                        local leaderTaskIds = TaskSystem.getPlayerTaskIds(leader)
                        if (table.contains(leaderTaskIds, task.id)) then
                            table.insert(playersToUpdate, leader)
                        end
                    end
                else
                    -- Jogador solo
                    table.insert(playersToUpdate, player)
                end

                -- Atualizar as tasks para todos os jogadores elegíveis
                for _, playerToUpdate in ipairs(playersToUpdate) do
                    TaskSystem.killForPlayer(playerToUpdate, task)
                end

                return true
            end
        end
    end,
    sendData = function(player)
        local playerTasks = TaskSystem.getCurrentTasks(player)

        local response = {
            allTasks = TaskSystem.list,
            playerTasks = playerTasks
        }

        return player:sendExtendedJSONOpcode(215, response)
    end,
    sanitizePlayer = function(player)
        -- Corrige storages fora do intervalo esperado para evitar valores negativos persistirem
        for _, task in ipairs(TaskSystem.list) do
            local key = TaskSystem.baseStorage + task.id
            local v = player:getStorageValue(key)
            if v < -1 then
                player:setStorageValue(key, -1)
            elseif v > (task.kills + 1) then
                player:setStorageValue(key, task.kills + 1)
            end
        end
        return true
    end
}

local events = {}

local globalevent = GlobalEvent('Tasks')
TaskSystem.loadDatabase()

function globalevent.onStartup()
    return TaskSystem.loadDatabase()
end

table.insert(events, globalevent)

local creatureevent = CreatureEvent('TaskKill')

function creatureevent.onKill(creature, target)
    if (not creature:isPlayer() or not Monster(target)) then
        return true
    end

    TaskSystem.onKill(creature, target)

    return true
end

table.insert(events, creatureevent)

for _, event in ipairs(events) do
    event:register()
end
