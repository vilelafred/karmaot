local UPGRADE_COST = 200000000 -- 200kk

-- Mapeia itens base -> item +2
-- IDs base foram informados pelo usuário
-- Itens +2 também foram informados (ou já existentes no items.xml):
-- armor +2: 6489, legs +2: 6487, cape/robe +2: 6486, hat +2: 6168? (o usuário citou somente nome, mas veremos por segurança)
-- weapons: hammer +2: 6523, axe +2: 6522, sword +2: 6198, staff +2: 6197, spellbook +2: 5897, shield +2: 6488?, bow +2: 6175?, crossbow +2: 5792?
-- Observação: usaremos explicitamente os IDs fornecidos no chat para os +2. Para os base, também foram fornecidos.

-- One lever per upgrade. Configure here: actionId -> {baseItemId, resultItemId}
local leverUpgrades = {
    -- Armor pieces
    [46010] = {6127, 6489}, -- Karma Armor -> +2 ok
    [46011] = {6176, 6487}, -- Karma Legs -> +2 ok
    [46012] = {6167, 6485}, -- Karma Hat -> Karma Cape/Robe +2 (adjust if needed) ok

	
    -- Magic/offhand
    [46013] = {7630, 5897}, -- Karma Spellbook -> +2 ok
    [46014] = {6196, 6197}, -- Karma Staff -> +2 ok
    [46015] = {6128, 6494}, -- Karma Shield -> +2 ok
    [46016] = {6161, 6550}, -- Karma Amulet -> +2 ok

    -- Weapons
    [46017] = {6221, 6523}, -- Karma Hammer -> +2 ok
    [46018] = {6225, 6522}, -- Karma Axe -> +2 ok
    [46019] = {6118, 6198}, -- Karma Sword -> +2 ok

    -- Distance
    [46020] = {6174, 6474}, -- Karma Bow -> +2 ok
    [46021] = {5791, 6415}, -- Karma Crossbow -> +2 ok
    [46022] = {5818, 6486}, -- Karma Robe ok
    [46023] = {6491, 6490}, -- Karma ranger armor ok	
    [46024] = {6514, 6513}, -- Karma ranger shield ok		
}

local function getItemNameSafe(itemId)
    local t = ItemType(itemId)
    return t and t:getName() or ("item " .. tostring(itemId))
end

local function hasEnoughMoney(player)
    return (player:getMoney() + player:getBankBalance()) >= UPGRADE_COST
end

local function canUpgrade(player, baseId, resultId)
    if not resultId or resultId == 0 then
        return false, "This option is not configured (missing +2 item ID)."
    end
    if player:getItemCount(baseId) < 5 then
        return false, "You need 5x " .. getItemNameSafe(baseId) .. "."
    end
    if not hasEnoughMoney(player) then
        return false, "You need 200kk to perform this trade."
    end
    return true
end

local function playEffects(player, leverPos)
    local playerPos = player:getPosition()
    leverPos:sendMagicEffect(CONST_ME_ENERGYHIT)
    leverPos:sendDistanceEffect(playerPos, CONST_ANI_ENERGY)
    playerPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
end

local function performUpgrade(player, baseId, resultId, leverPos)
    -- Remove items first, then gold. Refund items if gold removal fails.
    if not player:removeItem(baseId, 5) then
        player:sendCancelMessage("Failed to remove base items.")
        return false
    end

    if not player:removeTotalMoney(UPGRADE_COST) then
        -- refund items
        player:addItem(baseId, 5)
        player:sendCancelMessage("You do not have enough gold (200kk).")
        return false
    end

    local added = player:addItem(resultId, 1)
    if not added then
        local tile = Tile(player:getPosition())
        if tile then
            added = tile:addItem(resultId, 1)
        end
    end

    if added then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You obtained 1x " .. getItemNameSafe(resultId) .. " by trading 5x " .. getItemNameSafe(baseId) .. " + 200kk.")
        playEffects(player, leverPos)
        return true
    end

    -- If adding failed entirely, refund both
    player:addItem(baseId, 5)
    player:setBankBalance(player:getBankBalance() + UPGRADE_COST)
    player:sendCancelMessage("Not enough capacity/space. Try again.")
    return false
end

local function buildOptionsList()
    local options = {}
    for baseId, resultId in pairs(upgrades) do
        if resultId ~= 0 then
            table.insert(options, { baseId = baseId, resultId = resultId, text = "To obtain " .. getItemNameSafe(resultId) .. " you need: 5x " .. getItemNameSafe(baseId) .. " + 200kk." })
        end
    end
    table.sort(options, function(a, b) return a.text < b.text end)
    return options
end

local function openConfirmWindow(player, baseId, resultId, leverPos)
    local msg = "To obtain " .. getItemNameSafe(resultId) .. " you need: 5x " .. getItemNameSafe(baseId) .. " + 200kk. Proceed?"
    local window = ModalWindow({})
    window:setTitle("Karma +2 Upgrade")
    window:setMessage(msg)
    window:addButtons("Confirm", "Cancel")
    window:setDefaultEnterButton("Confirm")
    window:setDefaultEscapeButton("Cancel")

    window:setDefaultCallback(function(button)
        if not button or button.text ~= "Confirm" then
            return
        end
        local ok, err = canUpgrade(player, baseId, resultId)
        if not ok then
            player:sendCancelMessage(err)
            leverPos:sendMagicEffect(CONST_ME_POFF)
            return
        end
        performUpgrade(player, baseId, resultId, leverPos)
    end)

    window:sendToPlayer(player)
    return true
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Toggle lever state for standard levers
    if item.itemid == 1945 then
        item:transform(1946)
    elseif item.itemid == 1946 then
        item:transform(1945)
    end

    local aid = item.actionid
    local cfg = leverUpgrades[aid]
    if not cfg then
        player:sendCancelMessage("This lever is not configured.")
        item:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local baseId, resultId = cfg[1], cfg[2]
    return openConfirmWindow(player, baseId, resultId, item:getPosition())
end


