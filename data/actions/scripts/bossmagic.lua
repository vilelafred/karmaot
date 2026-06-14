local config = {
    storage = 16777,
    exstorage = 11777,
    destination = {x = 33317, y = 32055, z = 8},
    days = {
        ["Monday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Tuesday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Wednesday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Thursday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Friday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Saturday"] = {
            {itemid = 6846, count = {1}}
        },
        ["Sunday"] = {
            {itemid = 6846, count = {1}}
        }
    }
}

function onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
    local player = Player(cid)
    local x = config.days[os.date("%A")]
    
    if player:getStorageValue(config.storage) == tonumber(os.date("%w")) and player:getStorageValue(config.exstorage) > os.time() then
        return player:sendCancelMessage("The chest is empty, come back tomorrow for a daily magic sulphur.")
    end
    
    local c = math.random(#x)
    local info, count = ItemType(x[c].itemid), x[c].count[2] and math.random(x[c].count[1], x[c].count[2]) or x[c].count[1]
    local text
    
    if count > 1 then
        text = count .. " " .. info:getPluralName()
    else
        text = info:getArticle() .. " " .. info:getName()
    end
    
    local itemx = Game.createItem(x[c].itemid, count)
    
    if player:addItemEx(itemx) ~= RETURNVALUE_NOERROR then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        text = "You have found a reward weighing " .. itemx:getWeight() .. " oz. It is too heavy or you have not enough space."
    else
        text = "You have received " .. text .. "."
        player:setStorageValue(config.storage, tonumber(os.date("%w")))
        player:setStorageValue(config.exstorage, os.time() + 20*60*60)
        
        -- Teleportar o jogador para a posição especificada
        player:teleportTo(config.destination)
    end
    
    player:sendTextMessage(MESSAGE_INFO_DESCR, text)
    return true
end
