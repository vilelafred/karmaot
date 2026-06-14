function onUse(cid, item, frompos, item2, topos)
if getTilePzInfo(getCreaturePosition(cid)) then 
doPlayerSendCancel(cid,"Essa criatura não pode ser sumonado em protect zone!.") 
return TRUE 
end 


if (getPlayerStorageValue(cid, 11548) >= os.time()) then
doPlayerSendTextMessage(cid, 6,"Por medidas de segurança você só pode utilizar este comando em " .. 
(getPlayerStorageValue(cid, 11548)-os.time()+(6000)) .. " segundos.")
return true
end 
storage = 11548
if #getCreatureSummons(cid) >= 1 then
return doPlayerSendCancel(cid,"Voce não pode ter trainers para batalhar!")
end

if getPlayerStorageValue(cid,storsol) == 1 then
local z = getCreatureSummons(cid)[1]
doSendMagicEffect(getCreaturePosition(z), 2)
doSendDistanceShoot(getCreaturePosition(z), getPlayerPosition(cid), 3)
return true
end


local summons = getCreatureSummons(cid)


local trainer = {
["Training Monk"] = {20,250},
}


for k,v in pairs(trainer) do -- 1


if getPlayerStorageValue(cid,storsol) < 1 then
if getPlayerLevel(cid) >= v[1] and getPlayerLevel(cid) < v[2] then -- 2
if (table.maxn(summons) < 1)then -- 3
x = doSummonCreature(k, getCreaturePosition(cid))
doConvinceCreature(cid, x)
setPlayerStorageValue(cid,11548,os.time()+30)
doCreatureSay(cid, "Trainer, Go!", TALKTYPE_ORANGE_1)
doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 2)
doRemoveItem(item.uid, 1)
end
end
end


end
return true
end