--𝓜𝓲𝓵𝓱𝓲𝓸𝓻𝓮 𝓑𝓣
local config = {
    seconds = 3600, -- 1 hour
    eventInterval = 1000, -- 1 second
    checkIP = true,
    checkAccount = true,
    allowMCs = 3,
    storageKey = 73155,
    rewards = {
        { itemId = 5823, count = 1 } -- apenas este item permanece
    }
}

local onlineTimeRewards = GlobalEvent("onlineTimeRewards")

function onlineTimeRewards.onThink(interval)
    local duplicateIps = {}
    local duplicateAccounts = {}
    for _, player in pairs(Game.getPlayers()) do repeat
        local ip = player:getIp()
        if config.checkIP and ip == 0 or (duplicateIps[ip] or 0) >= config.allowMCs then
            break
        end
        duplicateIps[ip] = (duplicateIps[ip] or 0) + 1
        local accountId = player:getAccountId()
        if config.checkAccount and (duplicateAccounts[accountId] or 0) >= config.allowMCs then
            break
        end
        duplicateAccounts[accountId] = (duplicateAccounts[accountId] or 0) + 1
        local seconds = math.max(player.storage[config.storageKey] or 0, 0) + math.ceil(interval/1000)
        if seconds >= config.seconds then
            player.storage[config.storageKey] = 0
            local rewards = {}
            for _, reward in pairs(config.rewards) do
                local item = player:addItem(reward.itemId, reward.count)
                if item then
                    rewards[#rewards + 1] = string.format('%s x%d', item:getName(), reward.count)
                end
            end
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received the following reward(s): " .. table.concat(rewards, ', '))
            break
        end
        player.storage[config.storageKey] = seconds
    until true end
    return true
end

onlineTimeRewards:interval(config.eventInterval)
onlineTimeRewards:register()
