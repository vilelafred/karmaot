local createTP = TalkAction("/tp")

function string:split(sep)
    local result = {}
    for match in (self .. sep):gmatch("(.-)" .. sep) do
        table.insert(result, match)
    end
    return result
end

function string:trim()
    return self:match("^%s*(.-)%s*$")
end

local function getNextPosition(position, direction)
    local nextPos = Position(position)
    if direction == DIRECTION_NORTH then
        nextPos.y = nextPos.y - 1
    elseif direction == DIRECTION_EAST then
        nextPos.x = nextPos.x + 1
    elseif direction == DIRECTION_SOUTH then
        nextPos.y = nextPos.y + 1
    elseif direction == DIRECTION_WEST then
        nextPos.x = nextPos.x - 1
    end
    return nextPos
end

function createTP.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    if param:trim() == "" then
        player:sendCancelMessage("Command param required.")
        return false
    end

    local params = param:split(',')
    if #params == 3 then
        local x = tonumber(params[1]:trim())
        local y = tonumber(params[2]:trim())
        local z = tonumber(params[3]:trim())
        
        if x and y and z then
            local playerPos = player:getPosition()
            local directionPos = getNextPosition(playerPos, player:getDirection())
            local tp = Game.createItem(1387, 1, directionPos)
            if tp then
                tp:setDestination(Position(x, y, z))
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Teleport created to position (" .. x .. ", " .. y .. ", " .. z .. ").")
            else
                player:sendCancelMessage("Failed to create teleport.")
            end
        else
            player:sendCancelMessage("Invalid coordinates. Use: /tp 2993, 3113, 7")
        end
    else
        player:sendCancelMessage("Command example: /tp 2993, 3113, 7")
    end
    return false
end

createTP:separator(" ")
createTP:register()