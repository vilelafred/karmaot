local config = {
    level_add = 20,
    max_offers = 5,
    offers_pz = true,
    blocked_items = {2165, 2152, 2148, 2160, 2166, 2167, 2168, 2169, 2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209, 2210, 2211, 2212, 2213, 2214, 2215, 2343, 2433, 2640, 6132, 6300, 6301, 9932, 9933}
}

function onSay(player, words, param)
    if (param == 'balance') then
        local query = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
        local balance = result.getNumber(query, "auction_balance")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Your balance is " .. balance .. " gps from your market sales!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your balance is " .. balance .. " gps from your market sales!")
        return true
    end

    if(param == '') or (param == 'info') then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Available commands for this system:\n" ..
            "!offer balance - Check your market balance.\n" ..
            "!offer add,itemname,price,amount\nExample: !offer add,plate armor,500,1\n\n" ..
            "!offer buy,offer_id\nExample: !offer buy,1943\n\n" ..
            "!offer remove,offer_id\nExample: !offer remove,1943\n\n" ..
            "!offer withdraw,amount\nExample: !offer withdraw,1000.\n")
        return true
    end

    local split = param:split(",")
    if split[2] == nil then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Missing parameters. Use !offer info for more information!")
        return false
    end

    split[2] = split[2]:gsub("^%s*(.-)$", "%1")
    _QUERY_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `player` = " .. player:getGuid())

    if(split[1] == "add") then
        if(not tonumber(split[3]) or not tonumber(split[4])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use only numbers.")
            return true
        end

        if(string.len(split[3]) > 7 or string.len(split[4]) > 3) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Price or quantity is too high.")
            return true
        end

        local itemType, itemId = ItemType(split[2]), ItemType(split[2]):getId()
        if(not itemId) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Item "..split[2].." does not exist!")
            return true
        end

        if(player:getLevel() < config.level_add) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, you need level (" .. config.level_add .. ") or higher.")
            return true
        end

        if(isInArray(config.blocked_items, itemId)) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You can't add this item.")
            return true
        end

        if(player:getItemCount(itemId) < tonumber(split[4])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, you don't have this item.")
            return true
        end

        local amount, tmp_QUERY_DB = 0, _QUERY_DB
        while tmp_QUERY_DB ~= false do
            tmp_QUERY_DB = result.next(_QUERY_DB)
            amount = amount + 1
        end

        if _QUERY_DB ~= false then
            if amount >= config.max_offers then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, you've reached the limit (" .. config.max_offers .. ") of active listings.")
                return true
            end

            if(config.offers_pz and not getTilePzInfo(player:getPosition())) then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You must be in a protection zone to use this command.")
                return true
            end
        end

        if(tonumber(split[4]) < 1 or tonumber(split[3]) < 1) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Price and quantity must be greater than 0.")
            return true
        end

        local count, cost = math.floor(split[4]), math.floor(split[3])
        player:removeItem(itemId, count)
        db.query("INSERT INTO `auction_system` (`player`, `item_name`, `item_id`, `count`, `cost`, `date`) VALUES (" ..
            player:getGuid() .. ", \"" .. split[2] .. "\", " .. itemId .. ", " .. count .. ", " .. cost ..", " .. os.time() .. ")")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Success! You listed " .. count .." " .. split[2] .." for " .. cost .. " gps!")
    end

    if(split[1] == "buy") then
        _QUERY_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = ".. tonumber(split[2]))
        local player_id, seller_id, item_id, cost, item_name, count = player:getGuid(), result.getNumber(_QUERY_DB, "player"), result.getNumber(_QUERY_DB, "item_id"), result.getNumber(_QUERY_DB, "cost"), result.getString(_QUERY_DB, "item_name"), result.getNumber(_QUERY_DB, "count")

        if(not tonumber(split[2])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Only numbers are allowed.")
            return true
        end

        if(_QUERY_DB ~= false) then
            if(player:getMoney() < cost) then
                local diff = cost - player:getMoney()
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have enough money. Required: "..cost.." gps. You have: " .. player:getMoney() .. " gps. You need: "..diff.." more.")
                return true
            end

            if(player_id == seller_id) then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot buy your own item.")
                return true
            end

            if player:removeMoney(cost) then
                if isItemStackable(item_id) then
                    player:addItem(item_id, count)
                else
                    for i = 1, count do
                        player:addItem(item_id, 1)
                    end
                end
                db.query("DELETE FROM `auction_system` WHERE `id` = " .. split[2] .. ";")
                db.query("UPDATE `players` SET `auction_balance` = `auction_balance` + " .. cost .. " WHERE `id` = " .. seller_id .. ";")
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Success! You bought " .. count .. " ".. item_name .. " for " .. cost .. " gps!")
            end
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Offer ID "..split[2].." does not exist.")
        end
    end

    if(split[1] == "remove") then
        local _QUERY_DB = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = ".. tonumber(split[2]))
        local player_id, seller_id, item_id, cost, item_name, count = player:getGuid(), result.getNumber(_QUERY_DB, "player"), result.getNumber(_QUERY_DB, "item_id"), result.getNumber(_QUERY_DB, "cost"), result.getString(_QUERY_DB, "item_name"), result.getNumber(_QUERY_DB, "count")

        if(not tonumber(split[2])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Only numbers are allowed.")
            return true
        end

        if(config.offers_pz and not getTilePzInfo(player:getPosition())) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You must be in a protection zone to remove offers.")
            return true
        end

        if(_QUERY_DB ~= false) then
            if(player_id == seller_id) then
                db.query("DELETE FROM `auction_system` WHERE `id` = " .. split[2] .. ";")
                if isItemStackable(item_id) then
                    player:addItem(item_id, count)
                else
                    for i = 1, count do
                        player:addItem(item_id, 1)
                    end
                end
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Success! Offer "..split[2].." removed.\nYou received back: "..count.." "..item_name..".")
            else
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You can only remove your own offers.")
            end
            result.free(_QUERY_DB)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Offer ID "..split[2].." not found.")
        end
    end

    if(split[1] == "withdraw") then
        if(not tonumber(split[2])) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Only numbers are allowed.")
            return true
        end

        local balance_query = db.storeQuery("SELECT * FROM `players` WHERE `id` = " .. player:getGuid() .. ";")
        local balance = result.getNumber(balance_query, "auction_balance")

        if(balance < tonumber(split[2])) then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have enough balance to withdraw.")
            result.free(balance_query)
            return true
        end

        local new_balance = balance - tonumber(split[2])
        player:addMoney(tonumber(split[2]))
        db.query("UPDATE `players` SET `auction_balance` = ".. new_balance .." WHERE `id` = " .. player:getGuid() .. ";")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You withdrew " .. split[2] .. " gps from your sales. New balance: "..new_balance.." gps.")
        result.free(balance_query)
    end

    return true
end
