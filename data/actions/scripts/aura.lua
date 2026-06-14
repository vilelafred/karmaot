local EXHAUSTED_SECONDS = 120

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o item clicado é o que deve conceder a recuperação
    if item:getId() == 8243 then
        -- Obtém o tempo restante no "exhaust"
        local exhaustedTime = player:getStorageValue(item:getId()) - os.time()

        -- Verifica se o jogador está em "exhausted" e exibe a mensagem de tempo restante
        if exhaustedTime > 0 then
            player:sendCancelMessage("You are exhausted. Time remaining: " .. exhaustedTime .. " segundos.")
            return true
        end

        -- Define a quantidade de saúde e mana a ser recuperada (100%)
        local healthToRecover = player:getMaxHealth()
        local manaToRecover = player:getMaxMana()

        -- Recupera a saúde e mana do jogador
        player:addHealth(healthToRecover)
        player:addMana(manaToRecover)

        -- Adiciona um efeito de magia (brilho azul) ao jogador
        player:getPosition():sendMagicEffect(186)

        -- Mensagem para o jogador informando sobre a recuperação
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Full HP and MANA!")

        -- Define o tempo de "exhaust" para o item
        player:setStorageValue(item:getId(), os.time() + EXHAUSTED_SECONDS)

        -- Remove o item do inventário do jogador após o uso (opcional)
        item:remove(1)
    end

    return true
end
