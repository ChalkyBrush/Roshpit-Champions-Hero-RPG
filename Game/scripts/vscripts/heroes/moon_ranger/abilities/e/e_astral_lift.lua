require('heroes/moon_ranger/init')
require('heroes/moon_ranger/astral_arcana_ability')
function cast(event)
    local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    local target = event.target_points[1]
    target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)

    local delay = E_DELAY
    if caster:HasModifier("modifier_astral_glyph_4_1") then
        delay = T41_DELAY
    end

    local particleName = E_PARTICLE1
    local particleLocation = target
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( particle1, 0, particleLocation )
    Timers:CreateTimer(delay, -- Start this timer 10 game-time seconds later
        function()
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_star_blink_moving", {duration = 0.3})
            ParticleManager:DestroyParticle( particle1, false )
            particleName = E_PARTICLE2

            local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
            ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
            local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
            ParticleManager:SetParticleControl( particle3, 0, target )
            caster:SetAbsOrigin(target)
            FindClearSpaceForUnit(caster, target, true)
            ProjectileManager:ProjectileDodge(caster)
            Timers:CreateTimer(2, -- Start this timer 10 game-time seconds later
                function()
                    ParticleManager:DestroyParticle( particle2, false )
                    ParticleManager:DestroyParticle( particle3, false )
                end)
            if caster:HasModifier("modifier_astral_arcana_on_platform") then
                arcana_star_blink_move(caster, ability)
            end
        end)
    local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "astral")
    if b_c_level > 0 then
        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
        if #enemies > 0 then
            for _,enemy in pairs(enemies) do
                CustomAbilities:QuickAttachParticle("particles/roshpit/astral_ranger/e2_flash.vpcf", enemy, 1)
                caster:PerformAttack(enemy, true, true, true, false, true, false, false)
            end
        end

    end
    Filters:CastSkillArguments(3, caster)
end

function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    local stun_duration = event.stun_duration
    Filters:ApplyStun(caster, stun_duration, target)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end