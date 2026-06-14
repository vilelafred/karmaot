local fireDaggerId = 2418
local fire_percent = 5
local fire_damage = {}


local weapon = Weapon(WEAPON_SWORD)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)

function onGetFormulaValues(player, skill, attack, factor)
    local min = 0
    local max = getMaxWeaponDamage(player:getLevel(), skill, (attack * GLOBAL_vocationMultipliers[player:getVocation():getId()].meleeDamage), factor)
    local damage = normal_random_range(min, max)
    fire_damage[player:getId()] = math.floor(((damage / 100) * fire_percent) + 0.5)
    damage = player:getTarget():calculateDamageAfterArmorandDefence(damage)
    return -damage, -damage
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


local combat_fire = Combat()
combat_fire:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)

function onGetFormulaValues(player, skill, attack, factor)
    local fireDamage = fire_damage[player:getId()]
    fire_damage[player:getId()] = nil
    return -fireDamage, -fireDamage
end

combat_fire:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function weapon.onUseWeapon(player, variant)
    if player:getSkull() == SKULL_BLACK then
        return false
    end

    combat:execute(player, variant)
    combat_fire:execute(player, variant)
    return true
end

weapon:id(fireDaggerId)
weapon:register()