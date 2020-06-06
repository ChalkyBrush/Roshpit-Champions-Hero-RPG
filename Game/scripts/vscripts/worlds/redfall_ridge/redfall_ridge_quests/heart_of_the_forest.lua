require('quests/base_quest')
require('quests/base_quest_objective')

heart_of_the_forest = class(base_quest, nil, base_quest)

function heart_of_the_forest:GetQuestName()
    return "heart_of_the_forest"
end

function heart_of_the_forest:GetRewards()
    return 
    {
        {
            name = "item_redfall_purified_vermillion_bundle_normal", 
            type = ROSHPIT_QUEST_REWARD_TYPE_KEY,
            amount = 1,
            autoReward = false
        }
    }
end

function heart_of_the_forest:GetObjectives()
    return {
        heart_of_the_forest_objective1,
        heart_of_the_forest_objective2
    }
end

-------------------
--- OBJECTIVE 1 ---
-------------------
heart_of_the_forest_objective1 = class(base_quest_objective, nil, base_quest_objective)

function heart_of_the_forest_objective1:GetObjectiveTarget()
    return "heart_of_the_forest_objective1"
end

function heart_of_the_forest_objective1:GetObjectiveTargetCount()
    return 4
end

function heart_of_the_forest_objective1:OnObjectiveCompleted()
    Timers:CreateTimer(1.5, function()
        Redfall:SpawnCrimsythCultistForCultMaster(Vector(-13661, -8000), Vector(0, -1))
        Redfall:SpawnCrimsythCultistForCultMaster(Vector(-13449, -8057), Vector(0, -1))
        Redfall:SpawnCrimsythCultistForCultMaster(Vector(-13873, -8057), Vector(0, -1))
        Redfall:SpawnCrimsythCultistForCultMaster(Vector(-13293, -8212), Vector(0, -1))
        Redfall:SpawnCrimsythCultistForCultMaster(Vector(-14029, -8212), Vector(0, -1))
        Redfall:SpawnCrimsythCultMaster(Vector(-13661, -8425, 1152), Vector(0, -1))
    end)
end

function heart_of_the_forest_objective1:GetObjectivePingLocations()
    return {
        Vector(-13285, -10545),
        Vector(-9216, -7616),
        Vector(-6279, -10397),
        Vector(-4466, -12800),
        Vector(-1479, -7313),
        Vector(-9931, -6006),
        Vector(-7840, -608)
    }
end

-------------------
--- OBJECTIVE 2 ---
-------------------
heart_of_the_forest_objective2 = class(base_quest_objective, nil, base_quest_objective)

function heart_of_the_forest_objective2:GetObjectiveTarget()
    return "redfall_crimsyth_cultist_master"
end

function heart_of_the_forest_objective2:GetObjectiveTargetCount()
    return 1
end

function heart_of_the_forest_objective2:OnObjectiveCompleted()
    return
end

function heart_of_the_forest_objective2:GetObjectivePingLocations()
    return {
        Vector(-13661, -8425)
    }
end