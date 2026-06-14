

local config = {
	BoxId = 2023,
	Ladder = 1386,
	LadderPos = Position(32757, 31905, 14)
}
 
 
 
function onAddItem(moveitem, tileitem, position)
--print(moveitem:getId(), "testando")
	if moveitem:getId() == config.BoxId then
		Game.createItem(config.Ladder, 1, config.LadderPos)
	end
end
 
 
function onRemoveItem(item, tile, position)
--print(item:getId(), "testando")
	if item:getId() == config.BoxId then  	
		local itemRemove = Tile(config.LadderPos):getItemById(config.Ladder)
		if itemRemove then
			itemRemove:remove()
		end
	end
end