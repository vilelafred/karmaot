function onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if player:getStorageValue(1234) >= os.time() then
        player:say('You already have BOOST ACTIVED!', TALKTYPE_MONSTER_SAY)
        return true
    end

    player:setStorageValue(1234, os.time() + 3600)
    Item(item.uid):remove(1)
    player:say('Your 1 hour of 20% more EXP has started!', TALKTYPE_MONSTER_SAY)
    return true
end