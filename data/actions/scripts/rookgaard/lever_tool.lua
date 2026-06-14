function onUse(cid, item, fromPosition, itemEx, toPosition)

    if item.itemid == 1945 then
        doTransformItem(item.uid, item.itemid+1)
    else
        doTransformItem(item.uid, item.itemid-1)
    end

    local posPlayer = getPlayerPosition(cid)

    local firstItem = 6823
    local firstItemCount = 10
    local secondItem = 6824
    local secondItemCount = 100
    local thirdItem = 2557
    local thirdItemCount = 1
    
    -- Positions
	local pos1 = Position(32097, 32136, 7)
	local pos2 = Position(32098, 32136, 7)
    local pos3 = Position(32099, 32136, 7)

    -- Position items
    local firstPosItem = Tile(pos1):getTopVisibleThing().itemid
    local firstPosItemCount = Tile(pos1):getTopVisibleThing().type

    local secondPosItem = getTileItemById(pos2, secondItem).itemid
    local secondPosItemCount = Tile(pos2):getTopVisibleThing().type

    local thirdPosItem = getTileItemById(pos3, thirdItem).itemid
    local thirdPosItemCount = Tile(pos3):getTopVisibleThing().type

    if firstItem == firstPosItem and firstPosItemCount >= firstItemCount and 
    secondItem == secondPosItem and secondPosItemCount >= secondItemCount and 
    thirdItem == thirdPosItem and thirdPosItemCount >= thirdItemCount then
        Tile(pos1):getTopVisibleThing():remove()
        Tile(pos2):getTopVisibleThing():remove()
        Tile(pos3):getTopVisibleThing():remove()
        doSendMagicEffect(posPlayer, 15)
        doPlayerAddItem(cid, 6825, 1)
        doPlayerSendTextMessage(cid, 22, "You made an important tool.")
    else
        doSendMagicEffect(posPlayer, 3)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need 10x woods (first), 100x nails (second) and 1x hammer (third).")
    end


end