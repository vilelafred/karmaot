-- ===================================================
-- MULTICLIENT LOGGER - Sistema de Detecção de IPs Compartilhados
-- ===================================================
-- Varre players online a cada 30 minutos
-- Agrupa por IP e detecta 2+ jogadores no mesmo IP
-- Salva relatório diário em: data/logs/multiclient/YYYY-MM-DD_multiclient.txt
-- Invisível para os players - apenas para análise do GM

local config = {
    -- Intervalo entre verificações (definido no XML)
    -- Pasta onde serão salvos os logs
    logPath = "data/logs/multiclient/",
    -- Mínimo de players no mesmo IP para registrar
    minPlayersPerIp = 2
}

-- Gera nome do arquivo com base na data atual
local function getLogFileName()
    local date = os.date("%Y-%m-%d")
    return config.logPath .. date .. "_multiclient.txt"
end

-- Cria a pasta de logs se não existir
local function ensureLogDirectoryExists()
    os.execute("mkdir " .. config.logPath:gsub("/", "\\") .. " 2>nul")  -- Windows
    os.execute("mkdir -p " .. config.logPath .. " 2>/dev/null")  -- Linux
end

-- Anexa texto ao arquivo de log
local function appendToFile(filename, text)
    local file = io.open(filename, "a")
    if file then
        file:write(text .. "\n")
        file:close()
        return true
    else
        print("[MultiClient Logger] ERROR: Could not open file: " .. filename)
        return false
    end
end

-- Função principal que detecta multiclient
local function detectMulticlient()
    -- Garantir que a pasta existe
    ensureLogDirectoryExists()
    
    -- Mapa de IPs: { ["192.168.0.1"] = { "Player1 (acc:123)", "Player2 (acc:456)" } }
    local ipMap = {}
    
    -- Varrer todos os players online
    local players = Game.getPlayers()
    for _, player in ipairs(players) do
        if player then
            local ip = player:getIp()
            local name = player:getName()
            local accountId = player:getAccountId()
            
            -- Se conseguiu pegar o IP
            if ip and ip > 0 then
                -- Converter IP numérico para formato legível
                local ipString = convertIntToIp(ip)
                
                -- Inicializar lista de players para este IP se não existir
                if not ipMap[ipString] then
                    ipMap[ipString] = {}
                end
                
                -- Adicionar player à lista deste IP
                table.insert(ipMap[ipString], string.format("%s (acc:%d)", name, accountId))
            end
        end
    end
    
    -- Verificar quais IPs têm 2 ou mais players
    local detectionCount = 0
    local timestamp = os.date("[%Y-%m-%d %H:%M:%S]")
    local logFile = getLogFileName()
    
    for ip, players in pairs(ipMap) do
        if #players >= config.minPlayersPerIp then
            detectionCount = detectionCount + 1
            
            -- Formatar linha do log
            local line = string.format("%s  IP: %s  ->  %s", 
                timestamp, 
                ip, 
                table.concat(players, ", ")
            )
            
            -- Salvar no arquivo
            appendToFile(logFile, line)
        end
    end
    
    -- Log no console do servidor
    if detectionCount > 0 then
        print(string.format("[MultiClient Logger] %d grupo(s) detectado(s) em %s", 
            detectionCount, 
            timestamp
        ))
    else
        print(string.format("[MultiClient Logger] Nenhum multiclient detectado em %s", 
            timestamp
        ))
    end
end

-- Converte IP numérico para formato xxx.xxx.xxx.xxx
function convertIntToIp(int)
    local b1 = bit.rshift(bit.band(int, 0xff000000), 24)
    local b2 = bit.rshift(bit.band(int, 0x00ff0000), 16)
    local b3 = bit.rshift(bit.band(int, 0x0000ff00), 8)
    local b4 = bit.band(int, 0x000000ff)
    return string.format("%d.%d.%d.%d", b1, b2, b3, b4)
end

-- GlobalEvent
local event = GlobalEvent("multiclient_logger")

function event.onThink(interval)
    detectMulticlient()
    return true
end

event:interval(1800000)  -- 30 minutos (1800000 ms)
event:register()

