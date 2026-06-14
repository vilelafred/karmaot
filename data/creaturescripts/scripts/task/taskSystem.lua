function onKill(player, target, lastHit)
    if not (tasks:onTask(player) > 0) then
        return false
    end

    if not player:isPlayer() then
        return false
    end

    if target:getMaster() ~= nil then
        return false
    end

    tasks:onKill(player, target)
    return true
end