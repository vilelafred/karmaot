-- Combat normal (para outras vocações)
local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -0.6, -10, -1.0, 0)

-- Combat para Knights (40% menos dano)
local combatKnight = createCombatObject()
setCombatParam(combatKnight, COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
setCombatParam(combatKnight, COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
setCombatParam(combatKnight, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
setCombatFormula(combatKnight, COMBAT_FORMULA_LEVELMAGIC, -0.36, -6, -0.6, 0)

-- Combat para Paladins (15% menos dano)
local combatPaladin = createCombatObject()
setCombatParam(combatPaladin, COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
setCombatParam(combatPaladin, COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
setCombatParam(combatPaladin, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
setCombatFormula(combatPaladin, COMBAT_FORMULA_LEVELMAGIC, -0.51, -8.5, -0.85, 0)

local arr = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local area = createCombatArea(arr)
setCombatArea(combat, area)
setCombatArea(combatKnight, area)
setCombatArea(combatPaladin, area)

function onCastSpell(cid, var)
    local player = Player(cid)
    if not player then
        return false
    end
    
    local vocation = player:getVocation():getId()
    
    -- Knight = 4, Elite Knight = 8, None = 0 (40% menos dano)
    if vocation == 0 or vocation == 4 or vocation == 8 then
        -- player:sendTextMessage(MESSAGE_INFO_DESCR, "Vocacao " .. vocation .. " (Knight) - 40% menos dano!")
        return doCombat(cid, combatKnight, var)
    -- Paladin = 3, Royal Paladin = 7 (15% menos dano)
    elseif vocation == 3 or vocation == 7 then
        -- player:sendTextMessage(MESSAGE_INFO_DESCR, "Vocacao " .. vocation .. " (Paladin) - 15% menos dano!")
        return doCombat(cid, combatPaladin, var)
    -- Outras vocações (dano normal)
    else
        -- player:sendTextMessage(MESSAGE_INFO_DESCR, "Vocacao " .. vocation .. " - dano normal!")
        return doCombat(cid, combat, var)
    end
end
