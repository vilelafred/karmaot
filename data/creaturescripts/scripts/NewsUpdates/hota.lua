local cfg = {
    ["morguthis"] = {pos = Position(33174, 32694, 14), toPos = Position(33182, 32717, 14)},
	["vashresamun"] = {pos = Position(33116, 32656, 15), toPos = Position(33145, 32668, 15)},
	["dipthrah"] = {pos = Position(33103, 32590, 15), toPos = Position(33126, 32594, 15)},
	["thalas"] = {pos = Position(33396, 32852, 14), toPos = Position(33349, 32830, 14)},
	["rahemos"] = {pos = Position(33073, 32781, 14), toPos = Position(33051, 32779, 14)},
	["omruc"] = {pos = Position(33195, 32002, 14), toPos = Position(33178, 32018, 14)},
	["mahrdis"] = {pos = Position(33191, 32956, 15), toPos = Position(33174, 32937, 15)},
}


local function removeTeleport(pos)

    local tp = Tile(pos):getItemById(1387)
	if tp then
		tp:remove()
	end
end


function onDeath(creature, corpse, deathList)

local nme = creature:getName():lower()
    if cfg[nme] then
        local teleport = Game.createItem(1387, -1, cfg[nme].pos)
        Teleport(teleport.uid):setDestination(cfg[nme].toPos)
        creature:say("The Portal will be closed in 60 seconds, please run.")
    	addEvent(removeTeleport,60000,cfg[nme].pos)
    end

    return true
end