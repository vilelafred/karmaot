function onUse(cid, item, frompos, item2, topos)
    local house = cid:getTile():getHouse()
    if house then
        if getTileHouseInfo(getPlayerPosition(cid)) >= 1 then --Making sure it's in a house
            local playerVoc = getPlayerVocation(cid)
            local stoRuby = 95030
            if playerVoc == 0 and getPlayerStorageValue(cid, stoRuby) == 1 then
                setPlayerStorageValue(cid, 99992, 1) -- bed rookgaard maker
            else
                setPlayerStorageValue(cid, 99992, 0)
            end
            if playerVoc ~= 0 then
                setPlayerStorageValue(cid, 99991, 1) -- bed rune maker
            end
        end  
    end
end
