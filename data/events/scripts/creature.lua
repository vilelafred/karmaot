local function removeCombatProtection(uid)
    local player = Player(uid)
    if player then
        local combatStorage = PlayerStorageKeys and PlayerStorageKeys.combatProtectionStorage or 10000
        player:setStorageValue(combatStorage, -1)
    end
end

function Creature:onTargetCombat(target)
    -- Inicializa PlayerStorageKeys se não estiver definido
    if not PlayerStorageKeys then
        PlayerStorageKeys = {
            combatProtectionStorage = 10000 -- fallback padrão
        }
    end

    if not self or not target then
        return true
    end
	target:registerEvent("rollHealth")
    if target:isPlayer() and self:isMonster() then
        local combatProtectionStorage = PlayerStorageKeys.combatProtectionStorage
        local protectionStorage = target:getStorageValue(combatProtectionStorage)

        if target:getIp() == 0 then
            -- Se ainda não está protegido, ativa proteção e agenda remoção
            if protectionStorage ~= 1 then
                target:setStorageValue(combatProtectionStorage, 1)
                addEvent(removeCombatProtection, 30 * 1000, target.uid)
            else
                self:searchTarget()
                return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
            end

            return true
        end

        if protectionStorage >= os.time() then
            return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
        end
    end

    -- Se jogador atacar monstro, registra evento extra de loot (opcional)
    if self:isPlayer() and target:isMonster() then
        target:registerEvent("extra_loot_d")
		target:registerEvent("criticalHitSystemXHP")
    end


    if hasEventCallback(EVENT_CALLBACK_ONTARGETCOMBAT) then
        return EventCallback(EVENT_CALLBACK_ONTARGETCOMBAT, self, target)
    end
	return true
end
