local function listContainerItemIds(container)
    local ids = {}
    if not container then return ids end
    for i = 0, math.max(0, container:getSize() - 1) do
        local it = container:getItem(i)
        if it then table.insert(ids, it:getId()) end
    end
    return ids
end

local function moveContainerContents(fromContainer, toContainer)
    if not fromContainer or not toContainer then
        return {}
    end
    local movedIds = {}
    for i = fromContainer:getSize() - 1, 0, -1 do
        local item = fromContainer:getItem(i)
        if item then
            table.insert(movedIds, item:getId())
            item:moveTo(toContainer)
        end
    end
    return movedIds
end

local function getPreferredDepotChest(player)
    local depotId = 0
    local town = player:getTown()
    if town then
        depotId = town:getId()
    else
        depotId = player.getTownId and player:getTownId() or 1
    end
    local depotChest = player:getDepotChest(depotId, true)
    return depotChest
end

function onLogin(player)
    -- Pequeno delay: garante que entregas do Market que acontecem no login
    -- sejam processadas antes de mover o conteúdo da Inbox.
    addEvent(function(pid)
        local pl = Player(pid)
        if not pl then return end

        local inbox = pl:getInbox()
        if not inbox then return end

        local depotChest = getPreferredDepotChest(pl)
        if not depotChest then return end

        local town = pl:getTown()
        local depotId = town and town:getId() or (pl.getTownId and pl:getTownId() or 1)
        local movedIds = moveContainerContents(inbox, depotChest)
        local moved = #movedIds
        if moved > 0 then
            local idStrings = {}
            for _, id in ipairs(movedIds) do idStrings[#idStrings+1] = tostring(id) end
            print("[InboxToDepotOnLogin] player=" .. pl:getName() .. " townId=" .. depotId .. " moved=" .. moved .. " item(s) [ids=" .. table.concat(idStrings, ",") .. "] from inbox to depot")
        end

        -- Diagnóstico: escanear depots 1..20 procurando itens (para casos de market offline)
        for did = 1, 20 do
            local chest = pl:getDepotChest(did, true)
            if chest and chest:getSize() > 0 then
                local ids = listContainerItemIds(chest)
                if #ids > 0 then
                    local idStrings = {}
                    for _, id in ipairs(ids) do idStrings[#idStrings+1] = tostring(id) end
                    print("[DepotScan] player=" .. pl:getName() .. " depotId=" .. did .. " size=" .. chest:getSize() .. " ids=" .. table.concat(idStrings, ","))
                end
            end
        end
    end, 150, player:getId())
    return true
end


