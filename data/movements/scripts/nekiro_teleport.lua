local config = {
    bosses = {
        [1001] = {pos = Position(33217, 31427, 12), value = 1, text = "Entering The Crystal Caves"},
        [1002] = {pos = Position(33142, 31299, 10), value = 2, text = "Entering The Blood Halls"}, 
        [1003] = {pos = Position(33065, 31432, 10), value = 3, text = "Entering The Vats"},
        [1004] = {pos = Position(33167, 31462, 15), value = 4, text = "Entering The Arcanum"},
        [1005] = {pos = Position(33314, 31469, 12), value = 5, text = "Entering The Hive"},
        [1006] = {pos = Position(33258, 31326, 11), value = 6, text = "Entering The Shadow Nexus"}
    },
    mainroom = {
        [2001] = {pos = Position(33217, 31427, 12), value = 1, text = "Entering The Crystal Caves"},
        [2002] = {pos = Position(33142, 31299, 10), value = 2, text = "Entering The Blood Halls"},
        [2003] = {pos = Position(33397, 31448, 12), value = 3, text = "Entering The Vats"},
        [2004] = {pos = Position(33167, 31462, 15), value = 4, text = "Entering The Arcanum"},
        [2005] = {pos = Position(33314, 31469, 12), value = 5, text = "Entering The Hive"}
    },
    portals = {
        [3000] = {pos = Position(33283, 31495, 14), text = "Escaping back to the Retreat!"},
        [3001] = {pos = Position(33248, 31340, 10), text = "Entering The Ward of Ushuriel"},
        [3002] = {pos = Position(33255, 31315, 12), text = "Entering The Undersea Kingdom"},
        [3003] = {pos = Position(33214, 31337, 10), text = "Entering The Ward of Zugurosh"},
        [3004] = {pos = Position(33172, 31275, 10), text = "Entering The Foundry"},
        [3005] = {pos = Position(33192, 31373, 10), text = "Entering The Ward of Madareth"}, 
        [3006] = {pos = Position(33075, 31362, 10), text = "Entering The Battlefield"}, 
        [3007] = {pos = Position(33252, 31378, 10), text = "Entering The Ward of The Demon Twins"},
        [3008] = {pos = Position(33241, 31219, 10), text = "Entering The Soul Wells"},
        [3009] = {pos = Position(33282, 31368, 10), text = "Entering The Ward of Annihilon"},
        [3010] = {pos = Position(33252, 31378, 10), text = "Entering The Ward of Hellgorak"},
        [3011] = {pos = Position(32318, 32250, 9), text = "Entering The Reward Room"}
    },
    storage = 56123
}

function onStepIn(cid, item, position, fromPosition)
    local player = Player(cid)
    if not player then
        return false
    end

    local aid = item:getActionId()
    
    if config.bosses[aid] then
        local t = config.bosses[aid]
        if player:getStorageValue(config.storage) < t.value then
            player:setStorageValue(config.storage, t.value)
        end
        player:teleportTo(t.pos)
        t.pos:sendMagicEffect(CONST_ME_TELEPORT)
        player:say(t.text, TALKTYPE_MONSTER_SAY)
        return true

    elseif config.mainroom[aid] then
        local t = config.mainroom[aid]
        if player:getStorageValue(config.storage) >= t.value then
            player:teleportTo(t.pos)
            t.pos:sendMagicEffect(CONST_ME_TELEPORT)
            player:say(t.text, TALKTYPE_MONSTER_SAY)
        else
            player:teleportTo(fromPosition)
            fromPosition:sendMagicEffect(CONST_ME_POFF)
            player:say("You don't have enough energy to enter this portal", TALKTYPE_MONSTER_SAY)
        end
        return true

    elseif config.portals[aid] then
        local t = config.portals[aid]
        player:teleportTo(t.pos)
        t.pos:sendMagicEffect(CONST_ME_TELEPORT)
        player:say(t.text, TALKTYPE_MONSTER_SAY)
        return true
    end

    return false
end 