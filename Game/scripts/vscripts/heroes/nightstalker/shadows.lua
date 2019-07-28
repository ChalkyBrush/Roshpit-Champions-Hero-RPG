-- Not ability, just class for easier access
chernobog_shadows = class({})

local class = chernobog_shadows
local instance = nil
function class:GetInstance()
    if instance == nil then
        instance = class()
    end
    return instance
end
function class:Init(radius, attackDamage)
end
function class:ApplyParticle(target, animationRate)
    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", target, CHERNOBOG_SHADOWS_ATT_INTERVAL_BASE * intervalsForAtt)
    ParticleManager:SetParticleControl(pfx, 1, Vector(particle_animation_rate, 0, 0))

    Timers:CreateTimer(1/animationRate, function()

        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function class:GetAttackSpeed()
end
