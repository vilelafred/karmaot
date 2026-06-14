function onSay(player, words, param)
if player:getStorageValue(274545) < 1 then
player:setStorageValue(274545, 1)
end
return false
end