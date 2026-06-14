function onStartup()
    local config = {
        ["Monday"] = Position(32639, 31666, 8), -- Ab'Dendriel
        ["Tuesday"] = Position(32362, 32207, 7), -- Thais
        ["Wednesday"] = Position(32579, 32754, 7), -- Port Hope
        ["Thursday"] = Position(33066, 32880, 6), -- Ankrahmun
        ["Friday"] = Position(33239, 32483, 7), -- Darashia
        ["Saturday"] = Position(33171, 31810, 6), -- Edron
        ["Sunday"] = Position(32326, 31783, 6) -- Carlin
    }

    local today = os.date("%A")
    local position = config[today]

    if position then
        local customNpc = Game.createNpc("Rashid", position)
        if customNpc then
            customNpc:setMasterPos(position)
        else
            print("[RashidTeleport] Erro: não foi possível criar o NPC Rashid.")
        end
    else
        print("[RashidTeleport] Erro: dia da semana inválido ou posição não encontrada.")
    end

    return true
end
