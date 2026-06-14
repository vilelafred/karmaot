-- Xikini's Shitty™ Weapon Handling for Physical Melee Weapons

function parseFormulaAttributes(xmlContent)
    local formulas = {}
    -- Pattern to match the <formula> element and extract its attributes
    local pattern = "<formula%s+meleeDamage=\"(.-)\"%s+distDamage=\"(.-)\"%s+defense=\"(.-)\"%s+armor=\"(.-)\"%s*/>"
   
    for meleeDamage, distDamage, defense, armor in xmlContent:gmatch(pattern) do
        table.insert(formulas, {
            meleeDamage = meleeDamage,
            distDamage = distDamage,
            defense = defense,
            armor = armor
        })
    end

    return formulas
end

-- Function to read the XML content from a file
function readXmlFile(filePath)
    local file = io.open(filePath, "r")
    if not file then
        error("Cannot open file: " .. filePath)
        return nil
    end
    local content = file:read("*all")
    file:close()
    return content
end

local filePath = "data/XML/vocations.xml"
local xmlContent = readXmlFile(filePath)
GLOBAL_vocationMultipliers = parseFormulaAttributes(xmlContent)


weaponTypesToSkillType = {
    [WEAPON_SWORD] = SKILL_SWORD,
    [WEAPON_CLUB] = SKILL_CLUB,
    [WEAPON_AXE] = SKILL_AXE
}


function Creature.getDefense(self)
    -- shield and melee weapon
    local defense = 0
   
    if self:isMonster() then
        defense = self:getType():defense()
       
    elseif self:isPlayer() then
        -- if no weapon or shield do fist fighting
        local defenseSkill = self:getSkillLevel(SKILL_FIST)
        local defenseValue = 7;
       
        local weapon = self:getSlotItem(CONST_SLOT_LEFT)
        local weaponDefense = 0
        local weaponExtraDefense = 0
       
        local shield = self:getSlotItem(CONST_SLOT_RIGHT)
        local shieldDefense = 0
   
        if weapon then
            local weaponItemType = ItemType(weapon:getId())
           
            if weapon:hasAttribute(ITEM_ATTRIBUTE_DEFENSE) then
                weaponDefense = weapon:getAttribute(ITEM_ATTRIBUTE_DEFENSE)
            else
                weaponDefense = weaponItemType:getDefense()
            end
            if weapon:hasAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE) then
                weaponExtraDefense = weapon:getAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE)
            else
                weaponExtraDefense = weaponItemType:getExtraDefense()
            end
           
            defenseValue = weaponDefense + weaponExtraDefense
            local skillType = weaponTypesToSkillType[weaponItemType:getWeaponType()]
            defenseSkill = skillType and self:getSkillLevel(skillType) or 0
        end
   
        if shield then
            local shieldItemType = ItemType(shield:getId())
           
            if shield:hasAttribute(ITEM_ATTRIBUTE_DEFENSE) then
                shieldDefense = shield:getAttribute(ITEM_ATTRIBUTE_DEFENSE)
            else
                shieldDefense = shieldItemType:getDefense()
            end
       
            defenseValue = weapon and shieldDefense + weaponExtraDefense or shieldDefense
            defenseSkill = self:getSkillLevel(SKILL_SHIELD)
        end
       
        if defenseSkill == 0 then
            if self:getFightMode() == FIGHTMODE_DEFENSE then
                return 2
            else
                return 1
            end
        end
       
        defense = (defenseSkill / 4. + 2.23) * defenseValue * 0.15 * GLOBAL_vocationMultipliers[self:getVocation():getId()].defense
    end
   
    return defense
end

function Creature.getArmor(self)
    local armor = 0
   
    if self:isMonster() then
        armor = self:getType():armor()

    elseif self:isPlayer() then
        -- loop through equipment, finding armor and adding together
        for slotItem = 1, 10 do
            if slotItem ~= CONST_SLOT_LEFT and slotItem ~= CONST_SLOT_RIGHT then
                local item = self:getSlotItem(slotItem)
                if item then
                    if item:hasAttribute(ITEM_ATTRIBUTE_ARMOR) then
                        armor = armor + item:getAttribute(ITEM_ATTRIBUTE_ARMOR)
                    else
                        armor = armor + ItemType(item:getId()):getArmor()
                    end
                end
            end
        end
   
    end
   
    return armor
end

function Creature.calculateDamageAfterArmorandDefence(self, damage)
    local checkArmor = true
   
    local defense = self:getDefense()
    damage = damage - (math.random(defense / 2, defense))
    if damage <= 0 then
        damage = 0
        checkArmor = false
    end

    if checkArmor then
        armor = math.max(self:getArmor(), 1)
        damage = damage - (math.random(armor / 2, armor - (armor % 2 + 1)))
    end
   
    return math.floor(damage + 0.5)
end

function normal_random(mean, std_dev)
    local u1 = math.random()
    local u2 = math.random()
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
    -- Use z0 for the normal random number (z1 would be the second number, not used here)
    return z0 * std_dev + mean
end

-- Function to generate a random integer within a range based on a normal distribution
function normal_random_range(minNumber, maxNumber)
    local mean = 0.5
    local std_dev = 0.25
    local v
    repeat
        v = normal_random(mean, std_dev)
    until v >= 0.0 and v <= 1.0

    local a, b = math.min(minNumber, maxNumber), math.max(minNumber, maxNumber)
    return math.floor(a + (b - a) * v + 0.5) -- Using floor(x + 0.5) to round to the nearest integer
end

function getMaxWeaponDamage(playerLevel, skillLevel, attackValue, attackFactor)
    return math.ceil((playerLevel / 5) + (((((skillLevel / 4.) + 1) * (attackValue / 3.)) * 1.03) / attackFactor))
end


function Player:hasEvent(type, name)
    for k, v in pairs(self:getEvents(type)) do
        if v == name then
            return true
        end
    end
    return false
end