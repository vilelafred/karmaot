local addpoints = 10 -- amount of points to add
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
if isPlayer(player) and item:remove() then
db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + "..addpoints.." WHERE `id` = '" ..getAccountNumberByPlayerName(player:getName()).. "';")
doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, ""..addpoints.." premium points have been added to your account.")
player:sendTextMessage(MESSAGE_INFO_DESCR, "10 Premium Points added to your account!")
return true
end
end