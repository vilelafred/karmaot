SkillsTable = {
  [0] = { --[[ SKILL_FIST ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [1] = { --[[ SKILL_CLUB ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [2] = { --[[ SKILL_SWORD ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [3] = { --[[ SKILL_AXE ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [4] = { --[[ SKILL_DISTANCE ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 60}] = 3,
      [{61, 70}] = 2,
      [{71, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [5] = { --[[ SKILL_SHIELD ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [6] = { --[[ SKILL_FISHING ]]
    stage = {
      [{0, 30}] = 5,
      [{31, 50}] = 4,
      [{51, 70}] = 3,
      [{71, 80}] = 2,
      [{81, 300}] = 1
    },
    rate = configKeys.RATE_SKILL
  },
  [7] = { --[[ SKILL_MAGLEVEL ]]
    stage = {
      [{0, 10}] = 5,
      [{11, 20}] = 4,
      [{21, 30}] = 3,
      [{31, 60}] = 2,
      [{61, 300}] = 1
    },
    rate = configKeys.RATE_MAGIC
  }
}

function getSkillsRate(level, stages)
    if stages then
        for sLevel, multiplier in pairs(stages) do
            local minLevel, maxLevel = unpack(sLevel)
            if minLevel and maxLevel then
                if level and minLevel and maxLevel and level >= minLevel and level <= maxLevel then
                    return multiplier
                else
                  --print("Debug: Invalid level or range", level, minLevel, maxLevel)
                end
            else
                --print("Debug: minLevel or maxLevel is nil", minLevel, maxLevel)
            end
        end
    end
    return 1  -- Se não houver estágio definido, retorna 1
end




local talkaction = TalkAction("!serverinfo")

function talkaction.onSay(player, words, param)
    local function getSkillRate(skill)
        local skillRange = SkillsTable[skill]

        if skillRange and skillRange.stage then
            return getSkillsRate(player:getEffectiveSkillLevel(skill), skillRange.stage)
        end

        return configManager.getNumber(skillRange and skillRange.rate or configKeys.RATE_SKILL)
    end

    local playerLevel = player:getLevel()
    local expRate = Game.getExperienceStage(playerLevel)

    local fistRate = getSkillRate(0)
    local clubRate = getSkillRate(1)
    local swordRate = getSkillRate(2)
    local axeRate = getSkillRate(3)
    local distanceRate = getSkillRate(4)
    local shieldingRate = getSkillRate(5)
    local fishingRate = getSkillRate(6)
    local magicRate = getSkillsRate(player:getMagicLevel(), SkillsTable[7].stage, true)
    local lootRate = configManager.getNumber(configKeys.RATE_LOOT)

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Server Info:"
        .. "\nExp rate: " .. expRate
        .. "\nFist fighting rate: " .. fistRate
        .. "\nClub fighting rate: " .. clubRate
        .. "\nSword fighting rate: " .. swordRate
        .. "\nAxe fighting rate: " .. axeRate
        .. "\nDistance fighting rate: " .. distanceRate
       .. "\nShielding rate: " .. shieldingRate
        .. "\nFishing rate: " .. fishingRate
        .. "\nMagic rate: " .. magicRate
        .. "\nLoot rate: " .. lootRate)

    return false
end

talkaction:register()