local config = {

money = 12000, -- Dinheiro que vai custar

item = 5274, -- ID do item que vai vender

count = 100, -- Quantidade

}


function onUse(cid, item, fromPosition, itemEx, toPosition)

pos = getCreaturePosition(cid)


if item:transform(item.itemid == 1945 and 1946 or 1945) then

if doPlayerRemoveMoney(cid, config.money) == TRUE then

doPlayerAddItem(cid, config.item, config.count)

doSendMagicEffect(pos, CONST_ME_MAGIC_BLUE)

else

doPlayerSendTextMessage(cid,22,"Voce precisa de 12k para comprar 100 health potion!")

doSendMagicEffect(pos, CONST_ME_POFF)

end

end


end