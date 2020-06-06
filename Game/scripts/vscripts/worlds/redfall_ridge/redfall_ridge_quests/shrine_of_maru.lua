require('quests/base_quest')
require('quests/base_quest_objective')

shrine_of_maru = class(base_quest, nil, base_quest)

function shrine_of_maru:GetQuestName()
    return "shrine_of_maru"
end

function shrine_of_maru:GetRewards()
    return 
    {
        {
            name = "modifier_blessing_of_the_forest", 
            type = ROSHPIT_QUEST_REWARD_TYPE_BUFF,
            amount = 3600,
            autoReward = true
        }
    }
end

function shrine_of_maru:OnRewardClaimed(playerId)
    local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
    local particleName = "particles/roshpit/redfall/red_beam.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, Vector(-6916, -8042, 200 + Redfall.ZFLOAT))
    ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin() + Vector(0, 0, 122 + Redfall.ZFLOAT))
    Timers:CreateTimer(
        1.5,
        function()
            ParticleManager:DestroyParticle(pfx, false)
        end
    )
    EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Redfall.Maru.Spawn", Redfall.RedfallMaster)
    CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", hero, 2)
end

function shrine_of_maru:GetObjectives()
    return {
        shrine_of_maru_objective
    }
end

-------------------
--- OBJECTIVE 1 ---
-------------------
shrine_of_maru_objective = class(base_quest_objective, nil, base_quest_objective)

function shrine_of_maru_objective:GetObjectiveTarget()
    return "redfall_disciple_of_maru"
end

function shrine_of_maru_objective:GetObjectiveTargetCount()
    return 12
end

function shrine_of_maru_objective:OnObjectiveCompleted()
    return
end

function shrine_of_maru_objective:GetObjectivePingLocations()
    return {
        Vector(-6976, -8448)
    }
end
