local ferumbrasDummy = Action()

-- ID do Ferumbras Dummy
local dummyId = 8241
-- ID do Ferumbras Dummy Kit
local dummyKitId = 3909

ferumbrasDummy:id(dummyId)

function ferumbrasDummy.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    item:transform(dummyKitId)
    item:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "You packed the Ferumbras Dummy into a kit.")
    return true
end

ferumbrasDummy:register()
