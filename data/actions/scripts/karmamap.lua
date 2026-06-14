local STAFF_BYPASS = true

local OWNER_TEXT_KEY = ITEM_ATTRIBUTE_TEXT
local OWNER_DESC_KEY = ITEM_ATTRIBUTE_DESCRIPTION

local MSG_BOUND_SELF = "You are now the exclusive owner of this Karma Map."
local MSG_NOT_OWNER  = "This Karma Map is bound to another adventurer. You cannot use it."
local DESC_PREFIX    = "This Karma Map belongs to: "

local function safeEffect(pos)
    if pos and pos.x and pos.y and pos.z then
        Position(pos):sendMagicEffect(CONST_ME_POFF)
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- alvo seguro p/ efeitos visuais
    local fxPos = player:getPosition()

    -- bloqueio PZ/infight
    if player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
        player:sendCancelMessage("You can't use this when you're in a fight.")
        Position(fxPos):sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- staff bypass
    local isStaff = false
    local grp = player:getGroup()
    if grp and grp.getAccess and grp:getAccess() then
        isStaff = true
    end

    if not (STAFF_BYPASS and isStaff) then
        -- soulbound
        local ownerGuid = item:getAttribute(OWNER_TEXT_KEY)
        if not ownerGuid or ownerGuid == "" then
            local guid = tostring(player:getGuid())
            local name = player:getName()
            item:setAttribute(OWNER_TEXT_KEY, guid)
            item:setAttribute(OWNER_DESC_KEY, DESC_PREFIX .. name)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, MSG_BOUND_SELF)
        else
            if ownerGuid ~= tostring(player:getGuid()) then
                player:sendCancelMessage(MSG_NOT_OWNER)
                Position(fxPos):sendMagicEffect(CONST_ME_POFF)
                return true
            end
        end
    end

    -- cooldown 20h
    local cooldownStorage = 50006
    local lastUseTime = player:getStorageValue(cooldownStorage)
    local currentTime = os.time()
    local cooldownTime = 2 * 60 * 60

    if lastUseTime > 0 and (currentTime - lastUseTime) < cooldownTime then
        local remainingTime = cooldownTime - (currentTime - lastUseTime)
        local remainingHours = math.floor(remainingTime / 3600)
        local remainingMinutes = math.floor((remainingTime % 3600) / 60)
        player:sendCancelMessage(string.format(
            "You must wait %d hours and %d minutes before using this map again.",
            remainingHours, remainingMinutes
        ))
        Position(fxPos):sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- ação do mapa (teleporte)
    player:teleportTo(getTownTemplePosition(player:getTown():getId()))
    player:setStorageValue(cooldownStorage, currentTime)
    Position(player:getPosition()):sendMagicEffect(CONST_ME_MAGIC_BLUE)
    return true
end
