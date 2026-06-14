local ec = EventCallback

local lootColors = {
    {chance = 100, color = '#FF0000'},
    {chance = 1000, color = '#FF8000'},
    {chance = 5000, color = '#FF00FF'},
    {chance = 10000, color = '#0000FF'},
    {chance = 25000, color = '#00FFFF'},
    {chance = 50000, color = '#00FF00'},
    {chance = 75000, color = '#AAAA00'},
    {chance = 90000, color = '#CCCCCC'},
    {chance = 100000, color = '#FFFF00'},
    {chance = math.huge, color = '#FFFFF1'}
}

local function getLootColor(dropChance)
    for _, lootTier in ipairs(lootColors) do
        if dropChance < lootTier.chance then
            return lootTier.color
        end
    end
    return '#FFFFFF'
end

local function colorize(text, color)
    return string.format("[#%s]%s[/#]", color:sub(2), text)
end

ec.onDropLoot = function(self, corpse)
    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then return end

    local player = Player(corpse:getCorpseOwner())
    if not player then return end

    local mType = self:getType()
    local lootText = {}
    local monsterLoot = mType:getLoot()

    if player:getStamina() > 840 then
        for _, loot in ipairs(monsterLoot) do
            if math.random(100000) <= loot.chance then
                local itemId = loot.itemId
                local itemType = ItemType(itemId)
                local count = 1
                local subType = loot.subType or -1

                if itemType:isStackable() then
                    count = math.max(1, loot.maxCount and math.random(loot.maxCount) or 1)
                end

                if itemType:isFluidContainer() or (itemType.isSplash and itemType:isSplash()) then
                    subType = loot.subType or 0
                end
                local item = corpse:addItem(itemId, count, subType)

                if item then
                    local name = item:getName()
                    local amount = itemType:isStackable() and item:getCount() > 1 and (" x" .. item:getCount()) or ""
                    local color = getLootColor(loot.chance)
                    table.insert(lootText, colorize(name .. amount, color))
                else
                    print(string.format("[LootDebug] [FAIL] Could not add itemId %d (%s) to corpse.", itemId, itemType:getName()))
                end
            end
        end

        local fullLine = string.format("Loot of %s: %s", mType:getNameDescription(), #lootText > 0 and table.concat(lootText, ", ") or "nothing")

        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(fullLine)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, fullLine)
        end
    else
        local text = string.format("Loot of %s: nothing (due to low stamina)", mType:getNameDescription())
        print("[LootDebug] Skipped loot due to low stamina")
        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, text)
        end
    end
end

ec:register()