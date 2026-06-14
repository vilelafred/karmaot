-- ===================================================
-- KARMA AMULET DEBUG - Mostra atributos salvos
-- ===================================================
-- Comando: /karmadebug
-- Mostra todos os dados salvos no Karma Amulet equipado

function onSay(player, words, param)
    -- Verificar se é GM/Admin
    if not player:getGroup():getAccess() then
        player:sendCancelMessage("You don't have permission to use this command.")
        return false
    end
    
    -- Verificar se tem Karma Amulet equipado
    local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
    if not amulet then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 
            "[Karma Debug] No amulet equipped!")
        return false
    end
    
    local karmaAmuletIds = {6161, 6550, 6525}
    local isKarma = false
    for _, id in ipairs(karmaAmuletIds) do
        if amulet:getId() == id then
            isKarma = true
            break
        end
    end
    
    if not isKarma then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 
            "[Karma Debug] Equipped item is not a Karma Amulet!")
        return false
    end
    
    -- Pegar o custom attribute RAW
    local rawData = amulet:getCustomAttribute("karma_stones")
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "========================================")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "KARMA AMULET DEBUG")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "========================================")
    
    if not rawData or rawData == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 
            "Custom Attribute: EMPTY (no stones saved)")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "========================================")
        return false
    end
    
    -- Mostrar JSON RAW
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 
        "RAW JSON Data:")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 
        rawData)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "----------------------------------------")
    
    -- Tentar decodificar
    local success, decoded = pcall(json.decode, rawData)
    
    if not success then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 
            "ERROR: Failed to decode JSON!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "========================================")
        return false
    end
    
    if type(decoded) ~= "table" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 
            "ERROR: Decoded data is not a table!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "========================================")
        return false
    end
    
    -- Mostrar cada stone decodificada
    local stoneCount = 0
    local activeCount = 0
    
    for slotNum, stone in pairs(decoded) do
        stoneCount = stoneCount + 1
        local element = stone.element or "unknown"
        local def = stone.def or 0
        local remaining = stone.remaining or 0
        
        local status = "EXPIRED"
        if remaining > 60 then
            status = "ACTIVE"
            activeCount = activeCount + 1
        elseif remaining > 0 then
            status = "EXPIRING (<60s)"
        end
        
        local hours = math.floor(remaining / 3600)
        local mins = math.floor((remaining % 3600) / 60)
        local secs = remaining % 60
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 
            string.format("Stone #%s: %s +%d%% | %dh%02dm%02ds (%d seconds) [%s]", 
                slotNum, element, def, hours, mins, secs, remaining, status))
    end
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "----------------------------------------")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        string.format("Total Stones: %d | Active (>60s): %d", stoneCount, activeCount))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
        "========================================")
    
    -- Verificação de segurança
    if activeCount == 0 and stoneCount > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 
            "WARNING: Item has expired stones that should be removed!")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "Use /karmafix to clean them up.")
    end
    
    return false
end

