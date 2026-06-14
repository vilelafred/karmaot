-- Arquivo: data/scripts/monster_respawn.lua

-- Função para lidar com a morte de qualquer monstro
function onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
    -- Verifique se o monstro morto é um jogador (para evitar respawn ao matar outros jogadores)
    if isPlayer(creature) then
        return
    end

    -- Níveis e probabilidades de respawn
    local respawnTable = {
        {minLevel = 5, maxLevel = 20, probability = 80, delay = 3000},  -- delay em milissegundos (3 segundos)
        {minLevel = 21, maxLevel = 50, probability = 40, delay = 3000},
        {minLevel = 51, maxLevel = 70, probability = 20, delay = 3000},
        {minLevel = 71, maxLevel = 100, probability = 10, delay = 3000}
        -- Adicione mais linhas conforme necessário para outros intervalos de nível
    }

    -- Nível do monstro morto
    local nivelMonstro = getCreatureLevel(creature)

    -- Encontre o intervalo de respawn correspondente
    local intervaloRespawn
    for _, intervalo in ipairs(respawnTable) do
        if nivelMonstro >= intervalo.minLevel and nivelMonstro <= intervalo.maxLevel then
            intervaloRespawn = intervalo
            break
        end
    end

    -- Se nenhum intervalo de respawn correspondente for encontrado, não faça nada
    if not intervaloRespawn then
        return
    end

    -- Gere um número aleatório de 0 a 100
    local chanceDeRespawn = math.random(0, 100)

    -- Se a chance for menor ou igual à probabilidade configurada, inicie o respawn após o delay
    if chanceDeRespawn <= intervaloRespawn.probability then
        addEvent(respawnMonster, intervaloRespawn.delay, creature)
    end
end

-- Função para respawn do monstro
function respawnMonster(creature)
    -- Posição do monstro original
    local posicao = getCreaturePosition(creature)

    -- Nome do monstro original
    local nomeMonstro = getCreatureName(creature)

    -- Crie o novo monstro
    local novoMonstro = doSummonCreature(nomeMonstro, posicao)
end
