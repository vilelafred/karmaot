-- KarmaOT – Speed Curve by Level (PvE/PvP friendly)
-- Objetivo:
--   - Lv 150 ~ 900 speed (arranque)
--   - Lv 2000 ~ 1350 speed (deixa margem para hastes)
--   - Sem mexer no core C++

local SPEED_SUBID = 424242 -- subid exclusivo da curva
local MAX_BASE_SPEED = 1350 -- clamp de base (magias podem passar disso)

local function targetSpeedByLevel(level)
    if level <= 150 then
        return 220 + 4.533 * level
    elseif level <= 2000 then
        return 900 + 0.243243 * (level - 150)
    else
        return 1350 + 0.10 * (level - 2000)
    end
end

-- Aproximação do engine base (TFS retrô): 220 + 2 * level
local function engineBaseSpeed(level)
    return 220 + 2 * level
end

local function applySpeedCurve(player)
    if not player or not player:isPlayer() then
        return
    end

    -- GMs não são afetados pela speed curve
    if player:getGroup():getAccess() then
        return
    end

    -- remove condicionador anterior desta curva
    player:removeCondition(CONDITION_HASTE, CONDITIONID_COMBAT, SPEED_SUBID)

    local level = player:getLevel()
    local target = math.min(MAX_BASE_SPEED, targetSpeedByLevel(level))
    local base   = engineBaseSpeed(level)
    local delta  = math.floor(target - base + 0.5)

    if delta == 0 then
        return
    end

    -- Usa CONDITION_HASTE para ambos (positivo e negativo)
    -- Isso evita o ícone de "paralyze" aparecer
    local cond = Condition(CONDITION_HASTE)
    cond:setParameter(CONDITION_PARAM_TICKS, -1) -- permanente (até recalc)
    cond:setParameter(CONDITION_PARAM_SUBID, SPEED_SUBID)
    cond:setParameter(CONDITION_PARAM_SPEED, delta)
    cond:setParameter(CONDITION_PARAM_BUFF_SPELL, false) -- não aparece no buff bar
    player:addCondition(cond)
end

function onLogin(player)
    applySpeedCurve(player)
    return true
end

function onAdvance(player, skill, oldLevel, newLevel)
    if skill == SKILL_LEVEL and newLevel > oldLevel then
        applySpeedCurve(player)
    end
    return true
end


