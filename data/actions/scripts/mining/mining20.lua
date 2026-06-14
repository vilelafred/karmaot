local cfg = {
    chance = 20,            -- chance that the player will succeed in getting the ore
    level = 20,            -- level required to mine
    skill = SKILL_AXE,      -- skill required to mine
    skillStr = ' axe',      -- string for skill name | note: add a space before skill name
    skillReq = 10,          -- required level for skill
    stage2Regen = 4 * 1000, -- 3 seconds
    stage3Regen = 2 * 1000, -- 2 seconds
    ores = {
        -- {ore = ore id, amount = {minimum, maximum}, veins = {stage 1 (highest), stage 2, stage 3 (optional)}}
        {ore = 8144, amount = {1, 1}, veins = {1330, 1309}}, -- white crystal -- kazz, venore, thais, edron...
        {ore = 8145, amount = {1, 1}, veins = {6003, 5999}}, -- blue crystal -- svarground
        {ore = 8146, amount = {1, 1}, veins = {6001, 5999}}, -- purple crystal -- liberty bay
        {ore = 8147, amount = {1, 1}, veins = {6012, 6013}}, -- red crystal -- edron
        {ore = 8148, amount = {1, 1}, veins = {6010, 6013}}, -- yellow crystal -- yalahar
        {ore = 8149, amount = {1, 1}, veins = {6011, 6013}} -- green cyrstal -- alva
    }
}
 
local function isInTable(value)
    for i = 1, #cfg.ores do
        for j = 1, #cfg.ores[i].veins do
            if cfg.ores[i].veins[j] == value then
                return i, j -- Return ore row and vein index
            end
        end
    end
    return false
end
 
local regenerating = {}
 
local function regenVein(pos, id, row, index)
    local item = Tile(pos):getItemById(id)
    if not item then
        return false
    end
    local currOre = cfg.ores[row]
    local transformId = currOre.veins[index]
    item:transform(transformId)
    if currOre.veins[index-1] then
        regenerating[pos] = addEvent(regenVein, cfg.stage3Regen, pos, transformId, row, index-1)
    end
end
 
local failureMessage = 'Your pickaxe lacks the strength to break through this time. Try again!'

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local row, vein = isInTable(target:getId())
    if (row and vein) then
        local playerPos = player:getPosition()
        local currOre = cfg.ores[row]
 
        -- Check player skill level
        if not (player:getSkillLevel(cfg.skill) >= cfg.skillReq) then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You must have '.. cfg.skillReq .. cfg.skillStr ..' before you may mine.')
            return true
        end
         
        -- Check player level
        if not (player:getLevel() >= cfg.level) then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You must have '.. cfg.level ..' level before you may mine.')
            return true
        end
 
        -- If the vein is at the last stage, tell the player to wait
        if #currOre.veins == vein then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You must wait for this vein to regen.')
            playerPos:sendMagicEffect(CONST_ME_POFF)
            return true
        end
 
        -- Stop current regeneration process (since the player hit the rock again)
        if regenerating[toPosition] then
            stopEvent(regenerating[toPosition])
        end
 
        -- If chance is correct, add the item to the player and start regeneration process
        if math.random(100) <= cfg.chance then
            local nextId = currOre.veins[vein+1]
            player:addItem(currOre.ore)
            toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
            regenerating[toPosition] = addEvent(regenVein, (vein == 2) and cfg.stage2Regen or cfg.stage3Regen, toPosition, nextId, row, vein)
            target:transform(nextId)
			else
			  player:sendTextMessage(MESSAGE_STATUS_SMALL, failureMessage)
			  playerPos:sendMagicEffect(CONST_ME_POFF)
			end
 
    end
    return true
end