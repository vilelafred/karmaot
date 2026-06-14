function onSay(cid, words, param)
    if param == "" then
        return false
    end

    local player = Player(param)
    if not player then
        Player(cid):sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player '" .. param .. "' not found or not online.")
        return false
    end

    local result = "[CHECKPLAYER] "..player:getName().."\n"
    result = result .. "Level: " .. player:getLevel() .. " (" .. player:getExperience() .. " XP)\n"
    result = result .. "Vocation: " .. player:getVocation():getName() .. "\n"
    result = result .. "Magic Level: " .. player:getMagicLevel() .. "\n"
    result = result .. "Skills:\n"
    result = result .. " • Fist: " .. player:getSkillLevel(SKILL_FIST) .. "\n"
    result = result .. " • Club: " .. player:getSkillLevel(SKILL_CLUB) .. "\n"
    result = result .. " • Sword: " .. player:getSkillLevel(SKILL_SWORD) .. "\n"
    result = result .. " • Axe: " .. player:getSkillLevel(SKILL_AXE) .. "\n"
    result = result .. " • Distance: " .. player:getSkillLevel(SKILL_DISTANCE) .. "\n"
    result = result .. " • Shielding: " .. player:getSkillLevel(SKILL_SHIELD) .. "\n"
    result = result .. " • Fishing: " .. player:getSkillLevel(SKILL_FISHING) .. "\n"
    result = result .. "Gold: " .. player:getMoney() .. " gp\n"
    result = result .. "Bank Balance: " .. player:getBankBalance() .. " gp\n"
    result = result .. "IP: " .. Game.convertIpToString(player:getIp()) .. "\n"
    result = result .. "Ping: " .. player:getPing() .. " ms\n"
    result = result .. "Position: " .. player:getPosition():getDescription() .. "\n"

    result = result .. "\nStorages:\n"
    local storages = {1000, 2000, 3000, 5000, 9001, 15000, 21000, 40000} -- adicione aqui os IDs relevantes do seu servidor
    for _, storage in pairs(storages) do
        local value = player:getStorageValue(storage)
        if value and value > -1 then
            result = result .. " • [" .. storage .. "] = " .. value .. "\n"
        end
    end

    Player(cid):popupFYI(result)
    return false
end
