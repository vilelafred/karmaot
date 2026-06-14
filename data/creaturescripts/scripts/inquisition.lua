local config = {
    bosses = {
        ["Ushuriel"] = { pos = Position(33264, 31340, 10), aid = 1001 },
        ["Zugurosh"] = { pos = Position(33234, 31337, 10), aid = 1002 },
        ["Madareth"] = { pos = Position(33192, 31351, 10), aid = 1003 },
        ["Annihilon"] = { pos = Position(33282, 31353, 10), aid = 1005 },
        ["Hellgorak"] = { pos = Position(33246, 31364, 10), aid = 1006 }
    },
    brothers = {
        ["Golgordan"] = { pos = Position(33221, 31359, 10), aid = 1004, brother = "Latrivan" },
        ["Latrivan"] = { pos = Position(33221, 31359, 10), aid = 1004, brother = "Golgordan" }
    },
    portalId = 1387,
    timeToRemove = 180
}

local function removal(teleport)
    if teleport and teleport:isItem() then
        teleport:remove()
    end
    return true
end

function onKill(player, target)
    if not player or not target or not target:isMonster() then
        return true
    end
    
    local monsterName = target:getName()
    print("DEBUG: Monster morto: " .. monsterName)
    
    if config.bosses[monsterName] then
        local t = config.bosses[monsterName]
        local teleport = Game.createItem(config.portalId, 1, t.pos)
        
        if teleport then
            teleport:setActionId(t.aid)
            player:say("You now have 3 minutes to exit this room through the teleporter.", TALKTYPE_MONSTER_SAY)
            print("DEBUG: Teleporte criado para " .. monsterName)
            addEvent(removal, config.timeToRemove * 1000, teleport)
        end
        
    elseif config.brothers[monsterName] then
        local t = config.brothers[monsterName]
        local brother = Monster(t.brother)
        
        if brother and brother:isMonster() then
            print("DEBUG: Brother ainda vivo")
            return true
        else
            local teleport = Game.createItem(config.portalId, 1, t.pos)
            
            if teleport then
                teleport:setActionId(t.aid)
                player:say("You now have 3 minutes to exit this room through the teleporter.", TALKTYPE_MONSTER_SAY)
                print("DEBUG: Teleporte criado para " .. monsterName)
                addEvent(removal, config.timeToRemove * 1000, teleport)
            end
        end
    end
    
    return true
end 