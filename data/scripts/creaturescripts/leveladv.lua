-- Advance rewards (Nekiro TFS 1.5)
-- Dá itens ao atingir certos níveis e só 1x por personagem.

-- Helper: verifica se um valor está numa lista
local function contains(t, v)
    for i = 1, #t do
        if t[i] == v then return true end
    end
    return false
end

-- Listas de vocações (ids padrão 1..8)
local rookVocations     = { 0 }
local sorcererVocations = { 1, 5 }
local druidVocations    = { 2, 6 }
local paladinVocations  = { 3, 7 }
local knightVocations   = { 4, 8 }
local mainVocations     = { 1, 2, 3, 4, 5, 6, 7, 8 }
-- local allVocations   = { 1, 2, 3, 4, 5, 6, 7, 8, 9 } -- não usado

local rewardsConfig = {
    -- SORCERER
    {
        level = 9, vocations = sorcererVocations, storage = 25110,
        items = { {2190, 1} } -- Wand of Vortex
    },
    {
        level = 13, vocations = sorcererVocations, storage = 25111,
        items = { {2191, 1} } -- Wand of Dragonbreath
    },
    {
        level = 20, vocations = sorcererVocations, storage = 25112,
        items = { {2160, 1} } -- Crystal Coin
    },
    {
        level = 26, vocations = sorcererVocations, storage = 25113,
        items = { {2189, 1} } -- Wand of Cosmic Energy
    },
    {
        level = 33, vocations = sorcererVocations, storage = 25114,
        items = { {2187, 1} } -- Wand of Inferno
    },

    -- DRUID
    {
        level = 9, vocations = druidVocations, storage = 25120,
        items = { {2182, 1} } -- Snakebite Rod
    },
    {
        level = 13, vocations = druidVocations, storage = 25121,
        items = { {2186, 1} } -- Moonlight Rod
    },
    {
        level = 20, vocations = druidVocations, storage = 25122,
        items = { {2160, 1}, {2185, 1} } -- Crystal Coin, Volcanic/Necrotic Rod (ajuste o nome conforme seu client)
    },
    {
        level = 33, vocations = druidVocations, storage = 25123,
        items = { {2183, 1} } -- Tempest/Hailstorm Rod (ajuste nome)
    },

    -- KNIGHT
    {
        level = 10, vocations = knightVocations, storage = 25130,
        items = { {2409, 1} } -- Serpent Sword
    },
    {
        level = 20, vocations = knightVocations, storage = 25131,
        items = { {2434, 1}, {2160, 1} } -- Dragon Hammer, Crystal Coin
    },
    {
        level = 30, vocations = knightVocations, storage = 25132,
        items = { {6675, 100}, {2391, 1} } -- UH(100), War Hammer
    },
    {
        level = 50, vocations = knightVocations, storage = 25133,
        items = { {2475, 1} } -- Warrior Helmet
    },

    -- PALADIN
    {
        level = 10, vocations = paladinVocations, storage = 25140,
        items = { {2456, 1}, {2544, 50} } -- Bow, Arrows(50)
    },
    {
        level = 20, vocations = paladinVocations, storage = 25141,
        items = { {2547, 100}, {2455, 1}, {2160, 1} } -- Power Bolt(100), Crossbow, Crystal Coin
    },
    {
        level = 30, vocations = paladinVocations, storage = 25142,
        items = { {6675, 100}, {7590, 1} } -- UH(100), (7590 = GMP; ajuste ID se seu "Modified Crossbow" for outro)
    },
    {
        level = 50, vocations = paladinVocations, storage = 25143,
        items = { {7696, 100} } -- Assassin Star(100)
    },

    -- GENÉRICO (todas as vocações principais)
    {
        level = 100, vocations = mainVocations, storage = 25100,
        items = { {6155, 1}, {2160, 10} } -- Book of training, 10 Crystal Coins
    },
}

-- Evento de advance
local advanceReward = CreatureEvent("AdvanceReward")

function advanceReward.onAdvance(player, skill, oldLevel, newLevel)
    if skill ~= SKILL_LEVEL then
        return true
    end

    local vocId = player:getVocation():getId()

    for i = 1, #rewardsConfig do
        local cfg = rewardsConfig[i]
        if newLevel >= cfg.level and contains(cfg.vocations, vocId) then
            if player:getStorageValue(cfg.storage) < 1 then
                player:setStorageValue(cfg.storage, os.time())
                for j = 1, #cfg.items do
                    local iid, count = cfg.items[j][1], cfg.items[j][2]
                    player:addItem(iid, count)
                end
                player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
                    string.format("You received a reward for reaching level %d.", cfg.level))
            end
        end
    end

    return true
end

advanceReward:register()

-- Garanta que todos os players registrem o evento no login
local login = CreatureEvent("AdvanceRewardRegister")

function login.onLogin(player)
    player:registerEvent("AdvanceReward")
    return true
end

login:register()
