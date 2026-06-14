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
            local ok = item:moveTo(toContainer)
            if ok == false then
                print("[InboxToDepotOnLogin][WARN] moveTo failed for itemId=" .. item:getId())
            end
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

local function scheduleInboxMoves(player, delays)
    local pid = player:getId()
    for _, delay in ipairs(delays) do
        addEvent(function(p)
            local pl = Player(p)
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
                print("[InboxToDepotOnLogin] player=" .. pl:getName() .. " townId=" .. depotId .. " moved=" .. moved .. " item(s) [ids=" .. table.concat(idStrings, ",") .. "] from inbox to depot (delay=" .. delay .. "ms)")
            else
                print("[InboxToDepotOnLogin] player=" .. pl:getName() .. " townId=" .. depotId .. " moved=0 (delay=" .. delay .. "ms) inboxSize=" .. inbox:getSize())
            end

            -- Diagnóstico: escanear depots 1..20
            for did = 1, 20 do
                local chest = pl:getDepotChest(did, true)
                if chest and chest:getSize() > 0 then
                    local ids = listContainerItemIds(chest)
                    if #ids > 0 then
                        local idStrings = {}
                        for _, id in ipairs(ids) do idStrings[#idStrings+1] = tostring(id) end
                        local cap = chest.getCapacity and chest:getCapacity() or -1
                        print("[DepotScan] player=" .. pl:getName() .. " depotId=" .. did .. " size=" .. chest:getSize() .. "/" .. tostring(cap) .. " ids=" .. table.concat(idStrings, ","))
                    end
                end
            end
        end, delay, pid)
    end
end

function onLogin(player)
    -- Pequeno delay: garante que entregas do Market que acontecem no login
    -- sejam processadas antes de mover o conteúdo da Inbox.
    scheduleInboxMoves(player, {150, 1000, 3000})
    return true
end


