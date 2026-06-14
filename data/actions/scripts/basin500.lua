local config = {
    [4177] = { -- Lever 1 controls Stone 1
        stonePosition = Position(32355, 31662, 12)
    },
    [4178] = { -- Lever 2 controls Stone 2
        stonePosition = Position(32351, 31662, 12)
    }
}

local stoneId = 1484
local leverIds = { on = 1945, off = 1946 } -- Lever up/down
local RESPAWN_MS = 90 * 1000               -- 90 segundos

-- Simple anti-spam exhausted (in seconds)
local EXHAUST_STORAGE = 900800
local EXHAUST_SECONDS = 15

-- Função chamada pelo addEvent para recolocar o item
local function respawnStone(posTable)
    -- posTable é uma tabela {x=..., y=..., z=...} (seguro para addEvent)
    local pos = Position(posTable.x, posTable.y, posTable.z)
    local tile = Tile(pos)
    if not tile then
        return
    end
    -- Só cria se não existir ainda (evita duplicata)
    if not tile:getItemById(stoneId) then
        Game.createItem(stoneId, 1, pos)
    end

    -- (sem reset de alavanca automático)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Exhaustion: block rapid repeated clicks
    local now = os.time()
    local untilTime = player:getStorageValue(EXHAUST_STORAGE)
    if untilTime ~= -1 and untilTime > now then
        player:sendCancelMessage("You must wait " .. (untilTime - now) .. " seconds before using this lever again.")
        return true
    end
    local actionId = item.actionid
    local setting = config[actionId]
    if not setting then
        player:sendCancelMessage("This lever is not configured.")
        return true
    end

    local tile = Tile(setting.stonePosition)
    if not tile then
        player:sendCancelMessage("Could not locate the tile.")
        return true
    end

    local stone = tile:getItemById(stoneId)

    if stone then
        -- Remove e agenda a volta em 90s
        stone:remove()
        item:transform(leverIds.off)
        player:say("You removed the coal basin!", TALKTYPE_MONSTER_SAY)

        -- Passa uma TABELA simples com x,y,z para o addEvent (evita problemas com userdata)
        addEvent(respawnStone, RESPAWN_MS, { x = setting.stonePosition.x, y = setting.stonePosition.y, z = setting.stonePosition.z })
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    else
        -- Recoloca imediatamente
        Game.createItem(stoneId, 1, setting.stonePosition)
        item:transform(leverIds.on)
        player:say("You placed the coal basin back!", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(EXHAUST_STORAGE, now + EXHAUST_SECONDS)
    end

    return true
end
