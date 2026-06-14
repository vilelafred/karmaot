local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE) 
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HITAREA) 

local area = createCombatArea(AREA_SQUARE1X1) 
setCombatArea(combat, area) 
function getSpellDamage(cid, weaponSkill, weaponAttack, attackStrength) 
    local hit = (getPlayerLevel(cid) * 1.2 + weaponSkill * 4.0 + weaponAttack * 7.0 + (getPlayerMagLevel(cid)+1) / 3) * 1.61  
    local damage = -(math.random(hit * 0.9, hit)) 
        return damage, damage 
        end 
        setCombatCallback(combat, CALLBACK_PARAM_SKILLVALUE, "getSpellDamage") 
         
        function onCastSpell(cid, var) 
        -- Verificar se o player tem Ice Rapier (ID 2396) EQUIPADA e remover apenas se estiver equipada
        local weaponSlot = getPlayerSlotItem(cid, CONST_SLOT_LEFT)
        if weaponSlot.itemid == 2396 then
            -- Ice Rapier está equipada na mão esquerda
            doRemoveItem(weaponSlot.uid, 1)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Your Ice Rapier broke with the power of exori!")
        else
            weaponSlot = getPlayerSlotItem(cid, CONST_SLOT_RIGHT)
            if weaponSlot.itemid == 2396 then
                -- Ice Rapier está equipada na mão direita
                doRemoveItem(weaponSlot.uid, 1)
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "Your Ice Rapier broke with the power of exori!")
            end
            -- Não verifica inventário - apenas remove se estiver equipada
        end
        
        return doCombat(cid, combat, var) 
        end