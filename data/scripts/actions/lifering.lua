local LIFE_CRYSTAL_ID = 2177
local LIFE_RING_ID = 2168

local lifeCrystal = Action()

function lifeCrystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == LIFE_CRYSTAL_ID then
        item:remove(1)
        player:addItem(LIFE_RING_ID, 1)
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You transformed the Life Crystal into a Life Ring.")
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        return true
    end
    return false
end

lifeCrystal:id(LIFE_CRYSTAL_ID)
lifeCrystal:register()
