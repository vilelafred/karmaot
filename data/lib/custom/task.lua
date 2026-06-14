messageType = MESSAGE_STATUS_CONSOLE_BLUE

tasks = { -- You can add as many tasks as you want
    [1] = {
        name = "Rats", -- Name of Task
        minlevel = 1,
        maxlevel = 15,
        monsters = { -- You can add as many monsters as you want
            "Rat",
            "Cave Rat",
        },
        toKill = 25, -- How many monsters the player needs to kill
        rewards = { -- You can add as many rewards as you want
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 5,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [2] = {
        name = "Trolls",
        minlevel = 8,
        maxlevel = 25,
        monsters = {
            "Troll",
        },
        toKill = 25,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 7,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [3] = {
        name = "Rotworms",
        minlevel = 8,
        maxlevel = 25,
        monsters = {
            "Rotworm",
        },
        toKill = 50,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 12,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [4] = {
        name = "Skeletons",
        minlevel = 8,
        maxlevel = 20,
        monsters = {
            "Skeleton",
        },
        toKill = 25,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 8,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [5] = {
        name = "Cyclops",
        minlevel = 15,
        maxlevel = 35,
        monsters = {
            "Cyclops",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 25,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [6] = {
        name = "Amazons",
        minlevel = 15,
        maxlevel = 35,
        monsters = {
            "Amazon",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 20,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [7] = {
        name = "Valkyries",
        minlevel = 15,
        maxlevel = 35,
        monsters = {
            "Valkyrie",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 30,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
            [3] = {
                type = "storage",
                storageId = 5001,
                storageValue = 1,
            },
        },
    },
    [8] = {
        name = "Scarabs",
        minlevel = 15,
        maxlevel = 35,
        monsters = {
            "Scarab",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 20,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [9] = {
        name = "Dragons",
        minlevel = 30,
        maxlevel = 50,
        monsters = {
            "Dragon",
        },
        toKill = 50,
        rewards = {
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 70,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [10] = {
        name = "Dragon Lords",
        minlevel = 45,
        maxlevel = 100,
        monsters = {
            "Dragon Lord",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 3,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [11] = {
        name = "Hydras",
        minlevel = 45,
        maxlevel = 100,
        monsters = {
            "Hydra",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 3,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [12] = {
        name = "Heros",
        minlevel = 40,
        maxlevel = 100,
        monsters = {
            "Hero",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 3,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [13] = {
        name = "Warlocks",
        minlevel = 50,
        maxlevel = 130,
        monsters = {
            "Warlock",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 20,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [14] = {
        name = "Necromancers",
        minlevel = 40,
        maxlevel = 80,
        monsters = {
            "Necromancer",
        },
        toKill = 300,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 3,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [15] = {
        name = "Behemoths",
        minlevel = 50,
        maxlevel = 130,
        monsters = {
            "Behemoth",
        },
        toKill = 100,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 10,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
    [16] = {
        name = "Demons",
        minlevel = 80,
        maxlevel = 160,
        monsters = {
            "Demon",
        },
        toKill = 666,
        rewards = {
            [1] = {
                type = "item",
                name = "crystal coin",
                itemid = 2160,
                count = 100,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
	    [17] = {
        name = "Orcs", -- Name of Task
        minlevel = 8,
        maxlevel = 20,
        monsters = { -- You can add as many monsters as you want
            "Orc",
            "Orc Spearman",
			"Orc Warrior",
        },
        toKill = 50, -- How many monsters the player needs to kill
        rewards = { -- You can add as many rewards as you want
            [1] = {
                type = "item",
                name = "platinum coin",
                itemid = 2152,
                count = 10,
            },
            [2] = {
                type = "exp",
                experience = 0,
            },
        },
    },
}

tasks.__index = tasks

function tasks:getOnTaskStorage(task)
    return tonumber(6520000 + (task * 10))
end

function tasks:getMonstersStorage(task)
    return tonumber(6520001 + (task * 10))
end

function tasks:getCompletedStorage(task)
    return tonumber(6520002 + (task * 10))
end

function tasks:getFinishedStorage(task)
    return tonumber(6520003 + (task * 10))
end

function tasks:getCanceledStorage(task)
    return tonumber(6520004 + (task * 10))
end

-- Check if values are between a given value
function tasks:isAvailable(value, min, max)
    return (value >= min and value <= max)
end

-- Check available tasks and delete inactive tasks
function tasks:updateTasks(player)
    local availableTasks = {}
    for i = 1, #tasks do
        if player:getStorageValue(tasks:getFinishedStorage(i)) ~= 1 then
            if player:getStorageValue(tasks:getCanceledStorage(i)) ~= 1 then
                if tasks:isAvailable(player:getLevel(), tasks[i].minlevel, tasks[i].maxlevel) then
                    table.insert(availableTasks, i)
                    table.insert(availableTasks, ",")
                end
            end
        end
    end

    if #availableTasks > 0 then
        tasks:startTask(player, availableTasks)
    end
    tasks:dropTask(player)
end


-- Modifying the startTask function to include only item reward information
function tasks:startTask(player, taskTable)
    local t = string.split(table.concat(taskTable), ",")
    
    -- Sending a message to the player about the automatic task system
    player:sendTextMessage(messageType, "(Automatic Task System)")
    
    -- Iterating through the tasks in the table
    for i, x in pairs(t) do
        local task = tonumber(x)
        
        -- Creating a message string that includes information about the task
        local taskMessage = string.format("Task Available: %s - Kill: %dx %s", 
                                          tasks[task].name, tasks[task].toKill, tasks:getMonsters(task))
        
        -- Adding item reward details to the message
        for _, reward in pairs(tasks[task].rewards) do
            if reward.type == "item" then
                taskMessage = taskMessage .. string.format(" - (Reward: %dx %s)", reward.count, reward.name)
            end
        end
        
        -- Sending the message to the player
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, taskMessage)
        
        -- Checking if the player already has this task
        if not tasks:hasTaskAlready(player, task) then
            -- If not, setting the task for the player with an initial count of 1
            tasks:setTask(player, task, 1)
        end
    end
end


--Start task
function tasks:setTask(player, task, set)
    if player:setStorageValue(tasks:getOnTaskStorage(task), set) then
        if player:setStorageValue(tasks:getMonstersStorage(task), tasks[task].toKill) then
            return true
        end
    end
    return false
end

--Check if player already have this task
function tasks:hasTaskAlready(player, task)
        if player:getStorageValue(tasks:getOnTaskStorage(task)) == 1 then
            return true
        end
    return false
end

--Drop outdated tasks (because of level up/down)
function tasks:dropTask(player)
    for i = 1, #tasks do
        if player:getStorageValue(tasks:getFinishedStorage(i)) ~= 1 and player:getStorageValue(tasks:getCanceledStorage(i)) ~= 1 then
            if not (tasks:isAvailable(player:getLevel(), tasks[i].minlevel, tasks[i].maxlevel)) then
                if tasks:hasTaskAlready(player, i) then
                    player:sendTextMessage(messageType, "Task Automatic canceled: (Your level is to high/low).")
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "Task Name: ".. tasks[i].name .."")
                    tasks:setCanceled(player, i, 1)
                end
            end
        end
    end
end

-- Modified getMonsters function:
function tasks:getMonsters(task)
    local taskMonsters = {}
    local monsters = ""
    for i = 1, #tasks[task].monsters do
        table.insert(taskMonsters, tasks[task].monsters[i])
        table.insert(taskMonsters, ", ")
    end

    if #taskMonsters > 0 then
        monsters = table.concat(taskMonsters)
        monsters = monsters:sub(1, -3)
    end

    return monsters
end


-- Set task as completed
function tasks:setCompleted(player, task, set)
    if player:setStorageValue(tasks:getCompletedStorage(task), set) then
        if task == 0 then
            return true
        end
        return true
    end
    return false
end

-- Get completed tasks from player
function tasks:getCompleted(player, task)
    return player:getStorageValue(tasks:getCompletedStorage(task))
end

-- Check how many monsters are left to kill
function tasks:getMonstersLeft(player, task)
    return player:getStorageValue(tasks:getMonstersStorage(task))
end

-- Checks if the player is currently doing a task
-- And returns the task the player is doing
function tasks:onTask(player)
    for i = 1, #tasks do
        if player:getStorageValue(tasks:getOnTaskStorage(i)) == 1 then
            return i
        end
    end
    return 0
end

-- Set canceled task
function tasks:setCanceled(player, task, set)
    if player:setStorageValue(tasks:getCanceledStorage(task), set) then
        player:setStorageValue(tasks:getOnTaskStorage(task), 0)
        player:setStorageValue(tasks:getMonstersStorage(task), 0)
        player:setStorageValue(tasks:getCompletedStorage(task), 0)
        player:setStorageValue(tasks:getFinishedStorage(task), 0)
        return true
    end
    return false
end

-- Set task as finished
function tasks:setFinished(player, task, set)
    if player:setStorageValue(tasks:getFinishedStorage(task), set) then
        return true
    end
    return false
end

-- Checks if the player has finished a task
-- And returns the task that is finished
function tasks:getFinished(player)
    for i = 1, #tasks do
        if player:getStorageValue(tasks:getFinishedStorage(i)) == 1 then
            return i
        end
    end
    return 0
end

-- Modified getTasksFromPlayer function:
function tasks:getTasksFromPlayer(player)
    local allPlayerTasks = {}
    for i = 1, #tasks do
        if player:getStorageValue(tasks:getOnTaskStorage(i)) == 1 and player:getStorageValue(tasks:getFinishedStorage(i)) ~= 1 then
            table.insert(allPlayerTasks, i)
            table.insert(allPlayerTasks, ",")
        end
    end

    if #allPlayerTasks > 0 then
        return allPlayerTasks
    end
end

-- Check if killing creature is a task monster
function tasks:killedCreatureIsTaskMonster(player, target)
    local allTasks = tasks:getTasksFromPlayer(player)
    local playerTasks = string.split(table.concat(allTasks), ",")

    for i,x in pairs(playerTasks) do
        local task = tonumber(x)
        for i = 1, #tasks[task].monsters do
            if string.lower(target:getName()) == string.lower(tasks[task].monsters[i]) then
                return true, task
            end
        end
    end
    return false
end

-- Checks if the monster killed was a task monster
function tasks:onKill(player, target)
    isTaskCreature, currentTask = tasks:killedCreatureIsTaskMonster(player, target)

        if isTaskCreature then
            if tasks:getMonstersLeft(player, currentTask) < 1 then
                return false
            end

            player:setStorageValue(tasks:getMonstersStorage(currentTask), tasks:getMonstersLeft(player, currentTask) - 1)
            if tasks:getMonstersLeft(player, currentTask) == 0 then
                if tasks:setCompleted(player, currentTask, 1) then
                    player:sendTextMessage(messageType, "You have completed your task.")
                    tasks:rewardPlayer(player, currentTask)
                    return true
                end
            end
			player:sendTextMessage(messageType, "You killed " .. tasks[currentTask].toKill - tasks:getMonstersLeft(player, currentTask) .. " of " .. tasks[currentTask].toKill .. " " .. string.lower(target:getName()) .. ".")
            --player:say("You killed " .. tasks[currentTask].toKill - tasks:getMonstersLeft(player, currentTask) .. " of " .. tasks[currentTask].toKill .. " " .. string.lower(target:getName()) .. ".", TALKTYPE_MONSTER_SAY)
            return true
    end
    return false
end

-- Reward player after finishing task
function tasks:rewardPlayer(player, t)
    for i = 1, #tasks[t].rewards do
        if tasks[t].rewards[i].type == "item" then
            player:sendTextMessage(messageType, string.format("You received %dx %s(s).", tasks[t].rewards[i].count, tasks[t].rewards[i].name))
            player:addItem(tasks[t].rewards[i].itemid, tasks[t].rewards[i].count)
        end
        if tasks[t].rewards[i].type == "exp" then
            --player:sendTextMessage(messageType, string.format("You received %dx experience.", tasks[t].rewards[i].experience))
            player:addExperience(tasks[t].rewards[i].experience, false)
        end
        if tasks[t].rewards[i].type == "storage" then
            player:sendTextMessage(messageType, string.format("You received a storage reward.", tasks[t].rewards[i].experience))
            player:setStorageValue(tasks[t].rewards[i].storageId, tasks[t].rewards[i].storageValue)
        end
    end

    tasks:setTask(player, t, 0)
    tasks:setCompleted(player, t, 0)
    tasks:setFinished(player, t, 1)
    return true
end

-- Toggle true/false at the top of this lua file
-- Resets the tasks for the provided player
function tasks:reset(player, task)
    if reset then
        player:setStorageValue(tasks:getOnTaskStorage(task), 0)
        player:setStorageValue(tasks:getMonstersStorage(task), 0)
        player:setStorageValue(tasks:getCompletedStorage(task), 0)
        player:setStorageValue(tasks:getFinishedStorage(task), 0)
        player:setStorageValue(tasks:getCanceledStorage(task), 0)
    end
end