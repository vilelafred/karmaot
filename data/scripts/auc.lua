local config = {
    level_min = 20,
    max_offers = 10,
    pz_only = true,
    blocked_items = {
        2165, 2152, 2148, 2160, 2166, 2167, 2168, 2169,
        2202, 2203, 2204, 2205, 2206, 2207, 2208, 2209,
        2210, 2211, 2212, 2213, 2214, 2215, 2343, 2433,
		6132, 6300, 6301, 9932, 9933
    }
}

local offerCommand = TalkAction("!offer")

function offerCommand.onSay(player, words, param)
    local guid = player:getGuid()

    if param == "balance" then
        local resultId = db.storeQuery("SELECT `auction_balance` FROM `players` WHERE `id` = " .. guid)
        if resultId then
            local balance = result.getNumber(resultId, "auction_balance")
            result.free(resultId)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your market balance is " .. balance .. " gps.")
        end
        return false
    end

    if param == "" or param == "info" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Market Commands:\n" ..
            "!offer balance - View your market balance.\n" ..
            "!offer add, itemName, price, count\nExample: !offer add, plate armor, 500, 1\n" ..
            "!offer buy, auctionID\nExample: !offer buy, 1943\n" ..
            "!offer remove, auctionID\nExample: !offer remove, 1943\n" ..
            "!offer withdraw, amount\nExample: !offer withdraw, 1000"
        )
        return false
    end

    local t = param:split(",")
    local action = t[1] and t[1]:lower()

    -- Add Offer
    if action == "add" and t[2] and t[3] and t[4] then
        local itemName = t[2]:gsub("^%s*(.-)%s*$", "%1")
        local price = tonumber(t[3])
        local count = tonumber(t[4])
        local itemId = ItemType(itemName):getId()

        if not itemId or price < 1 or count < 1 then
            player:sendCancelMessage("Invalid item, price or count.")
            return false
        end

        if player:getLevel() < config.level_min then
            player:sendCancelMessage("You must be at least level " .. config.level_min .. " to use the market.")
            return false
        end

        if isInArray(config.blocked_items, itemId) then
            player:sendCancelMessage("This item is blocked from market.")
            return false
        end

        if config.pz_only and not getTilePzInfo(player:getPosition()) then
            player:sendCancelMessage("You must be in a protection zone to list items.")
            return false
        end

        if player:getItemCount(itemId) < count then
            player:sendCancelMessage("You don't have enough of this item.")
            return false
        end

        local offers = db.storeQuery("SELECT COUNT(*) as total FROM `auction_system` WHERE `player` = " .. guid)
        local total = result.getNumber(offers, "total")
        result.free(offers)

        if total >= config.max_offers then
            player:sendCancelMessage("You have reached the max number of active offers.")
            return false
        end

        player:removeItem(itemId, count)
        db.query(string.format("INSERT INTO `auction_system` (`player`, `item_name`, `item_id`, `count`, `cost`, `date`) VALUES (%d, '%s', %d, %d, %d, %d)",
            guid, itemName, itemId, count, price, os.time()))
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You listed " .. count .. "x " .. itemName .. " for " .. price .. " gp.")
        return false
    end

    -- Buy Offer
    if action == "buy" and t[2] then
        local offerId = tonumber(t[2])
        if not offerId then
            player:sendCancelMessage("Invalid offer ID.")
            return false
        end

        local query = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = " .. offerId)
        if not query then
            player:sendCancelMessage("Offer not found.")
            return false
        end

        local sellerId = result.getNumber(query, "player")
        local itemName = result.getString(query, "item_name")
        local itemId = result.getNumber(query, "item_id")
        local count = result.getNumber(query, "count")
        local cost = result.getNumber(query, "cost")
        result.free(query)

        if sellerId == guid then
            player:sendCancelMessage("You can't buy your own item.")
            return false
        end

        if player:getMoney() < cost then
            player:sendCancelMessage("You don't have enough money. Price: " .. cost .. " gp.")
            return false
        end

        if player:removeMoney(cost) then
            if ItemType(itemId):isStackable() then
                player:addItem(itemId, count)
            else
                for i = 1, count do
                    player:addItem(itemId, 1)
                end
            end

            db.query("DELETE FROM `auction_system` WHERE `id` = " .. offerId)
            db.query("UPDATE `players` SET `auction_balance` = `auction_balance` + " .. cost .. " WHERE `id` = " .. sellerId)

            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You bought " .. count .. "x " .. itemName .. " for " .. cost .. " gp.")
        else
            player:sendCancelMessage("Transaction failed.")
        end
        return false
    end

    -- Remove Offer
    if action == "remove" and t[2] then
        local offerId = tonumber(t[2])
        if not offerId then
            player:sendCancelMessage("Invalid offer ID.")
            return false
        end

        local query = db.storeQuery("SELECT * FROM `auction_system` WHERE `id` = " .. offerId .. " AND `player` = " .. guid)
        if not query then
            player:sendCancelMessage("Offer not found or you are not the owner.")
            return false
        end

        local itemId = result.getNumber(query, "item_id")
        local count = result.getNumber(query, "count")
        local itemName = result.getString(query, "item_name")
        result.free(query)

        -- Devolve o item
        if ItemType(itemId):isStackable() then
            player:addItem(itemId, count)
        else
            for i = 1, count do
                player:addItem(itemId, 1)
            end
        end

        db.query("DELETE FROM `auction_system` WHERE `id` = " .. offerId)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Offer removed and " .. count .. "x " .. itemName .. " returned to your inventory.")
        return false
    end

    -- Withdraw
    if action == "withdraw" and t[2] then
        local amount = tonumber(t[2])
        if not amount or amount <= 0 then
            player:sendCancelMessage("Enter a valid amount.")
            return false
        end

        local resultId = db.storeQuery("SELECT `auction_balance` FROM `players` WHERE `id` = " .. guid)
        if resultId then
            local balance = result.getNumber(resultId, "auction_balance")
            result.free(resultId)

            if balance < amount then
                player:sendCancelMessage("Insufficient balance.")
                return false
            end

            db.query("UPDATE `players` SET `auction_balance` = `auction_balance` - " .. amount .. " WHERE `id` = " .. guid)
            player:addMoney(amount)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You withdrew " .. amount .. " gps from your market balance.")
        end
        return false
    end

    return false
end

offerCommand:separator(" ")
offerCommand:register()
