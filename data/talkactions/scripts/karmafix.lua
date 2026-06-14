-- ===================================================
-- FIX OLD KARMA AMULETS - Remove descrições bugadas
-- ===================================================
-- Comando: /karmafix
-- Atualiza todos os Karma Amulets no inventário do player

function onSay(player, words, param)
    -- Verificar se é GM/Admin
    if not player:getGroup():getAccess() then
        player:sendCancelMessage("You don't have permission to use this command.")
        return false
    end
    
    local karmaAmuletIds = {6161, 6550, 6525}
    local fixed = 0
    
    -- Função para limpar a descrição de um item
    local function cleanKarmaAmulet(item)
        if not item then return false end
        
        local itemId = item:getId()
        local isKarma = false
        for _, id in ipairs(karmaAmuletIds) do
            if itemId == id then
                isKarma = true
                break
            end
        end
        
        if not isKarma then return false end
        
        -- Pegar stones do item
        local data = item:getCustomAttribute("karma_stones")
        local stones = {}
        
        if data and data ~= "" then
            local success, decoded = pcall(json.decode, data)
            if success and type(decoded) == "table" then
                stones = decoded
            end
        end
        
        -- Atualizar descrição (vai remover stones com < 60s)
        local baseDesc = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or ""
        baseDesc = baseDesc:gsub("\n%[.-%]", "")
        baseDesc = baseDesc:gsub("\n• .*", "")
        
        local stoneText = ""
        local hasActive = false
        
        for _, stone in pairs(stones) do
            if stone.remaining and stone.remaining > 60 then
                hasActive = true
                local element = stone.element or "unknown"
                local def = stone.def or 0
                local hours = math.floor(stone.remaining / 3600)
                local mins = math.floor((stone.remaining % 3600) / 60)
                local timeLeft = string.format("%dh%02dm", hours, mins)
                stoneText = stoneText .. string.format("\n[%s: +%d%% - %s]", 
                    element:sub(1,1):upper() .. element:sub(2), def, timeLeft)
            end
        end
        
        if hasActive and stoneText ~= "" then
            item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc .. stoneText)
        else
            item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, baseDesc)
        end
        
        return true
    end
    
    -- Verificar slots equipados
    for slotId = CONST_SLOT_FIRST, CONST_SLOT_LAST do
        local item = player:getSlotItem(slotId)
        if item then
            if cleanKarmaAmulet(item) then
                fixed = fixed + 1
            end
            
            -- Verificar dentro de containers
            if item:isContainer() then
                local containers = {item}
                while #containers > 0 do
                    local container = table.remove(containers, 1)
                    for i = 0, container:getSize() - 1 do
                        local containerItem = container:getItem(i)
                        if containerItem then
                            if cleanKarmaAmulet(containerItem) then
                                fixed = fixed + 1
                            end
                            if containerItem:isContainer() then
                                table.insert(containers, containerItem)
                            end
                        end
                    end
                end
            end
        end
    end
    
    if fixed > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            string.format("[Karma Fix] Fixed %d Karma Amulet(s)! Expired stones removed.", fixed))
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "[Karma Fix] No Karma Amulets found or all are already clean.")
    end
    
    return false
end

