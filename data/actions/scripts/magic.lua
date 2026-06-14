local magicPowderId = 5838
local requiredAmount = 20

local blockedItemIds = {
    [6038] = true, -- Anvil
    [4857] = true, -- Book
    [6047] = true, -- Workbench
    [6027] = true, -- Dragon Stone
    [8749] = true  -- Stone Pillar (exemplo)
}

local rarityAttributes = {
    "critChance", "lifeLeech", "manaLeech", "speed", "hp", "mp", "maxMana", "maxHealth",
    "meleeSkill", "axeSkill", "clubSkill", "swordSkill", "distanceSkill", "magicLevel",
    "shieldSkill", "armor", "elementalDamage", "elementalResist", "reflection",
    "extraHealing", "extraDamage"
}

function hasRarityAttributes(item)
    for _, attr in ipairs(rarityAttributes) do
        if item:getAttribute(attr) then
            return true
        end
    end
    return false
end

function onUse(player, item, fromPosition, target, toPosition)
    if item:getId() ~= magicPowderId then
        return false
    end

    if not target or not target:isItem() then
        player:sendCancelMessage("You must use this on an equipable item.")
        return true
    end

    local itemId = target:getId()
    local itemType = ItemType(itemId)

    -- 🔒 Bloqueia se for o próprio Magic Powder
    if itemId == magicPowderId then
        player:sendCancelMessage("You can't use Magic Powder on itself.")
        return true
    end

    -- 🔒 Bloqueia stackables (runes, potions, coins)
    if itemType:isStackable() then
        player:sendCancelMessage("You can't use Magic Powder on stackable items.")
        return true
    end

    -- 🔒 Bloqueia itens não-equipáveis
    if not itemType or itemType:getSlotPosition() == 0 then
        player:sendCancelMessage("You can only use Magic Powder on equipable items.")
        return true
    end

    -- 🔒 Bloqueia itens fixos do mapa ou listados manualmente
    if blockedItemIds[itemId] or not itemType:isMovable() then
        player:sendCancelMessage("You can't use Magic Powder on this kind of object.")
        return true
    end

    -- 🔒 Verifica se tem atributos de raridade
    if not hasRarityAttributes(target) then
        player:sendCancelMessage("This item is not enchanted with any rarity.")
        return true
    end

    -- 🔒 Verifica se o player tem no mínimo 20 Magic Powders
    if item:getCount() < requiredAmount then
        player:sendCancelMessage("You need at least 20 Magic Powders to cleanse an item.")
        return true
    end

    -- ✅ Tudo certo: remove o item encantado e cria novo limpo
    target:remove()
    player:addItem(itemId, 1)
    item:remove(requiredAmount)

    player:say("The item has been restored to its original form!", TALKTYPE_MONSTER_SAY)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)

    return true
end
