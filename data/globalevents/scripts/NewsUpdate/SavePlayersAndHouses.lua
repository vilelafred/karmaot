local function serverSave()
    saveServer()
end

local function secondSaveWarning()
    addEvent(serverSave, 60000)
end

function onThink(interval)
    addEvent(secondSaveWarning, 60000)
    return true
end