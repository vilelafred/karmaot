local ML_MIN, ML_REF = 10, 100

local function clamp(x, a, b)
    if x < a then return a end
    if x > b then return b end
    return x
end

local function estimateUHRAvg(caster, target)
    local level = getPlayerLevel(caster)
    local mag = getPlayerMagLevel(caster)
    local voc = getPlayerVocation(caster)
    local base = 250
    if voc == 4 or voc == 8 then
        base = 310
    end
    local minv = math.max(base, ((3 * mag + 2 * level) * base / 100))
    local maxv = math.floor(minv * 1.25 + 0.5)
    return math.floor((minv + maxv) / 2)
end

local function computeSioHeal(caster, target)
    local HPmax = target:getMaxHealth()
    local ML = getPlayerMagLevel(caster)

    local f = clamp((ML - ML_MIN) / (ML_REF - ML_MIN), 0, 1)
    local p = 0.50 + 0.30 * f
    local p_min = clamp(p - 0.05, 0.50, 0.80)
    local p_max = clamp(p + 0.05, 0.55, 0.80)

    local heal = math.random(math.floor(p_min * HPmax), math.floor(p_max * HPmax))

    local uhr = estimateUHRAvg(caster, target)
    heal = math.max(heal, math.floor(1.30 * uhr))
    heal = math.min(heal, math.floor(0.80 * HPmax))

    return heal
end

function onCastSpell(cid, var)
    local caster = Player(cid)
    if not caster then
        return false
    end

    local targetId = variantToNumber(var)
    local target = Creature(targetId)
    if not target or not target:isPlayer() then
        -- fallback: cura o próprio caster se alvo inválido
        target = caster
    end

    local amount = computeSioHeal(cid, target)
    target:addHealth(amount)
    target:removeCondition(CONDITION_PARALYZE)
    target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    caster:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    return true
end