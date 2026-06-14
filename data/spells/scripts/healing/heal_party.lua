-- Heal Party (70% do Exura Sio por alvo) – exevo sio mas
local PARTY_HEAL_FACTOR = 0.70
local RANGE_SQMS = 7
local REQUIRE_SIGHT = true
local PER_TARGET_COOLDOWN_MS = 800
local SHOW_EFFECTS = true
local EFFECT = CONST_ME_MAGIC_BLUE

local ML_MIN, ML_REF = 10, 100
local lastTick = _G.__party_heal_lastTick or {}
_G.__party_heal_lastTick = lastTick

local function clamp(x, a, b)
    if x < a then return a end
    if x > b then return b end
    return x
end

local function os_millis()
    return (os.time() * 1000) + math.floor((os.clock() % 1) * 1000)
end

local function canHealNow(caster, target)
    local c, t = caster:getGuid(), target:getGuid()
    lastTick[c] = lastTick[c] or {}
    local now = os_millis()
    local last = lastTick[c][t] or 0
    if (now - last) < PER_TARGET_COOLDOWN_MS then return false end
    lastTick[c][t] = now
    return true
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

function onCastSpell(creature, var)
    local caster = creature
    if not caster or not caster:isPlayer() then return false end

    local party = caster:getParty()
    if not party then
        caster:sendCancelMessage("Voce nao esta em uma party.")
        return false
    end

    local cpos = caster:getPosition()
    local healed = 0
    local members = party:getMembers()
    table.insert(members, party:getLeader())

    for _, member in ipairs(members) do
        if member and member:isPlayer() then
            local tpos = member:getPosition()
            if cpos.z == tpos.z then
                local inRange = (cpos:getDistance(tpos) <= RANGE_SQMS)
                local sightOK = (not REQUIRE_SIGHT) or cpos:isSightClear(tpos, true)
                if inRange and sightOK and canHealNow(caster, member) then
                    local base = computeSioHeal(caster, member)
                    local amount = math.floor(base * PARTY_HEAL_FACTOR)
                    member:addHealth(amount)
                    if SHOW_EFFECTS then
                        tpos:sendMagicEffect(EFFECT)
                    end
                    healed = healed + 1
                end
            end
        end
    end

    if healed == 0 then
        caster:sendCancelMessage("Nenhum membro valido da party na tela.")
        return false
    end
    if SHOW_EFFECTS then cpos:sendMagicEffect(EFFECT) end
    return true
end