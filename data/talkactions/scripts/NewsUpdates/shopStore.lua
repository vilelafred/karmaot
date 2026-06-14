
local coinId = 2157 -- tibia coins

CATEGORY_BOOST = 1
CATEGORY_OUTFITS = 2
CATEGORY_ITEMS = 3

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
	[CATEGORY_OUTFITS] = { -- Outfits
		[1] = { price = 10, femaleOutfit = 619, maleOutfit = 520},
		[2] = { price = 10, femaleOutfit = 621, maleOutfit = 522},
		[3] = { price = 10, femaleOutfit = 612, maleOutfit = 512},
		[4] = { price = 10, femaleOutfit = 609, maleOutfit = 509},
		[5] = { price = 10, femaleOutfit = 600, maleOutfit = 511},
		[6] = { price = 10, femaleOutfit = 617, maleOutfit = 518},
		[7] = { price = 10, femaleOutfit = 620, maleOutfit = 521},
		[8] = { price = 10, femaleOutfit = 604, maleOutfit = 504},
		[9] = { price = 10, femaleOutfit = 605, maleOutfit = 505},
		[10] = { price = 10, femaleOutfit = 603, maleOutfit = 507}
	},
	[CATEGORY_ITEMS] = {
	  [1] = { price = 10, itemid = 2173, count = 1 },
	  [2] = { price = 20, itemid = 6161, count = 1 },
	  [3] = { price = 10, itemid = 5090, count = 1 },
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
