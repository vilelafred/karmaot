-- BETA VERSION, net tested yet
-- Instruction: 
-- creaturescripts.xml      <event type="extendedopcode" name="Shop" script="shop.lua" />
-- and in login.lua         player:registerEvent("Shop")
-- create sql table shop_history
-- set variables
-- set up function init(), add there items and categories, follow examples
-- set up callbacks at the bottom to add player item/outfit/whatever you want

local SHOP_EXTENDED_OPCODE = 201
local SHOP_OFFERS = {}
local SHOP_CALLBACKS = {}
local SHOP_CATEGORIES = nil
local SHOP_BUY_URL = "http://72.62.11.29:8088" -- can be empty
local SHOP_AD = { -- can be nil
  image = "http://72.62.11.29:8088/images/shop/banner.png",
  url = "http://72.62.11.29:8088/?donation",
  text = "Karma Shop"
}
local MAX_PACKET_SIZE = 65500

--[[ SQL TABLE

CREATE TABLE `shop_history` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `title` varchar(100) NOT NULL,
  `cost` int(11) NOT NULL,
  `details` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `shop_history`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `shop_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- EXEMPLO ADICIONAR POR ID ITEM --

  local category1 = addCategory({
    type="item",
    item=ItemType(2160):getClientId(),
    count=100,
    name="Items"
  })
  
]]--

function init()
  --  print(json.encode(g_game.getLocalPlayer():getOutfit())) -- in console in otclient, will print current outfit and mount
  
  SHOP_CATEGORIES = {}


  local category3 = addCategory({
    type="image",
	image="http://72.62.11.29:8088/images/shop/item_5794.png",
    name="Tickets"
  })
  local category1 = addCategory({
    type="image",
	image="http://72.62.11.29:8088/images/shop/6799.png",
    count=1,
    name="Items"
  })
  local category2 = addCategory({
    type="image",
	image="http://72.62.11.29:8088/images/shop/item_6133.png",
    count=1,
    name="Scrolls and VIP"
  })
  local category4 = addCategory({
    type="image",
    image="http://72.62.11.29:8088/images/shop/1738.png",
    name="Training Weapons"
  })
   local category5 = addCategory({
    type="image",
    image="http://72.62.11.29:8088/images/shop/item_3460.png",
    name="Utilities"
  })
    local category6 = addCategory({
    type="image",
    image="http://72.62.11.29:8088/images/shop/7165.png",
    name="Outfits"
  })
    local category7 = addCategory({
    type="image",
    image="http://72.62.11.29:8088/images/shop/5872.png",
    name="Life Quality"
  }) 
     local category8 = addCategory({
    type="image",
    image="http://72.62.11.29:8088/images/shop/6133.png",
    name="Decoration"
  })  
  
  	category1.addItem(160, 7731, 1, "Food Fluid", "Enjoy infinite food")   
	category1.addItem(160, 7723, 1, "Eternal Torch", "Enjoy infinite yellow light")
	category1.addItem(160, 5982, 1, "Silver Ring", "Enjoy infinite white light")	
	category1.addItem(150, 6832, 1, "Sneaky Stabber of Eliteness", "Rope, machete, shovel, pick... It weighs 3.00 oz.\n(All in one)")
	category1.addItem(400, 6747, 1, "Quiver", "You see a quiver (distance fighting +1) (Vol:4).") 
	category1.addItem(500, 2640, 1, "Karma Boots", "Infinite Soft Boots 15hp/s 15mp/s.")
	category1.addItem(350, 5804, 1, "Karma Ring", "Infinite Regen 10hp/s 10mp/s.")
	category3.addItem(10000, 6783, 1, "Golden Outfit", "Use to get golden outfit with full addon!\nThanks for supporting us!") 	

	
	category7.addItem(700, 5872, 1, "Loot Pounch Vol:200", "Organise all your loots.") 	
	category7.addItem(500, 6193, 1, "Auto-loot Coin", "Use to sell all your loot (only sell items inside of main backpack).")	
	category7.addItem(200, 7727, 1, "Auto loot box", "Use to get 1x extra auto-loot slot.") 	
	category7.addItem(150, 6606, 1, "Converter", "Use this item to convert all mystic shard and gold/plat/crystal in your backpack.")
	category7.addItem(1000, 5849, 1, "Karma Map", "Use this item to teleport to your hometown. 2h cooldown. Infinite.")	
	category7.addItem(300, 5994, 1, "Boss Cooldown Book", "Open a modal window showing all Daily Boss cooldowns for your character. Infinite use.")	
	

  category2.addItem(350, 6780, 1, "7 days of premium account", "Use to get 7 days of premium account.")  
  category2.addItem(550, 6781, 1, "15 days of premium account", "Use to get 15 days of premium account.")
  category2.addItem(850, 6782, 1, "30 days of premium account", "Use to get 30 days of premium account.") 
  category2.addItem(100, 6698, 1, "Exp Scroll", "Use to get 20% of extra EXP for 1 hour.")
  category2.addItem(150, 6838, 1, "Bless Scroll", "Give you all five blessings.")     
  category2.addItem(200, 6835, 1, "Rashid and Postman Scroll", "Use to get acess with rashid and postman.")  
  category2.addItem(400, 6850, 1, "Thaddeus Scroll", "Use to get acess with thaddeus. You call sell all your loots for 10% more value. (Need Rashid access).")    	

    category3.addItem(100, 6836, 1, "Karma Ticket", "Use to get 100 premium points!")
    category3.addItem(1000, 7403, 1, "Karma Ticket", "Use to get 1000 premium points!")	
    category3.addItem(30, 6692, 1, "Casino Ticket", "Use it on casino!")
    category3.addItem(300, 6692, 10, "10x Casino Ticket", "Use it on casino!")	
    category3.addItem(50, 6846, 1, "Magic Sulphur", "Access to daily bosses.")	
	category3.addItem(350, 5838, 100, "100x Magic Powder", "It can be used to enchant items at the town forge.")		
	
	
    category4.addItem(300, 8244, 30000, "30000x Training Staff", "Use this item on a training dummy to train staff safe and faster.")
    category4.addItem(300, 8245, 30000, "30000x Training Bow", "Use this item on a training dummy to train bow safe and faster.")
    category4.addItem(300, 8246, 30000, "30000x Training Club", "Use this item on a training dummy to train club safe and faster.")
    category4.addItem(300, 8247, 30000, "30000x Training Axe", "Use this item on a training dummy to train axe safe and faster.")  
    category4.addItem(300, 8248, 30000, "30000x Training Sword", "Use this item on a training dummy to train sword safe and faster.")
    category4.addItem(300, 7730, 30000, "30000x Magic Shield Potion", "Use this item on a training dummy to train shielding safe and faster.")	
    category4.addItem(150, 7695, 1, "Infinite Training Spear", "Enjoy Infinite Training Spear. Atk: 8.")	
	

  	
  category5.addItem(30, 3909, 1, "Ferumbras Dummy", "Use this item to summon a Ferumbras Dummy in your house. Trains 15% faster and disappears after server save.")      
  category5.addItem(500, 5856, 1, "Old Backpack", "You see a old backpack (Vol:40).")
  category5.addItem(100, 2173, 1, "Amulet of Loss", "Prevent loss item.") 
  category5.addItem(500, 6562, 1, "Smithing Hammer", "Use to enchante or disenchate an item.")    
  category5.addItem(100, 6088, 1, "Bless Check", "Click on the ankh and check your five blessings.") 

  

	
	category8.addItem(50, 6133, 1, "Red Blood Herb", "Decorate.")
	category8.addItem(50, 5828, 1, "Blue Blood Herb", "Decorate.")
	category8.addItem(50, 5829, 1, "Violet Blood Herb", "Decorate.")	
	category8.addItem(50, 5830, 1, "Green Blood Herb", "Decorate.")
	category8.addItem(50, 5831, 1, "Yellow Blood Herb", "Decorate.")
	category8.addItem(50, 5832, 1, "White Blood Herb", "Decorate.")	
	category8.addItem(150, 6826, 15, "x15 Decorated Carpets", "Flooring for your house. 1 sqm.")
	category8.addItem(150, 6827, 15, "x15 Decorated Carpets", "Flooring for your house. 1 sqm.")
	category8.addItem(150, 6828, 15, "x15 Decorated Carpets", "Flooring for your house. 1 sqm.")	
	category8.addItem(150, 6829, 15, "x15 Decorated Carpets", "Flooring for your house. 1 sqm.")	
	
	
	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 128,
    lookType = { 128, 136 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Citizen", "This is your cool new outfit. You can buy it here") 

	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 129,
    lookType = { 129, 137 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Hunter", "This is your cool new outfit. You can buy it here")   

	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 130,
    lookType = { 130, 138 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Mage", "This is your cool new outfit. You can buy it here") 

	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 131,
    lookType = { 131, 139 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Knight", "This is your cool new outfit. You can buy it here")

	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 132,
    lookType = { 132, 141 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Noble", "This is your cool new outfit. You can buy it here")  

	category6.addOutfit(300, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 134,
    lookType = { 134, 142 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Advanced Warrior", "This is your cool new outfit. You can buy it here") 

category6.addOutfit(200, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 655,
    lookType = { 655, 656 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Citizen", "This is your cool new outfit. You can buy it here")

category6.addOutfit(200, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 657,  -- Alteração feita aqui
    lookType = { 657, 658 },
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Hunter", "This is your cool new outfit. You can buy it here")

category6.addOutfit(50000, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 659,  -- Alteração feita aqui
    lookType = { 659, 660 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Mage", "This is your cool new outfit. You can buy it here")

category6.addOutfit(200, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 661,  -- Alteração feita aqui
    lookType = { 661, 662 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Knight", "This is your cool new outfit. You can buy it here")

category6.addOutfit(200, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 663,  -- Alteração feita aqui
    lookType = { 663, 664 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Nobleman", "This is your cool new outfit. You can buy it here")

category6.addOutfit(450, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 665,  -- Alteração feita aqui
    lookType = { 665, 666 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Summoner", "This is your cool new outfit. You can buy it here")

category6.addOutfit(550, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 667,  -- Alteração feita aqui
    lookType = { 667, 668 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Warrior", "This is your cool new outfit. You can buy it here")

category6.addOutfit(700, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 669,  -- Alteração feita aqui
    lookType = { 669, 670 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Barbarian", "This is your cool new outfit. You can buy it here")

category6.addOutfit(550, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 671,  -- Alteração feita aqui
    lookType = { 671, 672 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Wizard", "This is your cool new outfit. You can buy it here")

category6.addOutfit(550, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 673,  -- Alteração feita aqui
    lookType = { 673, 674 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Druid", "This is your cool new outfit. You can buy it here")

category6.addOutfit(750, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 675,  -- Alteração feita aqui
    lookType = { 675, 676 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "New Oriental", "This is your cool new outfit. You can buy it here")

category6.addOutfit(800, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 773,  -- Alteração feita aqui
    lookType = { 773, 774 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Lory Madam/Keeper", "This is your cool new outfit. You can buy it here")

category6.addOutfit(3000, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 127,  -- Alteração feita aqui
    lookType = { 127, 126 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Old Citizen", "This is your cool old outfit. You can buy it here")

category6.addOutfit(1500, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 637,  -- Alteração feita aqui
    lookType = { 637, 637 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Dwarf Geomancer", "This is your cool old outfit. You can buy it here")

category6.addOutfit(1500, {
    mount = 0,
    feet = 114,
    legs = 114,
    body = 116,
    type = 652,  -- Alteração feita aqui
    lookType = { 652, 652 },  -- Alteração feita aqui
    auxType = 0,
    addons = 0,
    head = 2,
    rotating = true
}, "Banshee", "This is your cool old outfit. You can buy it here")



 
end

function addCategory(data)
  data['offers'] = {}
  table.insert(SHOP_CATEGORIES, data)
  table.insert(SHOP_CALLBACKS, {})
  local index = #SHOP_CATEGORIES
  return {
    addItem = function(cost, itemId, count, title, description, callback)      
      if not callback then
        callback = defaultItemBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="item",
        item=ItemType(itemId):getClientId(), -- displayed
        itemId=itemId,
        count=count,
        title=title,
        description=description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addOutfit = function(cost, outfit, title, description, callback)
      if not callback then
        callback = defaultOutfitBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="outfit",
        outfit=outfit,
        title=title,
        description=description
      })    
      table.insert(SHOP_CALLBACKS[index], callback)
    end,
    addImage = function(cost, image, title, description, callback)
      if not callback then
        callback = defaultImageBuyAction
      end
      table.insert(SHOP_CATEGORIES[index]['offers'], {
        cost=cost,
        type="image",
        image=image,
        title=title,
        description=description
      })
      table.insert(SHOP_CALLBACKS[index], callback)
    end
  }
end

function getPoints(player)
  local points = 0
  local resultId = db.storeQuery("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. player:getAccountId())
  if resultId ~= false then
    points = result.getDataInt(resultId, "premium_points")
    result.free(resultId)
  end
  return points
end

function getStatus(player)
  local status = {
    ad = SHOP_AD,
    points = getPoints(player),
    buyUrl = SHOP_BUY_URL
  }
  return status
end

function sendJSON(player, action, data, forceStatus)
  local status = nil
  if not player:getStorageValue(1150001) or player:getStorageValue(1150001) + 10 < os.time() or forceStatus then
      status = getStatus(player)
  end
  player:setStorageValue(1150001, os.time())
  

  local buffer = json.encode({action = action, data = data, status = status})  
  local s = {}
  for i=1, #buffer, MAX_PACKET_SIZE do
     s[#s+1] = buffer:sub(i,i+MAX_PACKET_SIZE - 1)
  end
  local msg = NetworkMessage()
  if #s == 1 then
    msg:addByte(50)
    msg:addByte(SHOP_EXTENDED_OPCODE)
    msg:addString(s[1])
    msg:sendToPlayer(player)
    return  
  end
  -- split message if too big
  msg:addByte(100)
  msg:addByte(SHOP_EXTENDED_OPCODE)
  msg:addString("S" .. s[1])
  msg:sendToPlayer(player)
  for i=2,#s - 1 do
    msg = NetworkMessage()
    msg:addByte(50)
    msg:addByte(SHOP_EXTENDED_OPCODE)
    msg:addString("P" .. s[i])
    msg:sendToPlayer(player)
  end
  msg = NetworkMessage()
  msg:addByte(50)
  msg:addByte(SHOP_EXTENDED_OPCODE)
  msg:addString("E" .. s[#s])
  msg:sendToPlayer(player)
end

function sendMessage(player, title, msg, forceStatus)
  sendJSON(player, "message", {title=title, msg=msg}, forceStatus)
end

function onExtendedOpcode(player, opcode, buffer)
  if opcode ~= SHOP_EXTENDED_OPCODE then
    return false
  end
  local status, json_data = pcall(function() return json.decode(buffer) end)
  if not status then
    return false
  end

  local action = json_data['action']
  local data = json_data['data']
  if not action or not data then
    return false
  end

  if SHOP_CATEGORIES == nil then
    init()    
  end

  if action == 'init' then
	for i, j in pairs(SHOP_CATEGORIES) do
		sendJSON(player, "categories", {i, j}, true)
	end
  elseif action == 'buy' then
    processBuy(player, data)
  elseif action == "history" then
    sendHistory(player)
  end
  return true
end

function processBuy(player, data)
  local categoryId = tonumber(data["category"])
  local offerId = tonumber(data["offer"])
  local offer = SHOP_CATEGORIES[categoryId]['offers'][offerId]
  local callback = SHOP_CALLBACKS[categoryId][offerId]
  if not offer or not callback or data["title"] ~= offer["title"] or data["cost"] ~= offer["cost"] then
	for i, j in pairs(SHOP_CATEGORIES) do
		sendJSON(player, "categories", {i, j})
	end
    return sendMessage(player, "Error!", "Invalid offer")      
  end
  local points = getPoints(player)
  if not offer['cost'] or offer['cost'] > points or points < 1 then
    return sendMessage(player, "Error!", "You don't have enough points to buy " .. offer['title'] .."!", true)    
  end
  local status = callback(player, offer)
  if status == true then    
    db.query("UPDATE `accounts` set `premium_points` = `premium_points` - " .. offer['cost'] .. " WHERE `id` = " .. player:getAccountId())
    db.asyncQuery("INSERT INTO `shop_history` (`account`, `player`, `date`, `title`, `cost`, `details`) VALUES ('" .. player:getAccountId() .. "', '" .. player:getGuid() .. "', NOW(), " .. db.escapeString(offer['title']) .. ", " .. db.escapeString(offer['cost']) .. ", " .. db.escapeString(json.encode(offer)) .. ")")
    return sendMessage(player, "Success!", "You bought " .. offer['title'] .."!", true)
  end
  if status == nil or status == false then
    status = "Unknown error while buying " .. offer['title']
  end
  sendMessage(player, "Error!", status)
end

function sendHistory(player)
  if player:getStorageValue(1150002) and player:getStorageValue(1150002) + 10 > os.time() then
    return -- min 10s delay
  end
  player:setStorageValue(1150002, os.time())
  
  local history = {}
	local resultId = db.storeQuery("SELECT * FROM `shop_history` WHERE `account` = " .. player:getAccountId() .. " order by `id` DESC")

	if resultId ~= false then
    repeat
      local details = result.getDataString(resultId, "details")
      local status, json_data = pcall(function() return json.decode(details) end)
      if not status then    
        json_data = {
          type = "image",
          title = result.getDataString(resultId, "title"),
          cost = result.getDataInt(resultId, "cost")
        }
      end
      table.insert(history, json_data)
      history[#history]["description"] = "Bought on " .. result.getDataString(resultId, "date") .. " for " .. result.getDataInt(resultId, "cost") .. " points."
    until not result.next(resultId)
    result.free(resultId)
	end
  
  sendJSON(player, "history", history)
end

-- BUY CALLBACKS
-- May be useful: print(json.encode(offer))

function defaultItemBuyAction(player, offer)
  -- Adição atômica para qualquer quantidade:
  --  - Itens empilháveis: adiciona em pilhas de até 100
  --  - Itens não empilháveis: adiciona um por um
  --  Em caso de falha, remove tudo que foi adicionado (rollback)

  local itemId = offer["itemId"]
  local totalCount = offer["count"] or 1
  local itemType = ItemType(itemId)
  local addedItems = {}

  local function rollback()
    for _, it in ipairs(addedItems) do
      if it and it:isItem() then
        it:remove()
      end
    end
  end

  -- Itens com charges (ex.: Training Weapons) devem usar "count" como número de charges,
  -- não como quantidade de itens, para evitar erro de capacidade/peso.
  local chargeItemIds = {
    [8244] = true, -- Training Staff
    [8245] = true, -- Training Bow
    [8246] = true, -- Training Club
    [8247] = true, -- Training Axe
    [8248] = true, -- Training Sword
    [7730] = true  -- Magic Shield Potion (training shielding)
  }

  if itemType:isStackable() then
    local remaining = totalCount
    while remaining > 0 do
      local toCreate = math.min(100, remaining)
      local createdItem = Game.createItem(itemId, toCreate)
      if not createdItem then
        rollback()
        return "The item could not be created."
      end
      local result = player:addItemEx(createdItem)
      if result ~= RETURNVALUE_NOERROR then
        createdItem:remove()
        rollback()
        return "The item cannot be added. Not enough capacity or space."
      end
      table.insert(addedItems, createdItem)
      remaining = remaining - toCreate
    end
  else
    -- Se for um item de charges, cria apenas 1 item e seta as charges.
    if chargeItemIds[itemId] and totalCount > 1 then
      local createdItem = Game.createItem(itemId, 1)
      if not createdItem then
        rollback()
        return "The item could not be created."
      end
      -- Tenta setar via constante; se não existir, tenta pela chave string.
      local ok = pcall(function()
        createdItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, totalCount)
      end)
      if not ok then
        createdItem:setAttribute('charges', totalCount)
      end
      local result = player:addItemEx(createdItem)
      if result ~= RETURNVALUE_NOERROR then
        createdItem:remove()
        rollback()
        return "The item cannot be added. Not enough capacity or space."
      end
      table.insert(addedItems, createdItem)
    else
    for i = 1, totalCount do
      local createdItem = Game.createItem(itemId, 1)
      if not createdItem then
        rollback()
        return "The item could not be created."
      end
      local result = player:addItemEx(createdItem)
      if result ~= RETURNVALUE_NOERROR then
        createdItem:remove()
        rollback()
        return "The item cannot be added. Not enough capacity or space."
      end
      table.insert(addedItems, createdItem)
    end
    end
  end

  return true
end

function defaultPremiumBuyAction(player, offer)
	if player:getPremiumDays() + offer["count"] > 360 then
		return "You cannot buy more than 1 year of premium."
	else
		player:addPremiumDays(offer["count"])
	return true
	end
return true
end

function defaultOutfitBuyAction(player, offer)
  local outfit = offer["outfit"]

  -- Add the outfit itself
  local outfitId = player:addOutfit(outfit["type"], outfit["id"], outfit["addons"], outfit["mount"])

  -- Add addons for each lookType
  if outfitId ~= 0 then
    local addons = outfit.addons
    for _, lookType in ipairs(outfit.lookType) do
      player:addOutfitAddon(lookType, addons)
    end
    return true
  else
    return "The outfit could not be added to the player."
  end
end


function defaultImageBuyAction(player, offer)
  return "The default image purchase action is not implemented."
end

function customImageBuyAction(player, offer)
  return "The custom image purchase action is not implemented. Offer: " .. offer['title']
end




  --category1.addItem(28, 5804, 1, "Karma Ring", "Infinite Regeneration +1HP/3s +1MP/3s")   
  --category1.addItem(42, 2640, 1, "Pair of Soft Boots", "Infinite Regeneration +2HP/2s +2MP/2s") 
  --category1.addItem(47, 5903, 1, "Winged Boots", "Speed +40 and full light")

  --category1.addItem(15, 6742, 1, "Aquatic Backpack", "You see a aquatic backpack (Vol:40).")
  --category1.addItem(15, 6775, 1, "Enchanted Woods Backpack", "You see a enchanted woods backpack (Vol:40).")
  --category1.addItem(15, 6774, 1, "Cursed Backpack", "You see a cursed backpack (Vol:40).")
  --category1.addItem(15, 6773, 1, "Astral Elevation Backpack", "You see a astral elevation backpack (Vol:40).")
 -- category1.addItem(15, 6772, 1, "Beholder Backpack", "You see a beholder backpack (Vol:40).")
  --category1.addItem(15, 6771, 1, "Devil Draptor Backpack", "You see a devil draptor backpack (Vol:40).")
  --category1.addItem(15, 6769, 1, "Kitty Backpack", "You see a kitty backpack (Vol:40).")
  --category1.addItem(15, 6767, 1, "Phantom Death Backpack", "You see a phantom death backpack (Vol:40).")
  --category1.addItem(15, 6745, 1, "Mystic Demon Backpack", "You see a mystic demon backpack (Vol:40).")
  --category1.addItem(15, 6758, 1, "Nature's Backpack", "You see a nature's backpack (Vol:40).")
 --category1.addItem(15, 6788, 1, "Magician Backpack", "You see a magician backpack (Vol:40).")
  --category1.addItem(15, 6605, 1, "Sudden Backpack", "You see a sudden backpack (Vol:40).")
  --category1.addItem(15, 6612, 1, "Youtube Backpack", "You see a youtube backpack (Vol:40).")

   --category2.addItem(30, 6399, 1, "Brasil Tapestry", "You see a brasil tapestry.")
  --category2.addItem(30, 6737, 1, "Sweden Tapestry", "You see a sweden tapestry.")
  --category2.addItem(30, 6738, 1, "U.S.A Tapestry", "You see a united states tapestry.")
  --category2.addItem(30, 6739, 1, "Venezuela Tapestry", "You see a venezuela tapestry.")
  --category2.addItem(30, 6723, 1, "Australia Tapestry", " You see a australia tapestry.")
  --category2.addItem(30, 6736, 1, "Spain Tapestry", "You see a spain tapestry.")
  --category2.addItem(30, 6735, 1, "Portugal Tapestry.", "You see a portugal tapestry.")
  --category2.addItem(30, 6734, 1, "Norway", "You see a norway tapestry.")
  --category2.addItem(30, 6733, 1, "Netherlands Tapestry", "You see a netherlands tapestry.")
  --category2.addItem(30, 6732, 1, "Mexico Tapestry", "You see a mexico tapestry.")
  --category2.addItem(30, 6731, 1, "U.K Tapestry", "You see a united kingdom tapestry.")
  --category2.addItem(30, 6730, 1, "Germany Tapestry", "You see a germany tapestry.") 
  --category2.addItem(30, 6729, 1, "Poland Tapestry", "You see a poland tapestry.")  
  --category2.addItem(30, 6727, 1, "Chile Tapestry", "You see a chile tapestry.") 
  --category2.addItem(30, 6726, 1, "Canada Tapestry", "You see a canada tapestry.") 
  --category2.addItem(30, 6725, 1, "Belgium Tapestry", "You see a belgium tapestry.") 
  --category2.addItem(30, 6724, 1, "Argentina Tapestry", "You see a Argentina tapestry.")
 
    --category4.addItem(5, 5832, 5, "White Blood Herb", "You see a white blood herb.")
    --category4.addItem(5, 5831, 5, "Yellow Blood Herb", "You see a yellow blood herb.")
    --category4.addItem(5, 5830, 5, "Green Blood Herb", "You see a green blood herb.")
    --category4.addItem(5, 5829, 5, "Violet Blood Herb", "You see a violet blood herb.")
    --category4.addItem(5, 5828, 5, "Blue Blood Herb", "You see a blue blood herb.")
    --category4.addItem(10, 2798, 5, "Blood Herb", "You see a blood herb.")

	
 --category6.addItem(30, 6699, 1, "New Citizen Outfit", "Use to get new citizen outfit with full addons!")
 --category6.addItem(30, 6701, 1, "New Hunter Outfit", "Use to get new hunter outfit with full addons!")
 --category6.addItem(30, 6704, 1, "New Knight Outfit", "Use to get new knight outfit with full addons!")  
 --category6.addItem(30, 6705, 1, "New Summoner Outfit", "Use to get new summoner outfit with full addons!") 
 --category6.addItem(150, 6703, 1, "New Mage Full Addon", "Use to get new mage outfit with full addons!") 
 --category6.addItem(50, 6715, 1, "Mage Advanced Outfit", "Use to get mage advanced outfit with full addons!")
 --category6.addItem(50, 6707, 1, "Citizen Advanced Outfit", "Use to get citizen advanced outfit with full addons!")
 --category6.addItem(50, 6712, 1, "Hunter Advanced Outfit", "Use to get hunter advanced outfit with full addons!") 
 --category6.addItem(40, 6713, 1, "Beggar Outfit Full Addon", "Use to get beggar outfit with full addons!")   
 --category6.addItem(40, 6714, 1, "Druid Outfit Full Addon", "Use to get druid outfit with full addons!")  
 --category6.addItem(40, 6718, 1, "Oriental Outfit Full Addon", "Use to get oriental outfit with full addons!") 
 --category6.addItem(40, 6720, 1, "Wizard Outfit Full Addon", "Use to get wizard outfit with full addons!") 
 --category6.addItem(40, 6710, 1, "Shaman Outfit Full Addon", "Use to get shaman outfit with full addons!")  
 --category6.addItem(40, 6711, 1, "Norseman Outfit Full Addon", "Use to get norseman outfit with full addons!")   
 --category6.addItem(50, 6708, 1, "Assassin Outfit Full Addon", "Use to get assassin outfit with full addons!")
 --category6.addItem(50, 6717, 1, "Barbarian Outfit Full Addon", "Use to get barbarian outfit with full addons!")  
 --category6.addItem(30, 6700, 1, "Yalaharian Outfit Full Addon", "Use to get yalaharian outfit with full addons!")
 --category6.addItem(30, 6702, 1, "Pirate Outfit Full Addon", "Use to get pirate outfit with full addons!") 
 --category6.addItem(200, 6800, 1, "Dragon Slayer Outfit", "Use to get dragon slayer outfit!") 
 
   --category4.addImage(10000, "/data/images/game/states/haste.png", "Offer with local image", "another local image\n/data/images/game/states/haste.png")
  --category4.addImage(10000, "http://191.96.79.247/images/shop/item_3460.png", "Offer with remote image and custom buy action", "blalasdasd image\nhttp://otclient.ovh/images/freezing.png", customImageBuyAction)
  