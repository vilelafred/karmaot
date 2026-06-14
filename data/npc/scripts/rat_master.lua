local keyword = "reward"
local killStorage = 9002
local rewardStorage = 9003

function onCreatureSay(cid, type, msg)
    if msg:lower() == "hi" then
        selfSay("Hello! If you have killed 5 rats, say 'reward' to receive your prize.", cid)
        return true
    end

    if msg:lower() == keyword then
        local kills = getPlayerStorageValue(cid, killStorage)
        if kills < 0 then kills = 0 end

        if getPlayerStorageValue(cid, rewardStorage) == 1 then
            selfSay("You have already received your reward.", cid)
            return true
        end

        if kills >= 5 then
            doPlayerAddItem(cid, 2398, 1) -- Mace
            doPlayerAddItem(cid, 2464, 1) -- Chain Armor
            doPlayerAddItem(cid, 2512, 1) -- Wooden Shield
            setPlayerStorageValue(cid, rewardStorage, 1)
            doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE) -- efeito do exura (id 12)
            selfSay("Congratulations! Here is your reward.", cid)
        else
            selfSay("You haven't killed enough rats yet. You have killed " .. kills .. ".", cid)
        end
    end

    return true
end
