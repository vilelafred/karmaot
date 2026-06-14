local throneMessages = {
    [5100] = "You feel the blazing rage of a Demon flowing through your veins.",
    [5101] = "The shadow of a Black Knight shrouds your spirit.",
    [5102] = "The furious roar of a Fury echoes within your soul."
}

local requiredStorages = {5100, 5101, 5102}

-- Efeitos visuais
local EFFECT_ABSORB = CONST_ME_MAGIC_BLUE     -- primeira vez
local EFFECT_BUFFED = CONST_ME_MAGIC_RED      -- já tocado

-- Tronos
for uid, message in pairs(throneMessages) do
    local stepIn = MoveEvent()
    stepIn:type("stepin")
    stepIn:uid(uid)

    function stepIn.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then return true end

        if player:getStorageValue(uid) < 1 then
            player:setStorageValue(uid, 1)
            player:say(message, TALKTYPE_MONSTER_SAY)
            position:sendMagicEffect(EFFECT_ABSORB)
        else
            player:say("You have already absorbed the energy of this throne.", TALKTYPE_MONSTER_SAY)
            position:sendMagicEffect(EFFECT_BUFFED)
        end
        return true
    end

    stepIn:register()
end

-- Raios
for uid = 5103, 5105 do
    local stepIn = MoveEvent()
    stepIn:type("stepin")
    stepIn:uid(uid)

    function stepIn.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then return true end

        for _, storage in ipairs(requiredStorages) do
            if player:getStorageValue(storage) < 1 then
                player:teleportTo(fromPosition, true)
                player:sendCancelMessage("A magical barrier blocks your path. You must absorb the energy of all three thrones.")
                return false
            end
        end

        player:say("The magical seal acknowledges your strength. You may pass.", TALKTYPE_MONSTER_SAY)
        return true
    end

    stepIn:register()
end
