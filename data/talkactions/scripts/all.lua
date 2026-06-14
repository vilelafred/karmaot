-- <talkaction words="/addItemAllPjs" separator=" " script="add_item_allpjs.lua" />
-- /addItemAllPjs itemId, count

local function getPlayerDiffIps()
    local players = Game.getPlayers()
    local ipList = {}
    for index, player in pairs(players) do
        if not ipList[player:getIp()] then
            ipList[player:getIp()] = player
        end
    end
    return ipList
end

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    elseif player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end
    local split = param:split(",")
    local itemId = tonumber(split[1]) or 0
    local count = tonumber(split[2]) or 1
    local itemType = ItemType(itemId)
    if itemType:getId() == 0 then
        itemType = ItemType(tostring(split[1]))
        if itemType:getId() == 0 then
            player:sendCancelMessage("ID or Name of the wrong item.")
            return false
        end
    end
    count = math.floor(count)
    count = math.max(1, count)
    if itemType:isStackable() then
        count = math.min(100, count)
    else
        count = math.min(1, count)
    end
    for index, pla in pairs(getPlayerDiffIps()) do
        if pla:getFreeCapacity() >= itemType:getWeight(count) then
            pla:addItem(itemType:getId(), count)
        end
    end
    Game.broadcastMessage(string.format("All the players have received %u %s.", count, itemType:getName()))
    return false
end