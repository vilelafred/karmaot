local surpriseBagId = 6801

-- Lista de BACKPACKS como recompensas
local rewards = {
    6769, -- kitty backpack (Vol:40)
    6767, -- phantom death backpack (Vol:40)
    6766, -- winged backpack (Vol:24)
    6765, -- festive backpack (Vol:22)
    6762, -- nocturnal backpack (Vol:40)
    6755, -- buggy backpack (Vol:20)
    6754, -- deepling backpack (Vol:20)
    6750, -- euphoric expedition backpack (Vol:40)
    6752, -- energy minotaur backpack (Vol:40)
    6757, -- crystal backpack (Vol:40)
    6758, -- nature's backpack (Vol:40)
    6761, -- odyssey backpack (Vol:40)
    6763, -- energetic backpack (Vol:24)
    6768, -- smoky backpack (Vol:24)
    6770, -- death essence backpack (Vol:28)
    6771, -- devil draptor backpack (Vol:40)
    6772, -- beholder backpack (Vol:40)
    6774, -- cursed backpack (Vol:20)
    6775  -- enchanted woods backpack (Vol:40)
}

local function rollReward()
    -- sorteia um ID da lista
    local index = math.random(1, #rewards)
    return rewards[index]
end

local bagAction = Action()

function bagAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local rewardId = rollReward()
    local pos = player:getPosition()
    item:remove(1)

    local rewardItem = ItemType(rewardId)
    player:addItem(rewardId, 1)
    player:say("You received: " .. rewardItem:getName() .. "!", TALKTYPE_MONSTER_SAY)
    pos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)

    return true
end

bagAction:id(surpriseBagId)
bagAction:register()
