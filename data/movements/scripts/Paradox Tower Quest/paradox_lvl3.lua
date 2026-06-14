

local config = {
	BoxId = 1739,
	Ladder = 1386,
	LadderPos = Position(32478, 31904, 5)
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