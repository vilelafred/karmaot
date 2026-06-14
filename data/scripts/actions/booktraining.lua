local bookId = 6155
local trainingWeapons = {
    ["!sword"] = 8248,
    ["!axe"]   = 8247,
    ["!club"]  = 8246,
    ["!bow"]   = 8245,
    ["!staff"] = 8244
}

for command, itemId in pairs(trainingWeapons) do
    local trainingTalk = TalkAction(command)

    function trainingTalk.onSay(player, words, param)
        if player:getItemCount(bookId) < 1 then
            player:sendCancelMessage("You need a Book of Training Weapon to exchange.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end

        if player:removeItem(bookId, 1) then
            local item = player:addItem(itemId, 1)
            if item then
                item:setAttribute(ITEM_ATTRIBUTE_CHARGES, 3000)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received your training weapon!")
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            else
                player:sendCancelMessage("Something went wrong while giving the item.")
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
            end
        else
            player:sendCancelMessage("Failed to remove Book of Training Weapon.")
        end

        return false
    end

    trainingTalk:separator(" ")
    trainingTalk:register()
end
