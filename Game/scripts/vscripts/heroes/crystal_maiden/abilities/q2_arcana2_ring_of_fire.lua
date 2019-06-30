local function cast(caster, ability, runesCount)
    local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    local origin = caster:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
    ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
    ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    EmitSoundOn("Sorceress.RingOfFire.Cast", caster)
    local radius = 550
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local burn_duration = Q2_BASE_DURATION + runesCount * 0.1
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ring_of_fire_burn", {duration = burn_duration})
            enemy.ringOfFireBurn = 0
        end
    end
    if caster.waterElemental then
        local elementalOrigin = caster.waterElemental:GetAbsOrigin()
        local heroDistance = WallPhysics:GetDistance(elementalOrigin, origin)
        local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), elementalOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies2 > 0 then
            for _, enemy in pairs(enemies2) do
                -- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
                ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ring_of_fire_burn", {duration = burn_duration})
                enemy.ringOfFireBurn = 0
            end
        end
        local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(particle2, 0, elementalOrigin + Vector(0, 0, 20))
        ParticleManager:SetParticleControl(particle2, 1, Vector(550, 2, 1000))
        ParticleManager:SetParticleControl(particle2, 3, Vector(550, 550, 550))
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle2, false)
        end)
        if heroDistance > 1500 then
            EmitSoundOn("Sorceress.RingOfFire.Cast", caster.waterElemental)
        end
    end
end

local function tryToCast(caster, ability, bInstant)
    local runesCount = caster:GetRuneValue("q", 2)
    if runesCount == nil or runesCount <= 0 then
        return
    end
    if bInstant then
        if not caster:HasModifier("modifier_ring_of_fire_down") then
            cast(caster, ability, runesCount)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_ring_of_fire_down", {duration = 10})
        end
    else
        if caster:HasModifier("modifier_ring_of_fire_ready") then
            cast(caster, ability, runesCount)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_ring_of_fire_down", {duration = 10})
        elseif not caster:HasModifier("modifier_ring_of_fire_down") then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_ring_of_fire_ready", {duration = 0.6})
        end
    end

end

local module = {}
module.tryToCast = tryToCast
return module
