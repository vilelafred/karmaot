local MYSTIC_SHARD_ID = 8176
local MYSTIC_ORE_ID = 5937
local REQUIRED_COUNT = 100

local shardAction = Action()

function shardAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid ~= MYSTIC_SHARD_ID then
        return false
    end

    if item.type >= REQUIRED_COUNT then
        item:remove(REQUIRED_COUNT)
        player:addItem(MYSTIC_ORE_ID, 1)
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You compressed 100 Mystic Shards into 1 Mystic Ore.")
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    else
        player:sendCancelMessage("You need at least 100 Mystic Shards to create a Mystic Ore.")
        player:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
    end

    return true
end

shardAction:id(MYSTIC_SHARD_ID)
shardAction:register()
