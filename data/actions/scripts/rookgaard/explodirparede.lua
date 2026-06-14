function onUse(cid, item, fromPosition, item2, toPosition)

local teleport = {x=32168, y=32147, z=11} -- Coordenadas para onde o player irá ser teleportado.

local item_id = 6150  -- ID do item que o player precisa para ser teleportado.


if getPlayerItemCount(cid,item_id) >= 1 then

doCreatureSay(v, "you found a secret passage.", 1)
doTeleportThing(cid, teleport)
doSendMagicEffect(getPlayerPosition(cid), 8)
doPlayerSendTextMessage(cid, 22, "you found a secret passage.")


else

doPlayerSendTextMessage(cid, 23, "nothing here")

end

end