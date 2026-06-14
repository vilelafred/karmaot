-- KarmaOT Advanced Mitigation System (PvE/PvP adaptive)
-- Autor: KarmaOT
-- Data: 2025-10-22

local DEBUG = true                    -- logs no console para validação
local PVP_START_ENEMIES = 3           -- a partir de 3 players batendo, aplica penalidade
local PVP_PER_EXTRA_ENEMY = 0.10      -- +10% dano recebido por inimigo extra (cap abaixo)
local PVP_MAX_PENALTY = 0.50          -- até +50% de dano

local PVE_START_MOBS = 8              -- acima de 7 (ou seja, 8+) começa a mitigar
local PVE_SHIELD_FACTOR = 0.0035      -- peso do Shielding
local PVE_STACK_PER_MOB = 0.5         -- multiplicador por mob extra
local PVE_MAX_MITIGATION = 0.70       -- até 70% de redução

local EFFECT_DEBUG_PVE = true        -- se true, mostra efeito quando PvE mitigation ativa
local EFFECT_ID = 32

local function dbg(msg)
    if DEBUG then
        print("[Mitigation] " .. msg)
    end
end

local function countAttackers(creature, wantPlayers)
    local pos = creature:getPosition()
    local spec = Game.getSpectators(pos, false, true, 1, 1, 1, 1)
    local count = 0
    for _, c in ipairs(spec) do
        if wantPlayers then
            if c:isPlayer() and c:getTarget() == creature then
                count = count + 1
            end
        else
            if c:isMonster() and c:getTarget() == creature then
                count = count + 1
            end
        end
    end
    return count
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature or not creature:isPlayer() or not attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if attacker:isPlayer() then
        -- PvP: enfraquece shield sob foco de vários players (pressão humana)
        local enemies = countAttackers(creature, true)
        if enemies >= PVP_START_ENEMIES then
            local extra = enemies - (PVP_START_ENEMIES - 1)
            local penalty = math.min(PVP_MAX_PENALTY, extra * PVP_PER_EXTRA_ENEMY)
            if penalty > 0 then
                local inDmg = primaryDamage
                primaryDamage = primaryDamage * (1 + penalty)
                dbg(string.format("PvP: enemies=%d extra=%d penalty=%.2f in=%.0f out=%.0f", enemies, extra, penalty, inDmg, primaryDamage))
            end
        end
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    else
        -- PvE: reforça mitigação com base no Shielding quando cercado por muitos mobs (apenas físico de melee)
        if origin ~= ORIGIN_MELEE or (primaryType ~= COMBAT_PHYSICALDAMAGE and secondaryType ~= COMBAT_PHYSICALDAMAGE) then
            return primaryDamage, primaryType, secondaryDamage, secondaryType
        end

        local mobs = countAttackers(creature, false)
        if mobs >= PVE_START_MOBS then
            local shieldSkill = creature:getSkillLevel(SKILL_SHIELD)
            local stacks = (mobs - (PVE_START_MOBS - 1)) * PVE_STACK_PER_MOB
            local mitigation = math.min(PVE_MAX_MITIGATION, (shieldSkill * PVE_SHIELD_FACTOR) * stacks)
            if mitigation > 0 then
                local inDmg = primaryDamage
                primaryDamage = primaryDamage * (1 - mitigation)
                dbg(string.format("PvE: mobs=%d shield=%d stacks=%.2f mit=%.2f in=%.0f out=%.0f", mobs, shieldSkill, stacks, mitigation, inDmg, primaryDamage))
                if EFFECT_DEBUG_PVE then
                    creature:getPosition():sendMagicEffect(EFFECT_ID)
                end
            end
        end
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
end


