-- Rewrites data/marketprotocol.lua items table using data/market_items.lua (client IDs)

local function escapeString(s)
  s = tostring(s or "")
  s = s:gsub("\\", "\\\\"):gsub("\"", "\\\"")
  return s
end

local function loadMarketItems()
  local ok, data = pcall(dofile, "data/market_items.lua")
  if not ok or type(data) ~= 'table' then
    return nil, "failed to load data/market_items.lua"
  end

  local keyed = {}
  for k, v in pairs(data) do
    if type(k) == 'number' and type(v) == 'table' then
      table.insert(keyed, { k = k, v = v })
    end
  end
  table.sort(keyed, function(a, b) return a.k < b.k end)

  local seen = {}
  local compact = {}
  for _, kv in ipairs(keyed) do
    local e = kv.v
    local id = e and e.id
    if type(id) == 'number' and id > 0 and not seen[id] then
      table.insert(compact, { id = id, category = tonumber(e.category) or 31, name = tostring(e.name or "") })
      seen[id] = true
    end
  end

  -- reindex to 0..N
  local reindexed = {}
  local idx = 0
  for _, e in ipairs(compact) do
    reindexed[idx] = e
    idx = idx + 1
  end
  return reindexed
end

local function rebuildItemsBlock(entries)
  local lines = {}
  table.insert(lines, "  local items = {")
  local idx = 0
  for i = 0, math.huge do
    local e = entries[i]
    if not e then break end
    local name = escapeString(e.name)
    table.insert(lines, string.format("    [%d]={id=%d,category=%d,name=\"%s\"},", idx, e.id, e.category, name))
    idx = idx + 1
  end
  table.insert(lines, "  }")
  return table.concat(lines, "\n")
end

local function rewriteProtocolFile(newItemsBlock)
  local path = "data/marketprotocol.lua"
  local f = io.open(path, "r")
  if not f then
    return false, "cannot open marketprotocol.lua for reading"
  end
  local content = f:read("*a")
  f:close()

  local startPos = content:find("local function parseMarketEnter", 1, true)
  if not startPos then
    return false, "parseMarketEnter not found"
  end

  local before = content:sub(1, startPos - 1)
  local rest = content:sub(startPos)

  -- replace the first `local items = %b{}` inside parseMarketEnter block
  local replaced, n = rest:gsub("local%s+items%s*=%s*%b{}", newItemsBlock, 1)
  if n == 0 then
    return false, "items block not found"
  end

  local out = before .. replaced
  local wf, err = io.open(path, "w+")
  if not wf then
    return false, err
  end
  wf:write(out)
  wf:close()
  return true
end

function onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return true
  end
  if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return false
  end

  local entries, err = loadMarketItems()
  if not entries then
    player:sendCancelMessage("Falha ao carregar market_items.lua: " .. tostring(err))
    return false
  end

  local newItemsBlock = rebuildItemsBlock(entries)
  local ok, werr = rewriteProtocolFile(newItemsBlock)
  if not ok then
    player:sendCancelMessage("Falha ao atualizar marketprotocol.lua: " .. tostring(werr))
    return false
  end

  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("marketprotocol.lua atualizado com %d entradas", #entries))
  player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
  return false
end


