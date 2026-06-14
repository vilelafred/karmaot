function onUse(cid, item, fromPosition, itemEx, toPosition)
local tempo = 20 -- Tempo em segundos para usar o Item novamente.
local storage = 5839 -- Storage 
local roupa = 667 -- Numero da roupa que você quer que mude

if exhaustion.check(cid, storage) then
doPlayerSendTextMessage(cid, 19, "Aguarde " .. exhaustion.get(cid, storage) .. " segundos para usar a spell novamente.")
return false
end

doCreatureChangeOutfit(cid, {lookType = roupa})
exhaustion.set(cid, storage, tempo)
end