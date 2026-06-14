--[[ --------------------------------------------------------------------------------------------------------------------------------------
		Author: Leo32
		File: creatureevents/scripts/attributes.lua
		
		This pulls attributes from items that affect combat, and applies the damage changes.
		(!) Be aware that primaryType and secondaryType has been swapped for elemental visual clarity.
		(!) This system has CONDITION_STUN (can add it to your sources from here: https://otland.net/threads/tfs-1-x-shield-bash.268433/ and uncomment the code in (stunTarget))
		
		Your creaturescripts.xml should have these, for this to work:
		<event type="healthchange" name="CombatModifiers" script="combatmodifiers.lua"/>
		<event type="manachange" name="CombatModifiersMana" script="combatmodifiers.lua"/>
--]] --------------------------------------------------------------------------------------------------------------------------------------

local allowedSlotItems = {
	[7723] = true,
	[2155] = true
	}
	
	-- Crits
	local critmodifier = 0.1 -- Critical hits do 20% damage
	local criteffect = 173
	
	-- Sistema de acumulação de leech (batch system)
	local manaleechBatched = {}
	local lifeleechBatched = {}
	local BATCH_DELAY = 1000 -- 1.5 segundos para acumular
	
	-- What slots should be checked for elemental damage, crit, multi shot, mana leech, spelldamage etc
	local checkweaponslots = {
		CONST_SLOT_LEFT,
		CONST_SLOT_RIGHT,
		CONST_SLOT_NECKLACE,
		CONST_SLOT_HEAD,
		CONST_SLOT_RING,
		CONST_SLOT_ARMOR,
		CONST_SLOT_LEGS,
		CONST_SLOT_FEET,
		CONST_SLOT_AMMO,
	}
	
	-- What slots should be checked for resistances (basically all of them, as shields can be in either hand)
	local checkallslots = {
		CONST_SLOT_LEFT,
		CONST_SLOT_RIGHT,
		CONST_SLOT_HEAD,
		CONST_SLOT_NECKLACE,
		CONST_SLOT_ARMOR,
		CONST_SLOT_LEGS,
		CONST_SLOT_FEET,
		CONST_SLOT_RING,
		CONST_SLOT_AMMO
	}
	
	-- Match the animation to the ammunation type
	local animation = {
			[2543] = CONST_ANI_BOLT,
			[6498] = CONST_ANI_BOLT,
			[2547] = CONST_ANI_POWERBOLT,
			[6499] = CONST_ANI_POWERBOLT,
		[6529] = CONST_ANI_INFERNALBOLT,
			[7363] = CONST_ANI_PIERCINGBOLT,
			[7691] = CONST_ANI_PIERCINGBOLT,
		[15649] = CONST_ANI_VORTEXBOLT,
		[18435] = CONST_ANI_PRISMATICBOLT,
		[18436] = CONST_ANI_DRILLBOLT,
	
		[2544] = CONST_ANI_ARROW,
		[2545] = CONST_ANI_POISONARROW,
		[2546] = CONST_ANI_BURSTARROW,
		[7692] = CONST_ANI_ONYXARROW,
		[7693] = CONST_ANI_SNIPERARROW,
		[7688] = CONST_ANI_FLASHARROW,
		[7690] = CONST_ANI_FLAMMINGARROW,
		[7689] = CONST_ANI_SHIVERARROW,
		[7738] = CONST_ANI_EARTHARROW,
		[15648] = CONST_ANI_TARSALARROW,
		[18437] = CONST_ANI_ENVENOMEDARROW,
		[18304] = CONST_ANI_CRYSTALLINEARROW,
	
		[2111] = CONST_ANI_SNOWBALL,
		[2389] = CONST_ANI_SPEAR,
		[3965] = CONST_ANI_HUNTINGSPEAR,
		[7695] = CONST_ANI_ENCHANTEDSPEAR,
		[7514] = CONST_ANI_ROYALSPEAR,
		[2399] = CONST_ANI_THROWINGSTAR,
		[7696] = CONST_ANI_REDSTAR,
		[7694] = CONST_ANI_GREENSTAR,
		[2410] = CONST_ANI_THROWINGKNIFE
	}
	
	-- Used for shuffling targets, so random ones are chosen
	function shuffle(t)
		local rand = math.random 
		assert(t, "table.shuffle() expected a table, got nil")
		local iterations = #t
		local j
		for i = iterations, 2, -1 do
			j = rand(i)
			t[i], t[j] = t[j], t[i]
		end
	end
	
	-- Função para mostrar texto animado (tenta várias formas)
	local function animatedText(pos, text, color, speaker)
		-- tenta mandar texto animado (quase sempre sai laranja nesse client)
		if Game and Game.sendAnimatedText then
			Game.sendAnimatedText(pos, text, color)
			return
		end
	
		if pos and pos.sendAnimatedText then
			pos:sendAnimatedText(text, color)
			return
		end
	
		if speaker and speaker.say then
			speaker:say(text, TALKTYPE_MONSTER_SAY, false, nil, pos)
		end
	end
	
	-- Função que mostra o total acumulado de mana leech
	local function showManaLeechBatch(attackerid)
		local attacker = Creature(attackerid)
		if not attacker then
			manaleechBatched[attackerid] = nil
			return
		end
		
		local totalMana = manaleechBatched[attackerid] or 0
		if totalMana > 0 then
			local pos = attacker:getPosition()
			pos:sendMagicEffect(170)
			animatedText(pos, "+" .. totalMana .. " MP", TEXTCOLOR_PURPLE, attacker)
		end
		
		-- Limpa o batch
		manaleechBatched[attackerid] = nil
	end
	
	function manaLeechConcat(attackerid, manatoadd)
		if Creature(attackerid) then
			local attacker = Creature(attackerid)
			local manaBefore = attacker:getMana()
			local maxMana = attacker:getMaxMana()
			
			-- Aplica o mana leech
			attacker:addMana(manatoadd)
			
			-- Verifica quanto mana foi realmente recuperado
			local manaAfter = attacker:getMana()
			local actualManaGained = manaAfter - manaBefore
			
			-- Se o player estava com mana cheia, não ganhou nada
			if manaBefore >= maxMana then
				actualManaGained = 0
			elseif manaAfter > maxMana then
				-- Se ultrapassou o máximo, ajusta para o valor real ganho
				actualManaGained = maxMana - manaBefore
			end
			
			-- Acumula o mana ganho
			if attacker:isPlayer() and actualManaGained > 0 then
				-- Inicializa o batch se não existir
				if not manaleechBatched[attackerid] then
					manaleechBatched[attackerid] = 0
					-- Agenda para mostrar depois do delay
					addEvent(showManaLeechBatch, BATCH_DELAY, attackerid)
				end
				
				-- Acumula o valor
				manaleechBatched[attackerid] = manaleechBatched[attackerid] + actualManaGained
			end
		end
	end
	
	-- Função que mostra o total acumulado de life leech
	local function showLifeLeechBatch(attackerid)
		local attacker = Creature(attackerid)
		if not attacker then
			lifeleechBatched[attackerid] = nil
			return
		end
		
		local totalLife = lifeleechBatched[attackerid] or 0
		if totalLife > 0 then
			local pos = attacker:getPosition()
			pos:sendMagicEffect(CONST_ME_MAGIC_RED)
			animatedText(pos, "+" .. totalLife .. " HP", TEXTCOLOR_GREEN, attacker)
		end
		
		-- Limpa o batch
		lifeleechBatched[attackerid] = nil
	end
	
	-- Life leech (acumulado)
	function lifeLeechConcat(attackerid, lifetoadd)
		if Creature(attackerid) then
			local attacker = Creature(attackerid)
			local healthBefore = attacker:getHealth()
			local maxHealth = attacker:getMaxHealth()
			
			-- Aplica o life leech
			attacker:addHealth(lifetoadd)
			
			-- Verifica quanto health foi realmente recuperado
			local healthAfter = attacker:getHealth()
			local actualHealthGained = healthAfter - healthBefore
			
			-- Se o player estava com vida cheia, não ganhou nada
			if healthBefore >= maxHealth then
				actualHealthGained = 0
			elseif healthAfter > maxHealth then
				-- Se ultrapassou o máximo, ajusta para o valor real ganho
				actualHealthGained = maxHealth - healthBefore
			end
			
			-- Acumula o life ganho
			if attacker:isPlayer() and actualHealthGained > 0 then
				-- Inicializa o batch se não existir
				if not lifeleechBatched[attackerid] then
					lifeleechBatched[attackerid] = 0
					-- Agenda para mostrar depois do delay
					addEvent(showLifeLeechBatch, BATCH_DELAY, attackerid)
				end
				
				-- Acumula o valor
				lifeleechBatched[attackerid] = lifeleechBatched[attackerid] + actualHealthGained
			end
		end
	end
	
	
	-- Check player slots and get resistence information	
	function getResistences(resistanceitemdesc, resistances, attackerisplayer)
		for k,v in pairs(resistances) do
			-- Get custom roll resistances
			if string.match(resistanceitemdesc, "%[" .. v.String .. " Resistance") then
				v.Custom = v.Custom + (string.match(resistanceitemdesc, '%[' .. v.String .. ' Resistance: %+(%d+)%%%]') or 0)
			end
			-- If attacker is player roll native rolls so custom elemental rolls are reduced by that as-well
			if attackerisplayer then
				-- Get natural item resistances, can't do it through native TFS functions properly (so it's pulled from description)
				local nativeResist = v.String:lower()
				if string.match(resistanceitemdesc, nativeResist .. " ([+-]%d+)%%") then
					local nativePercent = string.match(resistanceitemdesc, nativeResist .. " ([+-]%d+)%%")
					v.Native = v.Native + nativePercent
				end
			end
		end
	end
	
	-- Stun animation loop
	function stunanimation(stunnedcreature, stunnedpos, counter)
		if counter ~= 0 and Creature(stunnedcreature) then
			stunnedpos:sendMagicEffect(CONST_ME_STUN)
			counter = counter - 1
			stunnedcreature = Creature(stunnedcreature).uid
			addEvent(stunanimation, 500, stunnedcreature, stunnedpos, counter)
		end
	end
	
	-- Stun condition
	function stunTarget(itemdesc, stunduration)
		if not Creature(stuncreature) then
			return false
		end
		
		-- Convert back to userdata
		local stuncreature = Creature(stuncreature)
		if stuncreature:isPlayer() then
			stunduration = stunduration / 2
		end
		-- Stun
		--local stun = Condition(CONDITION_STUN)
		--stun:setParameter(CONDITION_PARAM_TICKS, stunduration)
		
		-- Mute
		local mute = Condition(CONDITION_MUTED)
		mute:setParameter(CONDITION_PARAM_TICKS, stunduration)
		
		-- Apply conditions
		--stuncreature:addCondition(stun)
		stuncreature:addCondition(mute)
		
		-- Run animation
		-- print("[STUN] "..stuncreature:getName().." recebeu stun de "..stunduration.."ms")
		addEvent(stunAnimation, 0, stuncreature.uid, stuncreature:getPosition(), (stunduration / 1000) * 2)
	end
	
	-- Input damage, it's type and creature immunites/resistances - output reduced damage
	function filterResistance(damage, damageType, immunity, resistance)
		-- adjust by monster resistance
		if resistance[damageType] then
			local resistancePercent = (100 - resistance[damageType])
			damage = (resistancePercent / 100) * damage
		end
		-- set it to 0 if monster is immune
		if bit.band(immunity, damageType) == damageType then
			damage = 0
		end
		return math.floor(damage)
	end
	
	-- Roll elemental damage
	function elementalDmg(weaponDescription, elementType, extraAnimation, creature, resistances, primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll)
		
		-- Get damage from item
		local dmgmin, dmgmax = string.match(weaponDescription, '%[Enhanced ' .. resistances[elementType].String .. ' Damage: (%d+)%-(%d+)%]')
		local eleDmg = (math.random(dmgmin, dmgmax))
	
		-- Damage reduction
		if creature:isMonster() then -- If monster is resistant to elementType, adjust the added elemental damage
			local resistance = creature:getType():getElementList()
			local immunity = creature:getType():getCombatImmunities()
			eleDmg = filterResistance(eleDmg, elementType, immunity, resistance)
		elseif creature:isPlayer() then -- PVP
			-- If player, halve the damage
			eleDmg = eleDmg / 2
			-- If about to add elemental damage, check custom and vanilla resistence and adjust
			if (resistances[elementType].Native + resistances[elementType].Custom ~= 0) then
				local resistancePercent = (100 - (resistances[elementType].Custom + resistances[elementType].Native))
				eleDmg = (resistancePercent / 100) * eleDmg
			end
		end
		
		-- Apply damage
		if eleDmg ~= 0 then -- only do this if damage is actually applied
			-- Animation
			if extraAnimation == true then
				local pos = creature:getPosition()
				local EFFECT_TYPE = 0
				if elementType == COMBAT_FIREDAMAGE then
					EFFECT_TYPE = CONST_ME_FIREATTACK
				elseif elementType == COMBAT_ENERGYDAMAGE then
					EFFECT_TYPE = CONST_ME_ENERGYAREA
				end
				pos:sendMagicEffect(EFFECT_TYPE)
			end
			
			-- Previous elemental damage
			if elementalroll then
				if primaryType == elementType then -- 'secondary' damage is the same, just add to it
					primaryDamage = primaryDamage + eleDmg
				else -- add to 'main' damage and overwrite its type
					if primaryType == 0 then -- is this  wand?
						if secondaryType == elementType then -- is the wand damage the same type?
							secondaryDamage = secondaryDamage + eleDmg
						else -- no it's not, make use of empty primaryValues
							primaryDamage = eleDmg
							primaryType = elementType
						end
					else -- not a wand, add eleDmg and change from physical to elementType
						secondaryDamage = secondaryDamage + eleDmg
						secondaryType = elementType
					end
				end
			else -- This is the first elemental roll on this weapon
				local originalDamage = primaryDamage
				local originalType = primaryType
				
				-- Swap primary & secondary types
				primaryDamage = secondaryDamage + eleDmg
				primaryType = elementType
				secondaryDamage = originalDamage
				secondaryType = originalType
				
				-- damageTypes have been swapped, flag it
				elementalroll = true
			end
		end
		return primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll
	end
												
	function statChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	
		-- Defaults
		local chance = 0 -- Crit Chance
		local spellmodifier = 0 -- Spell Damage
		local manaleech = 0
		local lifeleech = 0
		local stunDuration = 2000
		local sourceDamage = primaryDamage -- Used for multi-shot when secondary targets are immune
		local elementalroll = false -- Flag for if weapon has an element on it
		local doubleroll = false -- Flag for if the weapon has two elements on it
		--local dawnbreaker = false
		--local rainbowshield = false
		
		-- What elements should be checked when calculating resistances
		local resistances = {
			[COMBAT_PHYSICALDAMAGE] = {Native = 0, Custom = 0, String = "Physical"},
			[COMBAT_FIREDAMAGE] = {Native = 0, Custom = 0, String = "Fire"},
			[COMBAT_ICEDAMAGE] = {Native = 0, Custom = 0, String = "Ice"},
			[COMBAT_ENERGYDAMAGE] = {Native = 0, Custom = 0, String = "Energy"},
			[COMBAT_POISONDAMAGE] = {Native = 0, Custom = 0, String = "Poison"},
			[COMBAT_DEATHDAMAGE] = {Native = 0, Custom = 0, String = "Death"}
		}
		
		-- Check resistences if victim is a player before applying extra elemental damage below
		if creature:isPlayer() then
			for i = 1,#checkallslots do
				if creature:getSlotItem(checkallslots[i]) ~= nil then
					local resistanceitem = creature:getSlotItem(checkallslots[i])
					local resistanceitemdesc = resistanceitem:getDescription()
					getResistences(resistanceitemdesc, resistances, true)
				end
			end
			
			 -- Reduce main damage on custom resistance rolls before applying extra elemental damage below
			if primaryType ~= 0 then
				if resistances[primaryType] then
					if resistances[primaryType].Custom ~= 0 then
						local resistancePercent = (100 - resistances[primaryType].Custom)
						-- print("[RESIST] "..creature:getName().." recebeu "..math.floor((resistancePercent / 100) * primaryDamage).." de dano "..resistances[primaryType].String.." (original: "..math.floor(primaryDamage)..", resistência: "..(100 - resistancePercent).."%)")
						primaryDamage = (resistancePercent / 100) * primaryDamage
					end
				end
			end
			if secondaryType ~= 0 then
				if resistances[secondaryType] then
					if resistances[secondaryType].Custom ~= 0 then
						local resistancePercent = (100 - resistances[secondaryType].Custom)
						secondaryDamage = (resistancePercent / 100) * secondaryDamage
					end
				end
			end
	
		-- ========== APPLY BASE PROTECTION (items.xml absorbPercent) FOR ALL ELEMENTS ==========
		-- This must be applied BEFORE custom resistances from forge!
		
		if attacker then -- Apply for both PvE and PvP
			-- Helper function to get absorbPercent from item description (more reliable)
			local function getElementAbsorbFromDesc(itemDesc, combatType)
				local elementNames = {
					[COMBAT_PHYSICALDAMAGE] = "physical",
					[COMBAT_FIREDAMAGE] = "fire",
					[COMBAT_ICEDAMAGE] = "ice",
					[COMBAT_ENERGYDAMAGE] = "energy",
					[COMBAT_EARTHDAMAGE] = "earth",
					[COMBAT_DEATHDAMAGE] = "death",
					[COMBAT_HOLYDAMAGE] = "holy"
				}
				
				local absorb = 0
				
				-- Check for "protection all +X%"
				local allProtection = itemDesc:match("protection all %+(%d+)%%")
				if allProtection then
					absorb = absorb + tonumber(allProtection)
				end
				
				-- Check for specific element "fire +X%", "ice +X%", etc
				local elementName = elementNames[combatType]
				if elementName then
					local elementProtection = itemDesc:match(elementName .. " ([+-]%d+)%%")
					if elementProtection then
						absorb = absorb + tonumber(elementProtection)
					end
				end
				
				return absorb
			end
			
			-- Calculate total base protection for primary damage
			if primaryType ~= 0 then
				local totalBaseProtection = 0
				for i = 1, #checkallslots do
					local slotItem = creature:getSlotItem(checkallslots[i])
					if slotItem then
						local itemDesc = slotItem:getDescription()
						totalBaseProtection = totalBaseProtection + getElementAbsorbFromDesc(itemDesc, primaryType)
					end
				end
				if totalBaseProtection > 0 then
					local factor = (100 - totalBaseProtection) / 100
					primaryDamage = primaryDamage * factor
				end
			end
			
			-- Calculate total base protection for secondary damage
			if secondaryType ~= 0 then
				local totalBaseProtection = 0
				for i = 1, #checkallslots do
					local slotItem = creature:getSlotItem(checkallslots[i])
					if slotItem then
						local itemDesc = slotItem:getDescription()
						totalBaseProtection = totalBaseProtection + getElementAbsorbFromDesc(itemDesc, secondaryType)
					end
				end
				if totalBaseProtection > 0 then
					local factor = (100 - totalBaseProtection) / 100
					secondaryDamage = secondaryDamage * factor
				end
			end
		end
	end
	
		if attacker then -- Ignore HP changes from healing fountains, terrain elemental fields (neutral sources basically)
			if attacker:isPlayer() then
				if origin == ORIGIN_RANGED or origin == ORIGIN_MELEE then -- Skip if player is using spells
					-- Natural elemental damage (wand, fire sword, flaming arrow etc) swap Types around for better visuals and set flags
					if secondaryType ~= 0 or primaryType ~= COMBAT_PHYSICALDAMAGE then
						-- Cache original physical damage
						local originalDamage = primaryDamage
						local originalType = primaryType
						
						-- Swap primary & secondary
						primaryDamage = secondaryDamage
						primaryType = secondaryType
						secondaryDamage = originalDamage
						secondaryType = originalType
						
						-- damageTypes have been swapped, flag it
						elementalroll = true
					end
					
					-- Check weapons for crit/elemental damage
					for i = 1,#checkweaponslots do -- Roll for each slot
						if attacker:getSlotItem(checkweaponslots[i]) ~= nil then
							local slotitem = attacker:getSlotItem(checkweaponslots[i])
							if slotitem and ((checkweaponslots[i] == CONST_SLOT_AMMO and allowedSlotItems[slotitem:getId()]) or checkweaponslots[i] ~= CONST_SLOT_AMMO)then
	
								local slotitemdesc = slotitem:getDescription()
								-- Verificar dano elemental
								if slotitemdesc:find("%[Enhanced Fire Damage") then
									primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll = elementalDmg(slotitemdesc, COMBAT_FIREDAMAGE, true, creature, resistances, primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll)
	
									-- 33% de chance de aplicar queimadura
									if math.random(1, 3) == 3 then
										local condition = createConditionObject(CONDITION_FIRE)
										local burnDamage = 20
	
										-- Ajustar dano de queimadura com base nas resistências
										if creature:isPlayer() then
											if resistances[COMBAT_FIREDAMAGE].Custom ~= 0 or resistances[COMBAT_FIREDAMAGE].Native ~= 0 then
												local resistancePercent = (100 - (resistances[COMBAT_FIREDAMAGE].Custom + resistances[COMBAT_FIREDAMAGE].Native))
												burnDamage = (resistancePercent / 100) * burnDamage
											end
										elseif creature:isMonster() then
											local resistance = creature:getType():getElementList()
											local immunity = creature:getType():getCombatImmunities()
	
											-- Ajustar dano de queimadura com base nas resistências do monstro
											if resistance[COMBAT_FIREDAMAGE] then
												local resistancePercent = (100 - resistance[COMBAT_FIREDAMAGE])
												burnDamage = (resistancePercent / 100) * burnDamage
											end
	
											-- Se o monstro for imune ao dano de fogo, definir dano de queimadura como zero
											if bit.band(immunity, COMBAT_FIREDAMAGE) == COMBAT_FIREDAMAGE then
												burnDamage = 0
											end
										end
	
										-- Se o dano de queimadura não for zero, criar condição e aplicar ao alvo
										if burnDamage ~= 0 then
											addDamageCondition(condition, 10, 2000, burnDamage)
											setConditionParam(condition, CONDITION_PARAM_DELAYED, true)
											doTargetCombatCondition(attacker, creature, condition, CONST_ME_FIRE)
										end
									end
								end
								if slotitemdesc:find "%[Enhanced Ice Damage" then
									primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll = elementalDmg(slotitemdesc, COMBAT_ICEDAMAGE, false, creature, resistances, primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll)
									if math.random(1,5) == 5 then -- 20% to paralyze/slow
										local condition = createConditionObject(CONDITION_PARALYZE)
										setConditionParam(condition, CONDITION_PARAM_TICKS, 3000)
										setConditionParam(condition, CONDITION_PARAM_SPEED, -300)
										doTargetCombatCondition(attacker, creature, condition, CONST_ME_MAGIC_ICEAREA)
									end
								end
								if slotitemdesc:find "%[Enhanced Energy Damage" then
									primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll = elementalDmg(slotitemdesc, COMBAT_ENERGYDAMAGE, true, creature, resistances, primaryDamage, primaryType, secondaryDamage, secondaryType, elementalroll)
								end
								
								-- Check crit chance of slots and add together
								if slotitemdesc:find "%[Crit Chance" then
									local crit = tonumber(string.match(slotitemdesc, "Crit Chance: %+?(%d+)%%")) or 0
									chance = chance + crit
								end
								
								-- Mana leech gather % (chance de ativar)
								if slotitemdesc:find "%[Mana Leech" then
									local manaleechChance = tonumber(string.match(slotitemdesc, '%[Mana Leech: %+(%d+)%%%]')) or 0
									if math.random(100) <= manaleechChance then
										local level = attacker:getLevel()
										local manatoadd = 0
										if level <= 100 then
											manatoadd = 25
										elseif level <= 200 then
											manatoadd = 35
										elseif level <= 300 then
											manatoadd = 45
										elseif level <= 400 then
											manatoadd = 55
										elseif level <= 500 then
											manatoadd = 65
										elseif level <= 600 then
											manatoadd = 75
										elseif level <= 700 then
											manatoadd = 85
										else
											manatoadd = 100
										end
										manaLeechConcat(attacker.uid, manatoadd)
									end
								end
								
								-- Life leech gather % (chance de ativar)
								if slotitemdesc:find "%[Life Leech" then
									local lifeleechChance = tonumber(string.match(slotitemdesc, '%[Life Leech: %+(%d+)%%%]')) or 0
									if math.random(100) <= lifeleechChance then
										local level = attacker:getLevel()
										local lifetoadd = 0
										if level <= 100 then
											lifetoadd = 20
										elseif level <= 200 then
											lifetoadd = 30
										elseif level <= 300 then
											lifetoadd = 45
										elseif level <= 400 then
											lifetoadd = 60
										elseif level <= 500 then
											lifetoadd = 75
										elseif level <= 600 then
											lifetoadd = 90
										elseif level <= 700 then
											lifetoadd = 105
										elseif level <= 800 then
											lifetoadd = 120
										elseif level <= 900 then
											lifetoadd = 135
										elseif level <= 1000 then
											lifetoadd = 150
										elseif level <= 1100 then
											lifetoadd = 165
										elseif level <= 1200 then
											lifetoadd = 180
										elseif level <= 1300 then
											lifetoadd = 195
										elseif level <= 1400 then
											lifetoadd = 210
										elseif level <= 1500 then
											lifetoadd = 225
										elseif level <= 1600 then
											lifetoadd = 240
										elseif level <= 1700 then
											lifetoadd = 255
										elseif level <= 1800 then
											lifetoadd = 270
										elseif level <= 1900 then
											lifetoadd = 285
										elseif level <= 2000 then
											lifetoadd = 285
										else
											lifetoadd = 300
										end
										lifeLeechConcat(attacker.uid, lifetoadd)
									end
								end
								
								-- Stun Chance
								if slotitemdesc:find "%[Stun Chance" then
									local stunchance = tonumber(string.match(slotitemdesc, '%[Stun Chance: %+(%d+)%%%]')) or 0
									local rollchance = math.random(1,100)
									if stunchance >= rollchance and attacker ~= creature then
										stunTarget(creature.uid, stunDuration)
									end
								end
									
								-- Multi-shot
								if slotitemdesc:find "%[Multi Shot" then
									if attacker:getSlotItem(CONST_SLOT_AMMO) ~= nil then -- Does player have ammo
										local multishot = tonumber(string.match(slotitemdesc, "%[Multi Shot: %+(%d+)%]"))
										local ammoSlot = attacker:getSlotItem(CONST_SLOT_AMMO).itemid
										local validammo = false
										for k,v in pairs(animation) do
											if k == ammoSlot then
												validammo = true -- Ammo they're using exists in animation table
												break
											end
										end
										if validammo then -- (!) You may need to add more CONST_ANI_XXXX animations to the animation table
											local targetpos = creature:getPosition()
											local targets = getSpectators(targetpos, 2, 2) -- get possible multi-shot targets
											local victims = {}
											if targets ~= nil then
												-- do the shuffle
												shuffle(targets)
												for i = 1,#targets do
													local target = Creature(targets[i])
													if target:isMonster() then -- only target monsters
														if isSightClear(attacker:getPosition(), target:getPosition()) then -- that are in sight
															if target:getPosition() ~= targetpos then -- ignore the original target
																local victimcount = #victims or 0
																if victimcount < multishot then
																	table.insert(victims, target) -- collate valid targets into victims table
																else
																	break -- exit the for loop, have enough targets
																end
															end
														end
													end
												end
											end
										-- this a rats nest due to swapping primaryType/secondaryType above for visuals
											if victims ~= nil then
												for i = 1, #victims do
													-- Defaults
													local damage = 0
													local elementalDamage = 0
													local backupDamage = 0
													local mainType = primaryType
													local altType = secondaryType
													local resistance = victims[i]:getType():getElementList()
													local immunity = victims[i]:getType():getCombatImmunities()
													local distanceEffect = animation[ammoSlot]
	
													-- Animation
													attacker:getPosition():sendDistanceEffect(victims[i]:getPosition(), animation[ammoSlot])
	
													-- Damage calculation
													if elementalroll then -- Check if types are swapped
														mainType = secondaryType
														altType = primaryType
														damage = filterResistance(secondaryDamage, secondaryType, immunity, resistance)
														elementalDamage = filterResistance(primaryDamage, primaryType, immunity, resistance)
													else -- Types haven't been swapped
														damage = filterResistance(primaryDamage, primaryType, immunity, resistance)
														elementalDamage = filterResistance(secondaryDamage, secondaryType, immunity, resistance)
													end
	
													-- Apply secondary damage if any
													if elementalDamage ~= 0 then
														doTargetCombatHealth(attacker, victims[i], altType, math.ceil((80 / 100) * elementalDamage), elementalDamage)
													end
													-- Aplicar crítico individualmente
													local critRoll = math.random(100)
													if critRoll <= chance then
														victims[i]:getPosition():sendMagicEffect(criteffect)
														damage = damage * critmodifier
														elementalDamage = elementalDamage * critmodifier
														-- print("[CRIT] "..attacker:getName().." acertou crítico em "..victims[i]:getName().."! Chance: "..chance.."%")
													end
													-- Apply main damage if any
													if damage ~= 0 then
														doTargetCombatHealth(attacker, victims[i], mainType, math.ceil((80 / 100) * damage), damage)
													else -- No damage; fallback to original physical damage
														backupDamage = filterResistance(sourceDamage, COMBAT_PHYSICALDAMAGE, immunity, resistance)
														if backupDamage ~= 0 then -- Try rolling back to base physical damage
															doTargetCombatHealth(attacker, victims[i], COMBAT_PHYSICALDAMAGE, math.ceil((80 / 100) * sourceDamage), sourceDamage)
														else -- Monster is immune to physical damage too
															victims[i]:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
					
									-- Roll crit chance e aplica ao dano total final (funciona para qualquer origem)
					if chance > 0 then
						if math.random(100) <= chance then
							local pos = creature:getPosition()
							pos:sendMagicEffect(criteffect)
								-- print("[CRIT] "..attacker:getName().." deu crítico! Chance: "..chance.."% - Dano Final: "..(primaryDamage + secondaryDamage))
							-- Aplica o crit como multiplicador no final
							primaryDamage = primaryDamage * critmodifier
							secondaryDamage = secondaryDamage * critmodifier
						end
					end
	
	
				elseif origin == ORIGIN_SPELL then	
					-- Reduce spell damage based on custom resistances
					if resistances[primaryType] then
						if resistances[primaryType].Custom ~= 0 then
							local resistancePercent = (100 - resistances[primaryType].Custom)
							-- print("[RESIST] "..creature:getName().." recebeu "..math.floor((resistancePercent / 100) * primaryDamage).." de dano "..resistances[primaryType].String.." (original: "..math.floor(primaryDamage)..", resistência: "..(100 - resistancePercent).."%)")
							primaryDamage = (resistancePercent / 100) * primaryDamage
						end
					end 
					
					-- Check slots that can roll the following attributes
					for i = 1,#checkweaponslots do
						if attacker:getSlotItem(checkweaponslots[i]) ~= nil then
							local slotitem = attacker:getSlotItem(checkweaponslots[i])
							if slotitem and ((checkweaponslots[i] == CONST_SLOT_AMMO and allowedSlotItems[slotitem:getId()]) or checkweaponslots[i] ~= CONST_SLOT_AMMO)then
	
								local slotitemdesc = slotitem:getDescription()
								
								-- Check crit chance of slots and add together
								if slotitemdesc:find "%[Spell Damage" then
									local spellDamage = tonumber(string.match(slotitemdesc, "Spell Damage: [+-](%d+)%%")) or 0
									spellmodifier = spellmodifier + spellDamage
									-- print("[SPELL ATTR] "..attacker:getName().." está com +"..spellDamage.."% spell damage.")
								end
								
								-- Mana leech gather % (chance de ativar)
								if slotitemdesc:find "%[Mana Leech" then
									local manaleechChance = tonumber(string.match(slotitemdesc, '%[Mana Leech: %+(%d+)%%%]')) or 0
									if math.random(100) <= manaleechChance then
										local level = attacker:getLevel()
										local manatoadd = 0
										if level <= 100 then
											manatoadd = 15
										elseif level <= 200 then
											manatoadd = 25
										elseif level <= 300 then
											manatoadd = 35
										elseif level <= 400 then
											manatoadd = 45
										elseif level <= 500 then
											manatoadd = 55
										elseif level <= 600 then
											manatoadd = 65
										elseif level <= 700 then
											manatoadd = 75
										else
											manatoadd = 85
										end
										manaLeechConcat(attacker.uid, manatoadd)
									end
								end
								
								-- Life leech gather % (chance de ativar)
								if slotitemdesc:find "%[Life Leech" then
									local lifeleechChance = tonumber(string.match(slotitemdesc, '%[Life Leech: %+(%d+)%%%]')) or 0
									if math.random(100) <= lifeleechChance then
										local level = attacker:getLevel()
										local lifetoadd = 0
										if level <= 100 then
											lifetoadd = 20
										elseif level <= 200 then
											lifetoadd = 30
										elseif level <= 300 then
											lifetoadd = 45
										elseif level <= 400 then
											lifetoadd = 60
										elseif level <= 500 then
											lifetoadd = 75
										elseif level <= 600 then
											lifetoadd = 90
										elseif level <= 700 then
											lifetoadd = 105
										elseif level <= 800 then
											lifetoadd = 120
										elseif level <= 900 then
											lifetoadd = 135
										elseif level <= 1000 then
											lifetoadd = 150
										elseif level <= 1100 then
											lifetoadd = 165
										elseif level <= 1200 then
											lifetoadd = 180
										elseif level <= 1300 then
											lifetoadd = 195
										elseif level <= 1400 then
											lifetoadd = 210
										elseif level <= 1500 then
											lifetoadd = 225
										elseif level <= 1600 then
											lifetoadd = 240
										elseif level <= 1700 then
											lifetoadd = 255
										elseif level <= 1800 then
											lifetoadd = 270
										elseif level <= 1900 then
											lifetoadd = 285
										elseif level <= 2000 then
											lifetoadd = 285
										else
											lifetoadd = 300
										end
										lifeLeechConcat(attacker.uid, lifetoadd)
									end
								end
								
								-- Stun Chance
								if slotitemdesc:find "%[Stun Chance" then
									local stunchance = tonumber(string.match(slotitemdesc, '%[Stun Chance: %+(%d+)%%%]')) or 0
									local rollchance = math.random(1,100)
									if stunchance >= rollchance and attacker ~= creature then
										stunTarget(creature.uid, stunDuration)
									end
								end
							end
						end
					end
					
					-- if using a +%spelldamage wand, adjust damage
					-- Desabilitar bônus de Spell Damage em PvP
						if creature:isPlayer() then
							spellmodifier = 0
						end				
					if spellmodifier > 0 then
						local extraDamage = (spellmodifier / 150) * primaryDamage
						primaryDamage = primaryDamage + extraDamage
					-- print("[SPELL] "..attacker:getName().." causou dano mágico aumentado: "..math.floor(primaryDamage).." (+"..spellmodifier.."%)")
					end
					
					-- Mana leech e Life leech agora são aplicados diretamente nos loops acima
				end
			end
		end
		
		--[[
		-- If rainbow shield
		if rainbowshield then
			local rainbowTransformation = 0
			local rainbowTransformations = {
				[COMBAT_FIREDAMAGE] = 8906,
				[COMBAT_ICEDAMAGE] = 8907,
				[COMBAT_ENERGYDAMAGE] = 8908,
				[COMBAT_EARTHDAMAGE] = 8909
			}
			
			-- Check primary first
			if primaryType ~= 0 then
				if rainbowTransformations[primaryType] then
					rainbowTransformation = rainbowTransformations[primaryType]
				end
			end
			
			-- Check secondary second (This prioritizes secondaryType which is what we want)
			if secondaryType ~= 0 then
				if rainbowTransformations[secondaryType] then
					rainbowTransformation = rainbowTransformations[secondaryType]
				end
			end
			-- Transform rainbow shield
			if rainbowTransformation ~= 0 then
				rainbowshield:transform(rainbowTransformation)
				rainbowshield:decay()
			end
		end
		--]]
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
	end
	
	function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		if primaryType ~= 128 then -- Ignore health potions
			primaryDamage, primaryType, secondaryDamage, secondaryType, origin = statChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin) -- This is for feeding both onHealthChange and onManaChange through the same damage/buff formula
		end
	-- ⚠️ TRATAMENTO FORÇADO PARA SPELLS/RUNAS SEM ORIGIN DEFINIDO
	if primaryType ~= 128 and attacker and attacker:isPlayer() then -- only prevfent healing
		local spellmodifier = 0
		local manaleech = 0
		local lifeleech = 0
		local chance = 0
		local critmodifier = 1.6
		local criteffect = 173
	
		for i = 1,#checkweaponslots do
			local slotitem = attacker:getSlotItem(checkweaponslots[i])
			if slotitem and ((checkweaponslots[i] == CONST_SLOT_AMMO and allowedSlotItems[slotitem:getId()]) or checkweaponslots[i] ~= CONST_SLOT_AMMO)then
				local slotitemdesc = slotitem:getDescription()
				
				if slotitemdesc:find "%[Spell Damage" then
					local spellDamage = tonumber(string.match(slotitemdesc, "Spell Damage: [+-](%d+)%%")) or 0
					spellmodifier = spellmodifier + spellDamage
				end
	
				if slotitemdesc:find "%[Crit Chance" then
					local crit = tonumber(string.match(slotitemdesc, "Crit Chance: %+?(%d+)%%")) or 0
					chance = chance + crit
				end
	
				if slotitemdesc:find "%[Mana Leech" then
					local manaleechChance = tonumber(string.match(slotitemdesc, '%[Mana Leech: %+(%d+)%%%]')) or 0
					if math.random(100) <= manaleechChance then
						local level = attacker:getLevel()
						local manatoadd = 0
						if level <= 100 then
							manatoadd = 15
						elseif level <= 200 then
							manatoadd = 25
						elseif level <= 300 then
							manatoadd = 35
						elseif level <= 400 then
							manatoadd = 45
						elseif level <= 500 then
							manatoadd = 55
						elseif level <= 600 then
							manatoadd = 65
						elseif level <= 700 then
							manatoadd = 75
						else
							manatoadd = 85
						end
						manaLeechConcat(attacker.uid, manatoadd)
					end
				end
	
				if slotitemdesc:find "%[Life Leech" then
					local lifeleechChance = tonumber(string.match(slotitemdesc, '%[Life Leech: %+(%d+)%%%]')) or 0
					if math.random(100) <= lifeleechChance then
						local level = attacker:getLevel()
						local lifetoadd = 0
						if level <= 100 then
							lifetoadd = 20
						elseif level <= 200 then
							lifetoadd = 30
						elseif level <= 300 then
							lifetoadd = 45
						elseif level <= 400 then
							lifetoadd = 60
						elseif level <= 500 then
							lifetoadd = 75
						elseif level <= 600 then
							lifetoadd = 90
						elseif level <= 700 then
							lifetoadd = 105
						elseif level <= 800 then
							lifetoadd = 120
						elseif level <= 900 then
							lifetoadd = 135
						elseif level <= 1000 then
							lifetoadd = 150
						elseif level <= 1100 then
							lifetoadd = 165
						elseif level <= 1200 then
							lifetoadd = 180
						elseif level <= 1300 then
							lifetoadd = 195
						elseif level <= 1400 then
							lifetoadd = 210
						elseif level <= 1500 then
							lifetoadd = 225
						elseif level <= 1600 then
							lifetoadd = 240
						elseif level <= 1700 then
							lifetoadd = 255
						elseif level <= 1800 then
							lifetoadd = 270
						elseif level <= 1900 then
							lifetoadd = 285
						elseif level <= 2000 then
							lifetoadd = 285
						else
							lifetoadd = 300
						end
						lifeLeechConcat(attacker.uid, lifetoadd)
					end
				end
			end
			::continue::
		end
	
		-- Aplica o crítico
		if chance > 0 then
			if math.random(100) <= chance then
				primaryDamage = primaryDamage * critmodifier
				secondaryDamage = secondaryDamage * critmodifier
				creature:getPosition():sendMagicEffect(criteffect)
				-- print("[CRIT] "..attacker:getName().." deu crítico! Chance: "..chance.."%")
			end
		end
	
		-- Aplica spell damage
		if spellmodifier > 0 then
			local extraDamage = (spellmodifier / 100) * primaryDamage
			primaryDamage = primaryDamage + extraDamage
			-- print("[SPELL] +"..spellmodifier.."% aplicado. Dano final: "..math.floor(primaryDamage))
		end
	
		-- Mana leech e Life leech agora são aplicados diretamente nos loops acima
	end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
	end
	
	function onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	
		if primaryType ~= 64 then -- Ignore mana potions
			primaryDamage, primaryType, secondaryDamage, secondaryType, origin = statChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin) -- This is for feeding both onHealthChange and onManaChange through the same damage/buff formula
			
			-- Apply magic shield bonus, even if neutral source
			if creature:isPlayer() then
				local manashield = 0
				for i = 1,#checkweaponslots do
					if creature:getSlotItem(checkweaponslots[i]) ~= nil then
						local slotitem = creature:getSlotItem(checkweaponslots[i])
						if slotitem and ((checkweaponslots[i] == CONST_SLOT_AMMO and allowedSlotItems[slotitem:getId()]) or checkweaponslots[i] ~= CONST_SLOT_AMMO)then
							local slotitemdesc = slotitem:getDescription()
							if slotitemdesc:find "%[Mana Shield" then
								manashield = manashield + tonumber(string.match(slotitemdesc, '%[Mana Shield: %+(%d+)%%%]'))
							end
						end
					end
				end
				if manashield ~= 0 then
					local shieldPercent = (100 - manashield)
					primaryDamage = (shieldPercent / 100) * primaryDamage
					secondaryDamage = (shieldPercent / 100) * secondaryDamage
				end
			end
			
		end
		
		return primaryDamage, primaryType, secondaryDamage, secondaryType, origin
	end