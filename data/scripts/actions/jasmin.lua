local JASMIN_COIN_ID = 8238
local CRYSTAL_COIN_ID = 2160
local CRYSTAL_COIN_COUNT = 100

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == JASMIN_COIN_ID then
        local amount = item:getCount() -- quantidade da stack
        local totalCrystalCoins = CRYSTAL_COIN_COUNT * amount

        item:remove()
        player:addItem(CRYSTAL_COIN_ID, totalCrystalCoins)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You exchanged " .. amount .. " Jasmin Coin(s) for " .. totalCrystalCoins .. " crystal coins.")
        return true
    end
    return false
end

action:id(JASMIN_COIN_ID)
action:register()
