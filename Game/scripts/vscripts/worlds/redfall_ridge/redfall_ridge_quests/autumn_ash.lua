require('quests/base_quest')
require('quests/base_quest_objective')

autumn_ash = class(base_quest, nil, base_quest)

function autumn_ash:GetQuestName()
    return "autumn_ash"
end

function autumn_ash:GetRewards()
    return 
    {
        {
            name = "item_rpc_autumn_sleeper_mask", 
            type = ROSHPIT_QUEST_REWARD_TYPE_IMMORTAL,
            autoReward = false
        }
    }
end

function autumn_ash:OnRewardClaimed(playerId)
end

function autumn_ash:GetObjectives()
    return {
        autumn_ash_objective1,
        autumn_ash_objective2
    }
end

-------------------
--- OBJECTIVE 1 ---
-------------------
autumn_ash_objective1 = class(base_quest_objective, nil, base_quest_objective)

function autumn_ash_objective1:GetObjectiveTarget()
    return "autumn_ash_objective1"
end

function autumn_ash_objective1:GetObjectiveTargetCount()
    return 1
end

function autumn_ash_objective1:OnObjectiveCompleted()
    return
end

function autumn_ash_objective1:GetObjectivePingLocations()
    return {
        Vector(-1856, -10240)
    }
end

-------------------
--- OBJECTIVE 2 ---
-------------------
autumn_ash_objective2 = class(base_quest_objective, nil, base_quest_objective)

function autumn_ash_objective2:GetObjectiveTarget()
    return "redfall_ashen_treant"
end

function autumn_ash_objective2:GetObjectiveTargetCount()
    return 1
end

function autumn_ash_objective2:OnObjectiveCompleted()
    return
end

function autumn_ash_objective2:GetObjectivePingLocations()
    return {
        Vector(-1856, -10240)
    }
end
