function onUse(cid, item, fromPosition, itemEx, toPosition)
if itemEx.itemid == 6075 then
doTransformItem(itemEx.uid, 3610)
doDecayItem(itemEx.uid)
return TRUE
end
return destroyItem(cid, itemEx, toPosition)
end