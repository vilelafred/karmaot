local surpriseBagId = 6610

local rewards = {
    6167, -- karma hat
    6225, -- karma axe
    6118, -- karma sword
    5791, -- karma crossbow
    6128, -- karma shield
    6196, -- karma staff
    6176, -- karma legs
    7630, -- karma spellbook
    5818, -- karma cape
    6161, -- karma amulet	
    6221, -- karma hammer
    6174, -- karma bow
    6491, -- karma ranger armor
    6514, -- karma ranger shield
    6127  -- karma armor
}

local function rollReward()
    -- Sorteia direto pelo tamanho da lista
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
