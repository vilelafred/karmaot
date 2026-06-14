dofile('data/npc/lib/greeting.lua')

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- OTServ event handling functions
function onCreatureAppear(cid)         npcHandler:onCreatureAppear(cid)         end
function onCreatureDisappear(cid)      npcHandler:onCreatureDisappear(cid)      end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                     npcHandler:onThink()                     end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- Outfit Items for Sale
shopModule:addBuyableItem({'new citizen'}, 6699, 3000000, 0, 'new citizen outfit full addons')
shopModule:addBuyableItem({'yalaharian'}, 6700, 4000000, 0, 'yalaharian outfit full addons')
shopModule:addBuyableItem({'new hunter'}, 6701, 3000000, 0, 'new hunter outfit full addons')
shopModule:addBuyableItem({'pirate'}, 6702, 6000000, 0, 'pirate outfit full addons')
shopModule:addBuyableItem({'new knight'}, 6704, 6000000, 0, 'new knight outfit full addons')
shopModule:addBuyableItem({'new summoner'}, 6705, 40000000, 0, 'new summoner outfit full addons')
shopModule:addBuyableItem({'assassin'}, 6708, 20000000, 0, 'assassin outfit full addons')
shopModule:addBuyableItem({'demonhunter'}, 6709, 10000000, 0, 'demonhunter outfit full addons')
shopModule:addBuyableItem({'shaman'}, 6710, 12000000, 0, 'shaman outfit full addons')
shopModule:addBuyableItem({'norseman'}, 6711, 4000000, 0, 'norseman outfit full addons')
shopModule:addBuyableItem({'beggar'}, 6713, 8000000, 0, 'beggar outfit full addons')
shopModule:addBuyableItem({'druid'}, 6714, 10000000, 0, 'druid outfit full addons')
shopModule:addBuyableItem({'nightmare'}, 6716, 14000000, 0, 'nightmare outfit full addons')
shopModule:addBuyableItem({'barbarian'}, 6717, 16000000, 0, 'barbarian outfit full addons')
shopModule:addBuyableItem({'oriental'}, 6718, 12000000, 0, 'oriental outfit full addons')
shopModule:addBuyableItem({'brotherhood'}, 6719, 12000000, 0, 'brotherhood outfit full addons')
shopModule:addBuyableItem({'wizard'}, 6720, 16000000, 0, 'wizard outfit full addons')
shopModule:addBuyableItem({'jersey'}, 6721, 10000000, 0, 'jersey outfits')
shopModule:addBuyableItem({'married'}, 6722, 2000000, 0, 'married outfit full addons')
shopModule:addBuyableItem({'mage'}, 7707, 200000000, 0, 'mage outfit full addons')
-- Texto padrão
local outfitListText = "I sell scrolls for full addon outfits such as:\n" ..
    "- New Citizen (3kk)\n- Yalaharian (4kk)\n- New Hunter (3kk)\n- Pirate (6kk)\n" ..
    "- New Knight (6kk)\n- New Summoner (40kk)\n- Assassin (20kk)\n- Demonhunter (10kk)\n" ..
    "- Shaman (12kk)\n- Norseman (4kk)\n- Beggar (8kk)\n- Druid (10kk)\n- Nightmare (14kk)\n" ..
    "- Barbarian (16kk)\n- Oriental (12kk)\n- Brotherhood (12kk)\n- Wizard (16kk)\n" ..
    "- Jersey (10kk)\n- Married (2kk)\n- Mage (200kk)."

-- Palavras-chave com resposta
local triggerWords = {"outfit", "outfits", "what do you sell", "list", "scrolls", "offer", "offers"}
for _, word in ipairs(triggerWords) do
    keywordHandler:addKeyword({word}, StdModule.say, {
        npcHandler = npcHandler,
        onlyFocus = true,
        text = outfitListText
    })
end

npcHandler:addModule(FocusModule:new())
