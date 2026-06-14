local dailyReward = Action()

local DAILY_STORAGE = 556621
local DAILY_REWARD_TITLE = "Daily Reward"
local DAILY_REWARD_MSG = "Choose your reward of the day. Only 1 per day!"

local rewards = {
    -- {itemName, itemID, count, rarity}
    {"Mana Potion", 6147, 100, 1},
    {"Health Potion", 6146, 100, 1},
    {"Brown Mushroom", 2789, 100, 1},
    {"Sudden Death Rune", 2268, 100, 2},
    {"Ultimate Healing Rune", 6675, 100, 2},
    {"Casino Ticket", 6692, 1, 3},
    {"Magic Sulphur", 6846, 1, 3}
}

local function getDailyOptions()
    local options = {}
    local attempts = 0
    while #options < 3 and attempts < 100 do
        local r = rewards[math.random(#rewards)]
        local chance = 100
        if r[4] == 2 then chance = 60 end
        if r[4] == 3 then chance = 20 end
        if math.random(100) <= chance then
            local exists = false
            for _, v in ipairs(options) do
                if v[2] == r[2] then exists = true break end
            end
            if not exists then table.insert(options, r) end
        end
        attempts = attempts + 1
    end
    return options
end

function dailyReward.onUse(player, item, fromPos, itemEx, toPos, isHotkey)
    if player:getStorageValue(DAILY_STORAGE) == os.date("%Y%m%d") then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already claimed your reward today.")
        return true
    end

    local choices = getDailyOptions()
    if #choices == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No reward today, try again tomorrow.")
        return true
    end

    local window = ModalWindow(5566, DAILY_REWARD_TITLE, DAILY_REWARD_MSG)
    for i, v in ipairs(choices) do
        window:addChoice(i, v[1] .. " x" .. v[3])
    end
    window:addButton(1, "Receive")
    window:addButton(2, "Cancel")
    window:setDefaultEnterButton(1)
    window:setDefaultEscapeButton(2)

    -- Salvar recompensas em storage temporário
    local saveData = {}
    for _, v in ipairs(choices) do
        table.insert(saveData, v[2])
        table.insert(saveData, v[3])
    end
    player:setStorageValue(DAILY_STORAGE + 1, table.concat(saveData, ",")) -- usar DAILY_STORAGE + 1 como temp

    window:sendToPlayer(player)
    return true
end

dailyReward:id(7730) -- Item que abre o reward
dailyReward:register()
