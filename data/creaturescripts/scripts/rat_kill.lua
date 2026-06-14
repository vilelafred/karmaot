function onKill(player, target)
    if not target:isMonster() then return true end
    if target:getName():lower() == "rat" then
        local storage = 9002
        local kills = player:getStorageValue(storage)
        if kills < 0 then kills = 0 end
        player:setStorageValue(storage, kills + 1)
    end
    return true
end
