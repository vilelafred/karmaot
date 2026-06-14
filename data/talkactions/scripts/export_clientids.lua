function onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return true
  end

  if player:getAccountType() < ACCOUNT_TYPE_GOD then
    return false
  end

  local fileName = param ~= "" and param or ("clientids-%d.txt"):format(os.time())
  local filePath = string.format("data/reports/%s", fileName)

  local f, err = io.open(filePath, "w+")
  if not f then
    player:sendCancelMessage("Falha ao abrir arquivo: " .. tostring(err))
    return false
  end

  -- Cabeçalho simples
  f:write("# serverId -> clientId (id,name,clientId)\n")

  -- Percorre todos os itens carregados
  -- Em TFS, os IDs válidos começam em 100 até o máximo em items.xml/otb
  local maxId = 65535
  local exported = 0

  for serverId = 100, maxId do
    local it = ItemType(serverId)
    if it and it:getId() ~= 0 then
      local clientId = it:getClientId()
      -- Somente itens com clientId válido (>0)
      if clientId and clientId > 0 then
        local name = it:getName() or ""
        f:write(string.format("%d;%s;%d\n", serverId, name, clientId))
        exported = exported + 1
      end
    end
  end

  f:close()

  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Exportados %d itens para %s", exported, filePath))
  player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
  return false
end


