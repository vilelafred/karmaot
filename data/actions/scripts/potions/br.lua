local config = {

money = 1000, -- Dinheiro que vai custar

item = 2260, -- ID do item que vai vender

count = 100, -- Quantidade

}


function onUse(cid, item, fromPosition, itemEx, toPosition)

local player = Player(cid)

pos = getCreaturePosition(cid)


if item:transform(item.itemid == 1945 and 1946 or 1945) then

if player and player:removeTotalMoney(config.money) then

doPlayerAddItem(cid, config.item, config.count)

doSendMagicEffect(pos, CONST_ME_MAGIC_BLUE)

else

doPlayerSendTextMessage(cid,22,"You need 1000 gps to buy 100 blank runes!")

doSendMagicEffect(pos, CONST_ME_POFF)

end

end


end