local MYSTIC_SHARD_ID = 8176
local MYSTIC_ORE_ID = 5937
local SHARDS_PER_ORE = 100

local GOLD_ID = 2148
local PLATINUM_ID = 2152
local CRYSTAL_ID = 2160
local JASMINE_ID = 8238

local CONVERTER_ID = 6606 -- item que realiza as conversões

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local converted = false

    -- === MYSTIC SHARD → MYSTIC ORE ===
    local shardCount = 0
    local containersToCheck = {player:getSlotItem(CONST_SLOT_BACKPACK)}

    while #containersToCheck > 0 do
        local container = table.remove(containersToCheck, 1)
        if container and container:isContainer() then
            for i = 0, container:getSize() - 1 do
                local slotItem = container:getItem(i)
                if slotItem then
                    if slotItem:getId() == MYSTIC_SHARD_ID then
                        shardCount = shardCount + slotItem:getCount()
                    elseif slotItem:isContainer() then
                        table.insert(containersToCheck, slotItem)
                    end
                end
            end
        end
    end

    local oresToAdd = math.floor(shardCount / SHARDS_PER_ORE)
    if oresToAdd > 0 then
        local shardsToRemove = oresToAdd * SHARDS_PER_ORE
        local removed = player:removeItem(MYSTIC_SHARD_ID, shardsToRemove, -1, true)
        if removed then
            player:addItem(MYSTIC_ORE_ID, oresToAdd)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You converted " .. shardsToRemove .. " Mystic Shards into " .. oresToAdd .. " Mystic Ores.")
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            converted = true
        else
            player:sendCancelMessage("Couldn't remove the Mystic Shards.")
        end
    end

    -- === CRYSTAL → JASMINE === (Prioridade mais alta)
    local crystalCount = player:getItemCount(CRYSTAL_ID)
    if crystalCount >= 100 then
        local toConvert = math.floor(crystalCount / 100)
        local removed = player:removeItem(CRYSTAL_ID, toConvert * 100)
        if removed then
            player:addItem(JASMINE_ID, toConvert)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You converted " .. (toConvert * 100) .. " crystal coins into " .. toConvert .. " jasmin coins.")
            player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            converted = true
        end
    end

    -- === PLATINUM → CRYSTAL === (Só se não tiver crystal suficiente para jasmine)
    if not converted then
        local platinumCount = player:getItemCount(PLATINUM_ID)
        if platinumCount >= 100 then
            local toConvert = math.floor(platinumCount / 100)
            local removed = player:removeItem(PLATINUM_ID, toConvert * 100)
            if removed then
                player:addItem(CRYSTAL_ID, toConvert)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You converted " .. (toConvert * 100) .. " platinum coins into " .. toConvert .. " crystal coins.")
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
                converted = true
            end
        end
    end

    -- === GOLD → PLATINUM === (Só se não tiver platinum suficiente para crystal)
    if not converted then
        local goldCount = player:getItemCount(GOLD_ID)
        if goldCount >= 100 then
            local toConvert = math.floor(goldCount / 100)
            local removed = player:removeItem(GOLD_ID, toConvert * 100)
            if removed then
                player:addItem(PLATINUM_ID, toConvert)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You converted " .. (toConvert * 100) .. " gold coins into " .. toConvert .. " platinum coins.")
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
                converted = true
            end
        end
    end

    if not converted then
        player:sendCancelMessage("You need at least 100 Mystic Shards or 100 coins of a type to convert.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end

    return true
end

action:id(CONVERTER_ID)
action:register()
