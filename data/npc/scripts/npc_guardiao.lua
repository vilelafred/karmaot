local STORAGE_ALIGNMENT = 50000
local STORAGE_STAGE = 50001

function onCreatureSay(cid, type, msg)
    local player = Player(cid)
    if not player then return false end

    local text = msg:lower()
    local stage = player:getStorageValue(STORAGE_STAGE)

    if text == "hi" then
        if player:getStorageValue(STORAGE_ALIGNMENT) > 0 then
            selfSay("You have already chosen your path. There is no turning back.", cid)
            return true
        end
        selfSay("Greetings, traveler. Say {mission} if you seek guidance.", cid)
        player:setStorageValue(STORAGE_STAGE, 1)
        return true
    end

    if text == "mission" and stage == 1 then
        selfSay("Do you wish to swear loyalty to the {light} or embrace the power of the {shadow}?", cid)
        player:setStorageValue(STORAGE_STAGE, 2)
        return true
    end

    if text == "light" and stage == 2 then
        selfSay("Are you sure you want to follow the path of LIGHT? {yes} or {no}", cid)
        player:setStorageValue(STORAGE_STAGE, 3)
        return true
    end

    if text == "shadow" and stage == 2 then
        selfSay("Are you sure you want to embrace the SHADOW? {yes} or {no}", cid)
        player:setStorageValue(STORAGE_STAGE, 4)
        return true
    end

    if text == "yes" then
        if stage == 3 then
            player:setStorageValue(STORAGE_ALIGNMENT, 1000)
            player:setStorageValue(STORAGE_STAGE, -1)
            player:addItem(2197, 1)
            local regenBuff = Condition(CONDITION_REGENERATION)
            regenBuff:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 60 * 1000)
            regenBuff:setParameter(CONDITION_PARAM_HEALTHGAIN, 25)
            regenBuff:setParameter(CONDITION_PARAM_HEALTHTICKS, 2000)
            regenBuff:setParameter(CONDITION_PARAM_MANAGAIN, 20)
            regenBuff:setParameter(CONDITION_PARAM_MANATICKS, 2000)
            player:addCondition(regenBuff)
            player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
            selfSay("You have chosen the path of Light. May justice guide your steps.", cid)
        elseif stage == 4 then
            player:setStorageValue(STORAGE_ALIGNMENT, 2000)
            player:setStorageValue(STORAGE_STAGE, -1)
            player:addItem(2394, 1)
            local damageBuff = Condition(CONDITION_ATTRIBUTES)
            damageBuff:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 60 * 1000)
            damageBuff:setParameter(CONDITION_PARAM_SKILL_MELEE, 5)
            damageBuff:setParameter(CONDITION_PARAM_SKILL_SWORD, 5)
            player:addCondition(damageBuff)
            player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
            selfSay("You have chosen the path of Shadow. May chaos empower you.", cid)
        end
        return true
    end

    if text == "no" and (stage == 3 or stage == 4) then
        selfSay("Very well. Come back when you are sure of your choice.", cid)
        player:setStorageValue(STORAGE_STAGE, 1)
        return true
    end

    return false
end
