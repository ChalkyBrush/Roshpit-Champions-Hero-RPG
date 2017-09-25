local function cast(caster, ability, runesCount)
    local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    local origin = caster:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
    ParticleManager:SetParticleControl( particle1, 1, Vector(550, 2, 1000) )
    ParticleManager:SetParticleControl( particle1, 3, Vector(550, 550, 550) )
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    EmitSoundOn("Sorceress.FrostNova", caster)
    local radius = 550
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local freezeDuration = Q2_BASE_DURATION + runesCount * Q2_ADD_DURATION
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frost_nova", {duration = freezeDuration})
        end
    end
    if caster.waterElemental then
        local elementalOrigin = caster.waterElemental:GetAbsOrigin()
        local heroDistance = WallPhysics:GetDistance(elementalOrigin, origin)
        local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), elementalOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
        if #enemies2 > 0 then
            for _,enemy in pairs(enemies2) do
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE) ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frost_nova", {duration = freezeDuration})
            end
        end
        local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle2, 0, elementalOrigin+Vector(0,0,20) )
        ParticleManager:SetParticleControl( particle2, 1, Vector(550, 2, 1000) )
        ParticleManager:SetParticleControl( particle2, 3, Vector(550, 550, 550) )
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle2, false)
        end)
        if heroDistance > 1500 then
            EmitSoundOn("Sorceress.FrostNova", caster.waterElemental)
        end
    end
end

local function tryToCast(caster, ability)
    local runesCount = caster.b_a_level
    if runesCount == nil or runesCount <= 0 then
        return
    end
    if caster:HasModifier("modifier_frost_nova_ready") then
        cast(caster, ability, runesCount)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_frost_nova_down", {duration = 10})
    elseif not caster:HasModifier("modifier_frost_nova_down") then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_frost_nova_ready", {duration = 0.6})
    end
end

local module = {}
module.tryToCast = tryToCast
return module