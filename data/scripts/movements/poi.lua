-- Pits of Inferno - Tronos e Raios
local throneData = {
    [51933] = {storage = 60001, message = "You feel the blazing rage of a Demon flowing through your veins."},
    [51934] = {storage = 60002, message = "The shadow of a Black Knight shrouds your spirit."},
    [51936] = {storage = 60003, message = "The furious roar of a Fury echoes within your soul."},
    [51937] = {storage = 60004, message = "The icy breath of an undead dragon surrounds your essence."},
    [51938] = {storage = 60005, message = "The cursed souls of the damned whisper in your ear."},
    [51944] = {storage = 60006, message = "You feel the ancient power of the underworld rising within you."},
    [60008] = {storage = 60007, message = "A blinding infernal light burns into your soul."}
}

local EFFECT_ABSORB = CONST_ME_MAGIC_BLUE
local EFFECT_BUFFED = CONST_ME_MAGIC_RED

-- TRONOS: ativa storage e mostra efeito
for aid, data in pairs(throneData) do
    local stepIn = MoveEvent()
    stepIn:type("stepin")
    stepIn:aid(aid)

    function stepIn.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then return true end

        if player:getStorageValue(data.storage) < 1 then
            player:setStorageValue(data.storage, 1)
            player:say(data.message, TALKTYPE_MONSTER_SAY)
            position:sendMagicEffect(EFFECT_ABSORB)
        else
            player:say("You have already absorbed the energy of this throne.", TALKTYPE_MONSTER_SAY)
            position:sendMagicEffect(EFFECT_BUFFED)
        end
        return true
    end

    stepIn:register()
end

-- Storages exigidos para liberar os lasers
local requiredStorages = {
    60001, 60002, 60003, 60004, 60005, 60006, 60007
}

-- Lista dos AIDs únicos dos raios
local laserAids = {51946, 51947, 51948, 51949, 51950, 51951, 51952}

-- RAIOS: só passa se tiver todos os tronos ativados
for _, aid in ipairs(laserAids) do
    local stepIn = MoveEvent()
    stepIn:type("stepin")
    stepIn:aid(aid)

    function stepIn.onStepIn(creature, item, position, fromPosition)
        local player = creature:getPlayer()
        if not player then return true end

        for _, storage in ipairs(requiredStorages) do
            if player:getStorageValue(storage) < 1 then
                player:teleportTo(fromPosition, true)
                player:sendCancelMessage("A magical barrier blocks your path. You must absorb the energy of all seven thrones.")
                return false
            end
        end

        player:say("The magical seal acknowledges your strength. You may pass.", TALKTYPE_MONSTER_SAY)
        return true
    end

    stepIn:register()
end
