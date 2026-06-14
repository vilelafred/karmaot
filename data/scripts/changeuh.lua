-- Converte UH antiga (2273,100) para UH nova (6675,100) ao usar o item
-- Nekiro/TFS 1.5

local OLD_ID = 2273
local NEW_ID = 6675
local REQUIRED_CHARGES = 100

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- garante que só roda no item certo
    if item.itemid ~= OLD_ID then
        return false
    end

    -- tenta ler charges (modo moderno); fallback para count
    local charges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
    if not charges or charges <= 0 then
        charges = item:getCount() or 0
    end

    if charges ~= REQUIRED_CHARGES then
        player:sendCancelMessage("Você precisa de uma UH com exatamente 100 cargas.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- transforma para a UH nova e restaura as charges
    item:transform(NEW_ID)
    item:setAttribute(ITEM_ATTRIBUTE_CHARGES, charges)

    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    player:say("Ultimate Healing atualizada!", TALKTYPE_MONSTER_SAY)
    return true
end

-- registra no id da UH antiga
action:id(OLD_ID)
action:register()
