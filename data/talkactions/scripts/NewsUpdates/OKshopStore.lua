
local coinId = 2157 -- tibia coins

CATEGORY_BOOST = 1
CATEGORY_MOUNTS = 2
CATEGORY_OUTFITS = 3
CATEGORY_ITEMS = 4

Shop = {
	[CATEGORY_BOOST] = { -- Boost
		-- VIP
		[1] = { price =  250, vipdays =  30 },
		[2] = { price =  700, vipdays =  90 }, 
		[3] = { price = 1500, vipdays = 180 },
		[4] = { price = 3000, vipdays = 360 },
		
		-- Change Sex
		[5] = { price = 120 }
	},
	[CATEGORY_MOUNTS] = { -- Mounts
		[1] = { price = 900, mountName = "Floating Kashmir" },
		[2] = { price = 900, mountName = "Flying Divan"  },
		[3] = { price = 900, mountName = "Magic Carpet"  },
		[4] = { price = 660, mountName = "Shadow Hart"   },
		[5] = { price = 660, mountName = "Black Stag"    },
		[6] = { price = 660, mountName = "Emperor Deer"  },
	},
	[CATEGORY_OUTFITS] = { -- Outfits
		[1] = { price = 570, femaleOutfit = 732, maleOutfit = 733 },
		[2] = { price = 870, femaleOutfit = 852, maleOutfit = 853 },
		[3] = { price = 570, femaleOutfit = 632, maleOutfit = 633 },
		[4] = { price = 720, femaleOutfit = 635, maleOutfit = 634 },
	},
	[CATEGORY_ITEMS] = {
	  [1] = { price = 10, itemid = 2281, count = 1 },
	  [2] = { price = 10, itemid = 6177, count = 1 },
	}
}

function onSay(player, words, param)
 
  local value   = param:split(',')
  local categoy = value[1]
  local offerId = tonumber(value[2])
  
  if ( categoy == "requestCoin" ) then
    player:sendCancelMessage("requestCoin>"..player:getItemCount(coinId))
    player:sendCancelMessage("")
	return false
  else
    categoy = tonumber(categoy)
    local offer   = Shop[categoy][offerId]
    if ( offer ) then
      if ( player:removeItem(coinId, offer.price) ) then
	    if ( categoy == CATEGORY_BOOST ) then -- Boost
	      if ( offerId >= 1 and offerId <= 4 ) then
		    player:addPremiumDays(offer.vipdays)
	      elseif ( offerId == 5 ) then
		    player:toggleSex()
	      end
        elseif ( categoy == CATEGORY_MOUNTS ) then -- Mounts
	      player:addMount(offer.mountName)
	    elseif ( categoy == CATEGORY_OUTFITS ) then -- Outfits
	      local outfit = player:getSex() == PLAYERSEX_FEMALE and offer.femaleOutfit or offer.maleOutfit
	      player:addOutfitAddon(outfit, 3)
	    elseif ( categoy == CATEGORY_ITEMS ) then
	      player:addItem(offer.itemid, offer.count)
	    end
	  else
	    player:sendCancelMessage("You don't have enough coins")
      end    
    end  
  end
  return false
end

function Player.toggleSex(self)
  local currentSex = self:getSex()
  local playerOutfit = self:getOutfit()

  if currentSex == PLAYERSEX_FEMALE then
    self:setSex(PLAYERSEX_MALE)
    playerOutfit.lookType = 128
  else
    self:setSex(PLAYERSEX_FEMALE)
    playerOutfit.lookType = 136
  end
  self:setOutfit(playerOutfit)
end