-- by Naze to tibia king
local config = {
			{livro = 1950, text = "texto1", chance = 80}, -- ID DO LIVRO, TEXTO DO LIVRO, CHANCE DE DROP 
			{livro = 1955, text = "texto2", chance = 80},
			{livro = 1960, text = "texto3", chance = 80},
			{livro = 1961, text = "texto4", chance = 80}
}

function onDeath(cid, corpse, killers)
	if isMonster(cid) then
	local result = config[math.random(1, #config)]
	if math.random(1,100) <= result.chance then
	local corps = doAddContainerItem(corpse.uid, result.livro, 1)
	doSetItemText(corps, result.text)
	end
	end
return true
end