local config = {
    storage = 45395,
    exstorage = 40823,
    days = {
        ["Monday"] = {
            -- 5% chance Casino Ticket, 10% Magic Sulphur, senão rune/potion
            rare = {{itemid = 2281, count = {1, 10}, chance = 1}}, -- Casino Ticket
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}}, -- Mystic Ore
            common = {
                {itemid = 6147, count = {50, 100}}, -- Mana Potion
                {itemid = 2274, count = {50, 100}}, -- Avalanche Rune
                {itemid = 2261, count = {50, 100}} -- Destroy Field Rune
            }
        },
        ["Tuesday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 6146, count = {50, 100}}, -- Health Potion
                {itemid = 6675, count = {50, 100}}, -- UH
                {itemid = 2268, count = {50, 100}} -- SD
            }
        },
        ["Wednesday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 2271, count = {50, 100}}, -- Energy Bomb Rune
                {itemid = 2274, count = {50, 100}}, -- Avalanche
                {itemid = 2313, count = {50, 100}} -- Explosion Rune
            }
        },
        ["Thursday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 2311, count = {50, 100}}, -- GFB
                {itemid = 2286, count = {50, 100}}, -- Icicle Rune
                {itemid = 2278, count = {50, 100}} -- Fire Bomb
            }
        },
        ["Friday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 2293, count = {50, 100}}, -- Soulfire Rune
                {itemid = 2789, count = {10, 100}} -- Brown Mushroom
            }
        },
        ["Saturday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 2273, count = {50, 100}}, -- UH
                {itemid = 2313, count = {50, 100}}, -- Explosion
                {itemid = 2274, count = {50, 100}} -- Avalanche
            }
        },
        ["Sunday"] = {
            rare = {{itemid = 6692, count = {1, 10}, chance = 1}},
            uncommon = {{itemid = 5937, count = {1, 10}, chance = 10}},
            common = {
                {itemid = 2268, count = {50, 100}}, -- SD
                {itemid = 2311, count = {50, 100}}, -- GFB
                {itemid = 2261, count = {50, 100}} -- Destroy Field
            }
        }
    }
}

function getRandomReward(list)
    -- Raro?
    for _, item in ipairs(list.rare) do
        if math.random(100) <= item.chance then
            return item
        end
    end
    -- Incomum?
    for _, item in ipairs(list.uncommon) do
        if math.random(100) <= item.chance then
            return item
        end
    end
    -- Comum
    return list.common[math.random(#list.common)]
end

function onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
    local player = Player(cid)
    local today = os.date("%A")
    local rewardPool = config.days[today]
    if not rewardPool then
        return player:sendCancelMessage("No rewards available today.")
    end

    if player:getStorageValue(config.storage) == tonumber(os.date("%w")) and player:getStorageValue(config.exstorage) > os.time() then
        return player:sendCancelMessage("The chest is empty, come back tomorrow for a new reward.")
    end

    local reward = getRandomReward(rewardPool)
    local info = ItemType(reward.itemid)
    local count = reward.count[2] and math.random(reward.count[1], reward.count[2]) or reward.count[1]

    local text = count > 1 and count .. " " .. info:getPluralName() or info:getArticle() .. " " .. info:getName()
    local itemx = Game.createItem(reward.itemid, count)
    if player:addItemEx(itemx) ~= RETURNVALUE_NOERROR then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        text = "You have found a reward weighing " .. itemx:getWeight() .. " oz. It is too heavy or you have not enough space."
    else
        text = "You have received " .. text .. "."
        player:setStorageValue(config.storage, tonumber(os.date("%w")))
        player:setStorageValue(config.exstorage, os.time() + 24 * 60 * 60)
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, text)
    return true
end
