function onUse(cid, item, fromPosition, itemEx, toPosition)
	local outfits = {
		--[[
			Item, storage, nome do outfit, quantidade de addons, male looktype ID,
			female looktype ID, id no outfits.xml, e um novo parâmetro "addons"
		]]
		[6693] = {sto = 95801, name = 'Elf', male = 638, female = 638, addons = 'no'},
		[6695] = {sto = 95803, name = 'Dwarf Guard', male = 636, female = 636, addons = 'no'},
		[6696] = {sto = 95804, name = 'Dwarf Soldier', male = 635, female = 635, addons = 'no'},
		[6697] = {sto = 95805, name = 'Dwarf', male = 634, female = 634, addons = 'no'},
		[6699] = {sto = 95900, name = 'New Citizen', male = 655, female = 656, addons = 'yes'},
		[6700] = {sto = 95901, name = 'Yalaharian', male = 698, female = 697, addons = 'yes'},
		[6701] = {sto = 95902, name = 'New Hunter', male = 657, female = 658, addons = 'yes'},
		[6702] = {sto = 95903, name = 'Pirate', male = 677, female = 678, addons = 'yes'},
		[6703] = {sto = 95904, name = 'New Mage', male = 659, female = 666, addons = 'yes'},
		[6704] = {sto = 95905, name = 'New Knight', male = 661, female = 662, addons = 'yes'},
		[6705] = {sto = 95906, name = 'New Summoner', male = 665, female = 660, addons = 'yes'},
		[6783] = {sto = 95907, name = 'Golden', male = 685, female = 686, addons = 'yes'},
		[6707] = {sto = 95908, name = 'Citizen Advanced', male = 128, female = 136, addons = 'yes'},
		[6708] = {sto = 95909, name = 'Assassin', male = 679, female = 680, addons = 'yes'},
		[6709] = {sto = 95910, name = 'Demonhunter', male = 687, female = 688, addons = 'yes'},
		[6710] = {sto = 95911, name = 'Shaman', male = 683, female = 684, addons = 'yes'},
		[6711] = {sto = 95912, name = 'Norseman', male = 689, female = 690, addons = 'yes'},
		[6712] = {sto = 95913, name = 'Hunter Advanced', male = 129, female = 137, addons = 'yes'},
		[6713] = {sto = 95914, name = 'Beggar', male = 681, female = 682, addons = 'yes'},
		[6714] = {sto = 95915, name = 'Druid', male = 673, female = 674, addons = 'yes'},
		[6715] = {sto = 95916, name = 'Mage Advanced', male = 130, female = 138, addons = 'yes'},
		[6716] = {sto = 95917, name = 'Nightmare', male = 695, female = 696, addons = 'yes'},
		[6717] = {sto = 95918, name = 'Barbarian', male = 669, female = 670, addons = 'yes'},
		[6718] = {sto = 95919, name = 'Oriental', male = 675, female = 676, addons = 'yes'},
		[6719] = {sto = 95920, name = 'Brotherhood', male = 693, female = 694, addons = 'yes'},
		[6720] = {sto = 95921, name = 'Wizard', male = 671, female = 672, addons = 'yes'},
		[6721] = {sto = 95922, name = 'Jersey', male = 701, female = 702, addons = 'no'},
		[6722] = {sto = 95923, name = 'Married', male = 653, female = 654, addons = 'yes'},
		[6777] = {sto = 95924, name = 'Elf Arcanist', male = 640, female = 640, addons = 'no'},
		[6778] = {sto = 95925, name = 'Orc', male = 641, female = 641, addons = 'no'},
		[6789] = {sto = 95926, name = 'Orc Spearman', male = 642, female = 642, addons = 'no'},
		[6790] = {sto = 95927, name = 'Orc Warrior', male = 643, female = 643, addons = 'no'},
		[6791] = {sto = 95928, name = 'Orc Shaman', male = 644, female = 644, addons = 'no'},
		[6792] = {sto = 95929, name = 'Orc Berserker', male = 645, female = 645, addons = 'no'},
		[6793] = {sto = 95930, name = 'Orc Leader', male = 646, female = 646, addons = 'no'},
		[6794] = {sto = 95931, name = 'Orc Warlord', male = 647, female = 647, addons = 'no'},
		[6795] = {sto = 95932, name = 'Minotaur', male = 648, female = 648, addons = 'no'},
		[6796] = {sto = 95933, name = 'Minotaur Archer', male = 649, female = 649, addons = 'no'},
		[6797] = {sto = 95934, name = 'Minotaur Mage', male = 650, female = 650, addons = 'no'},
		[6798] = {sto = 95935, name = 'Minotaur Guard', male = 651, female = 651, addons = 'no'},
		[6800] = {sto = 95937, name = 'dragon slayer', male = 704, female = 705, addons = 'no'},
		-- [6808] = {sto = 95938, name = 'royal costume', male = , female = , addons = 'no'},

	}
	

	local itemid = item:getId()
	local paramsFromItemid = outfits[itemid]
	if paramsFromItemid ~= nil then
		if getPlayerStorageValue(cid, paramsFromItemid.sto) >= 1 then
			doSendMagicEffect(getCreaturePosition(cid), 3)
			doPlayerSendCancel(cid, "You already have this outfit!")
			return true
		elseif getPlayerStorageValue(cid, paramsFromItemid.sto) <= 0 then
			setPlayerStorageValue(cid, paramsFromItemid.sto, 1)
			local outfit = cid:getSex() == PLAYERSEX_FEMALE and paramsFromItemid.female or paramsFromItemid.male
			cid:addOutfitAddon(outfit, 0)
			doSendMagicEffect(getCreaturePosition(cid), 19)
			if paramsFromItemid.addons == 'no' then
				cid:say("Congratulations, now you have the ".. paramsFromItemid.name .." outfits!", TALKTYPE_MONSTER_SAY)
			else
				cid:say("Congratulations, now you have the ".. paramsFromItemid.name .." outfits with full addons!", TALKTYPE_MONSTER_SAY)
			end
			doRemoveItem(item.uid, 1)
			return true
		end
	end


end
