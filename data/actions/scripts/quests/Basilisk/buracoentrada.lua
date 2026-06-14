function onUse(cid, item, fromPosition, item2, toPosition)

local teleport = {x=32721, y=31967, z=12} -- Coordenadas para onde o player irá ser teleportado.

local item_id = 4874  -- ID do item que o player precisa para ser teleportado.


if getPlayerItemCount(cid,item_id) >= 1 then

doCreatureSay(v, "you found a secret passage.", 1)
doTeleportThing(cid, teleport)
doSendMagicEffect(getPlayerPosition(cid), 4)
doPlayerSendTextMessage(cid, 22, "you found a secret passage.")


else

doPlayerSendTextMessage(cid, 23, "nothing here")

end

end