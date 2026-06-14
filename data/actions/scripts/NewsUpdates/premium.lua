function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemid = item:getId()
    local message = ""
    local effect = CONST_ME_MAGIC_BLUE -- Efeito padrão, você pode alterar conforme necessário
    local items = {
        [6780] = 7, -- Premium Scroll 7
        [6781] = 15, -- Premium Scroll 15
        [6782] = 30 -- Premium Scroll 30
    }

    local days = items[itemid]

    if days then
        message = "You received " .. days .. " days of premium account. Please login again!"
        doPlayerAddPremiumDays(player, days)
        player:sendTextMessage(MESSAGE_INFO_DESCR, message)
        player:getPosition():sendMagicEffect(effect)
        item:remove()
    end

    return true
end
