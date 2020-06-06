require('quests/base_quest')
require('quests/base_quest_objective')

cleansing_the_coast = class(base_quest, nil, base_quest)

function cleansing_the_coast:GetQuestName()
    return "cleansing_the_coast"
end

function cleansing_the_coast:GetRewards()
    return 
    {
        {
            name = "modifier_preservers_mantra", 
            type = ROSHPIT_QUEST_REWARD_TYPE_BUFF,
            amount = 3600,
            autoReward = true
        }
    }
end

function cleansing_the_coast:OnRewardClaimed(playerId)
    local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
    CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", hero, 2)
end

function cleansing_the_coast:GetObjectives()
    return {
        cleansing_the_coast_objective
    }
end

-------------------
--- OBJECTIVE 1 ---
-------------------
cleansing_the_coast_objective = class(base_quest_objective, nil, base_quest_objective)

function cleansing_the_coast_objective:GetObjectiveTarget()
    return "cleansing_the_coast_objective"
end

function cleansing_the_coast_objective:GetObjectiveTargetCount()
    return 4
end

function cleansing_the_coast_objective:OnObjectiveCompleted()
    return
end

function cleansing_the_coast_objective:GetObjectivePingLocations()
    return {
        Vector(-5981, -14547)
    }
end
