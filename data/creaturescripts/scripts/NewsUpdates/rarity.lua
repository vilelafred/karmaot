function onKill(creature, target)
    local targetMonster = target:getMonster()
    if not targetMonster then
        print("Target is not a monster.")
        return true
    end
    
    local monsterLevel = targetMonster:getMonsterLevel()

    -- Sempre cai a gema se o monstro for de nível 5 ou superior
    if monsterLevel >= 5 then
        local gemItem = targetMonster:addItem(5838, 1)  -- Adiciona a Rare GEM ao loot do monstro
        if gemItem then
            gemItem:decay()  -- Indica que o item pode desaparecer após um tempo (opcional)
        end
        targetMonster:generateLoot()
        print("Gem added to monster loot.")
        return true
    end
    
    local GemRare = math.random(1, 100)  -- Agora de 1 a 100 para a porcentagem

    local chance = 0  -- Inicializa a chance com 0
    
    -- Determina a chance com base no nível do monstro
    if monsterLevel >= 21 and monsterLevel <= 40 then
        chance = 10
    elseif monsterLevel >= 41 and monsterLevel <= 60 then
        chance = 15
    elseif monsterLevel >= 70 then
        chance = 20
    end
    
    -- Verifica se a chance é atendida
    if GemRare <= chance then
        local gemItem = targetMonster:addItem(5838, 1)  -- Adiciona a Rare GEM ao loot do monstro
        if gemItem then
            gemItem:decay()  -- Indica que o item pode desaparecer após um tempo (opcional)
        end
        targetMonster:generateLoot()
        print("Gem added to monster loot.")
    else
        print("No gem added to monster loot.")
    end
    
    return true
end
