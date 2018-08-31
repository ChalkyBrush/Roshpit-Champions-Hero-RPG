local function cast(caster, target, ability, damage)
    EmitSoundOn("Sorceress.IceLance.Crit", target)
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    local origin = target:GetAbsOrigin()
    local runesCount = caster.q_3_level

    ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
    ParticleManager:SetParticleControl( particle1, 1, Vector(Q3_RADIUS, 2, 1000) )
    ParticleManager:SetParticleControl( particle1, 3, Vector(Q3_RADIUS, 550, 550) )
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    local freezeDuration = Q3_BASE_DURATION + runesCount * Q3_ADD_DURATION
    local damage = damage * SORCERESS_Q3_AMPLIFY_PERCENT/100 * runesCount
    local radius = Q3_RADIUS

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if Immune.shouldApplyImmune(caster, enemy, 'modifier_ice_lance', Q3_TIME_BEFORE_IMMUNE) then
                Immune.applyImmune(caster, enemy, ability, 'modifier_ice_lance', Q3_IMMUNE_DURATION)
            elseif not Immune.targetHasImmune(enemy, 'modifier_ice_lance') and not enemy:HasModifier('modifier_ice_lance_frozen') then
                Immune.addEffectDuration(caster, enemy, ability, 'modifier_ice_lance', freezeDuration)
                ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_lance_frozen", {duration = freezeDuration})
            end
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
        end
    end
end

local module = {}
module.cast = cast
return module