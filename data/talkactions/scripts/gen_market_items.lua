local function detectCategory(name)
  local n = name:lower()

  -- Specific slots first
  if n:find("helmet") or n:find("helm") or n:find("mask") or n:find("hat") or n:find("hood") or n:find("crown") or n:find("tiara") or n:find("headdress") or n:find("cap") then
    return 7 -- helmets
  end
  if n:find("%f[%w]legs%f[%W]") or n:find("%f[%w]leg%f[%W]") then
    return 8 -- legs
  end
  if n:find("boots") or n:find("shoes") or n:find("sandals") or n:find("slippers") then
    return 3 -- boots
  end
  if n:find("shield") then
    return 13 -- shields
  end

  -- Accessories / containers / ammo / runes / potions / tools / food / decoration / valuables
  if n:find("ring") then
    return 11 -- rings
  end
  if n:find("amulet") or n:find("necklace") or n:find("talisman") or n:find("%f[%w]chain%f[%W]") then
    return 2 -- amulets/necklaces
  end
  if n:find("backpack") or n:find("%f[%w]bag%f[%W]") then
    return 4 -- containers
  end
  if n:find("rune") then
    return 12 -- runes
  end
  if n:find("arrow") or n:find("bolt") or n:find("star") then
    return 16 -- ammunition
  end
  if n:find("potion") or n:find("elixir") then
    return 10 -- potions
  end
  if n:find("rope") or n:find("shovel") or n:find("pickaxe") or n:find("%f[%w]pick%f[%W]") then
    return 14 -- tools
  end
  if n:find("ham") or n:find("meat") or n:find("fish") or n:find("bread") or n:find("pear") or n:find("melon") or n:find("grapes") or n:find("egg") or n:find("cookie") or n:find("cake") or n:find("mushroom") or n:find("shrimp") or n:find("corncob") or n:find("banana") or n:find("orange") or n:find("strawberry") or n:find("tomato") or n:find("carrot") then
    return 6 -- food
  end
  if n:find("tapestry") or n:find("picture") or n:find("mirror") or n:find("statue") or n:find("pillow") or n:find("carpet") then
    return 5 -- decoration
  end
  if n:find("gem") or n:find("pearl") or (n:find("crystal") and not n:find("rod") and not n:find("wand")) or n:find("diamond") or n:find("sapphire") or n:find("emerald") or n:find("amethyst") or n:find("golden") or n:find("coin") or n:find("goblet") or n:find("figurine") then
    return 15 -- valuables
  end

  -- Armors (avoid misclassifying 'plate legs')
  if (n:find("armor") or n:find("plate") or n:find("mail") or n:find("robe") or n:find("coat") or n:find("tunic") or n:find("jacket") or n:find("cape"))
     and not (n:find("legs") or n:find("leg")) then
    return 1 -- armors/capes
  end

  -- Weapons
  if n:find("axe") or n:find("halberd") or n:find("hatchet") or n:find("sickle") or n:find("lance") or n:find("tomahawk") then
    return 17 -- axes/spears/lances family
  end

  if n:find("mace") or n:find("hammer") or n:find("club") or n:find("sceptre") or n:find("flail") or n:find("basher") or n:find("whopper") or n:find("maul") or n:find("crusher") or n:find("smasher") or n:find("crowbar") then
    return 18 -- clubs/maces/hammers
  end

  if n:find("sword") or n:find("blade") or n:find("edge") or n:find("rapier") or n:find("scimitar") or n:find("katana") or n:find("dagger") or n:find("sabre") or n:find("broadsword") or n:find("longsword") then
    return 20 -- swords/daggers
  end

  if n:find("bow") or n:find("crossbow") or n:find("bolter") then
    return 19 -- distance bows/crossbows
  end

  if n:find("rod") or n:find("wand") then
    return 21 -- rods/wands
  end
  -- heuristic for 'staff': magic vs heavy
  if n:find("staff") then
    if n:find("blessed") or n:find("magic") or n:find("mage") then
      return 21
    else
      return 18
    end
  end

  return 31 -- others (fallback)
end

local function writeMarketItems(outPath, entries)
  local f, err = io.open(outPath, "w+")
  if not f then
    return false, err
  end
  f:write("return {\n")
  local idx = 0
  for _, e in ipairs(entries) do
    f:write(string.format("  [%d]={id=%d,category=%d,name=\"%s\"},\n", idx, e.clientId, e.category, e.name:gsub("\\", "\\\\"):gsub("\"", "\\\"")))
    idx = idx + 1
  end
  f:write("}\n")
  f:close()
  return true
end

function onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return true
  end
  if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return false
  end

  local inPath = param ~= "" and param or "data/reports/latest-clientids.txt"
  -- permite caminho relativo curto: se vier sem 'data/', tenta folder atual
  local f = io.open(inPath, "r")
  if not f then
    -- fallback para o arquivo que você abriu recentemente
    inPath = "data/talkactions/scripts/clientids-1759174239.txt"
    f = io.open(inPath, "r")
  end
  if not f then
    player:sendCancelMessage("Não consegui abrir o arquivo de client IDs. Informe o caminho: /genmarketitems data/.../clientids-xxxx.txt")
    return false
  end

  local seenClient = {}
  local result = {}

  for line in f:lines() do
    -- formato: serverId;name;clientId
    local sid, name, cid = line:match("^(%d+);(.-);(%d+)$")
    if sid and name and cid then
      local clientId = tonumber(cid)
      if clientId and clientId > 0 and not seenClient[clientId] then
        local cat = detectCategory(name)
        if cat then
          table.insert(result, {clientId = clientId, category = cat, name = name})
          seenClient[clientId] = true
        end
      end
    end
  end
  f:close()

  -- ordena por categoria e nome para consistência
  table.sort(result, function(a, b)
    if a.category ~= b.category then
      return a.category < b.category
    end
    return a.name:lower() < b.name:lower()
  end)

  local outPath = "data/market_items.lua"
  local ok, err = writeMarketItems(outPath, result)
  if not ok then
    player:sendCancelMessage("Falha ao escrever market_items.lua: " .. tostring(err))
    return false
  end

  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Gerados %d itens em %s", #result, outPath))
  player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
  return false
end


