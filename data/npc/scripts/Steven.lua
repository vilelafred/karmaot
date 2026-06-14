dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)          end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)       end
function onCreatureSay(cid, type, msg)  npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()                      npcHandler:onThink()                      end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

local function creatureSayCallback(cid, type, msg)
    -- ... (rest of the function)

    if msgcontains(msg, 'change') then
        local shardsToChange = 100  -- Quantidade padrão para trocar
        if msgcontains(msg, 'all') then
            -- Se o jogador diz "change all", troca todas as Mystic Shards que ele tem
            shardsToChange = getPlayerItemCount(cid, 8176)
        end

        -- Verifica se o jogador tem pelo menos 100 Mystic Shards
        if shardsToChange < 100 then
            npcHandler:say('You need at least 100 mystic shards to make a change with me.')
            return
        end

        -- Check se o jogador tem a quantidade necessária
        if getPlayerItemCount(cid, 8176) >= shardsToChange then
            -- Remove as Mystic Shards do inventário do jogador
            doPlayerRemoveItem(cid, 8176, shardsToChange)

            -- Adiciona a quantidade correta de Mystic Ore ao inventário do jogador
            local oreCount = math.floor(shardsToChange / 100)  -- Calcula a quantidade de Mystic Ore
            for i = 1, oreCount do
                doPlayerAddItem(cid, 5937, 1)
            end
            
            if oreCount > 1 then
                npcHandler:say('I just changed ' .. shardsToChange .. ' mystic shards for ' .. oreCount .. ' mystic ore. Thanks')
            else
                npcHandler:say('I just changed ' .. shardsToChange .. ' mystic shards for 1 mystic ore. Thanks')
            end
        else
            npcHandler:say('You don\'t have enough mystic shards to change with me.')
        end
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
