require('quests/base_quest')
require('quests/base_quest_objective')
require('worlds/redfall_ridge/redfall_ridge_quests/redfall_quests_constants')

seeking_ashara = class(base_quest, nil, base_quest)

function seeking_ashara:GetQuestName()
    return "seeking_ashara"
end

function seeking_ashara:GetRewards()
    return 
    {
        {
            name = "tooltip_current_shards", 
            type = ROSHPIT_QUEST_REWARD_TYPE_MITHRIL,
            amount = RedfallQuests:GetMithrilReward(REDFALL_MITHRIL_ASHARA),
            autoReward = true,
            position = Vector(1257, -15003)
        }
    }
end

function seeking_ashara:OnRewardClaimed(playerId)
    local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
    CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", hero, 2)
end

function seeking_ashara:GetObjectives()
    return {
        seeking_ashara_objective1,
        seeking_ashara_objective2,
        seeking_ashara_objective3,
        seeking_ashara_objective4,
        seeking_ashara_objective5,
        seeking_ashara_objective6
    }
end

-------------------
--- OBJECTIVE 1 ---
-------------------
seeking_ashara_objective1 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective1:GetObjectiveTarget()
    return "seeking_ashara_objective1"
end

function seeking_ashara_objective1:GetObjectiveTargetCount()
    return 1
end

function seeking_ashara_objective1:OnObjectiveCompleted()
    return
end

function seeking_ashara_objective1:GetObjectivePingLocations()
    return {
        Vector(-11535, 5266)
    }
end

-------------------
--- OBJECTIVE 2 ---
-------------------
seeking_ashara_objective2 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective2:GetObjectiveTarget()
    return "redfall_priestess_of_ashara"
end

function seeking_ashara_objective2:GetObjectiveTargetCount()
    return 1
end

function seeking_ashara_objective2:OnObjectiveCompleted()
    for i = 1, #MAIN_HERO_TABLE, 1 do
        Timers:CreateTimer(0, function()
            if MAIN_HERO_TABLE[i]:IsAlive() then
                Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, MAIN_HERO_TABLE[i], "modifier_blessing_of_ashara", {})
            else
                return 1
            end
        end)
    end
end

function seeking_ashara_objective2:GetObjectivePingLocations()
    return {
        Vector(-10944, 14336)
    }
end

-------------------
--- OBJECTIVE 3 ---
-------------------
seeking_ashara_objective3 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective3:GetObjectiveTarget()
    return "seeking_ashara_objective3"
end

function seeking_ashara_objective3:GetObjectiveTargetCount()
    return 1
end

function seeking_ashara_objective3:OnObjectiveCompleted()
end

function seeking_ashara_objective3:GetObjectivePingLocations()
    return {
        Vector(-640, -9216)
    }
end

-------------------
--- OBJECTIVE 4 ---
-------------------
seeking_ashara_objective4 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective4:GetObjectiveTarget()
    return "seeking_ashara_objective4"
end

function seeking_ashara_objective4:GetObjectiveTargetCount()
    return 1
end

function seeking_ashara_objective4:OnObjectiveCompleted()
end

function seeking_ashara_objective4:GetObjectivePingLocations()
    return {
        Vector(1257, -15003)
    }
end

-------------------
--- OBJECTIVE 5 ---
-------------------
seeking_ashara_objective5 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective5:GetObjectiveTarget()
    return "seeking_ashara_objective5"
end

function seeking_ashara_objective5:GetObjectiveTargetCount()
    return 4
end

function seeking_ashara_objective5:OnObjectiveCompleted()
end

function seeking_ashara_objective5:GetObjectivePingLocations()
    return {
        Vector(240, -14423), --Northwest
		Vector(2075, -14340),  --Northeast
		Vector(1280, -16000) --South
    }
end

-------------------
--- OBJECTIVE 6 ---
-------------------
seeking_ashara_objective6 = class(base_quest_objective, nil, base_quest_objective)

function seeking_ashara_objective6:GetObjectiveTarget()
    return "redfall_ashara"
end

function seeking_ashara_objective6:GetObjectiveTargetCount()
    return 1
end

function seeking_ashara_objective6:OnObjectiveCompleted()
end

function seeking_ashara_objective6:GetObjectivePingLocations()
    return {
        Vector(1257, -15003)
    }
end
