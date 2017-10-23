require('heroes/axe/init')
local Shockwaves = require('heroes/axe/abilities/r/r2_shockwaves')
local function createTauntWaves(caster, ability, damage)
    for i = 0, R1_BUFF_DURATION, 1 do
        Timers:CreateTimer(0.2 + i, function()
            EmitSoundOn("RPCItem.RedrockFootwear", caster)
            local position = caster:GetAbsOrigin()
            local particleName = "particles/units/heroes/hero_faceless_void/redrock_timedialate.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            local radius = 600
            ParticleManager:SetParticleControl(particle, 0, position)
            ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
            Timers:CreateTimer(4, function()
                ParticleManager:DestroyParticle(particle, false)
            end)

            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
            if #enemies > 0 then
                for _,enemy in pairs(enemies) do
                    if not enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                        ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_axe_rune_a_d_taunt", {duration = 1.5})
                        enemy:MoveToTargetToAttack(caster)
                    end
                    Shockwaves.dealDamage(caster, enemy, ability, damage)
                end
            end
        end)
    end
end
local function cast(caster, ability, damage)
    if caster.a_d_level <= 0 then
        return
    end
    createTauntWaves(caster, ability, damage)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_b_d_visible", {duration = R1_BUFF_DURATION})
end

function takeDamage(event)
    local caster = event.caster
    local ability = event.ability
    local attacker = event.attacker

    local start_radius = 140
    local end_radius = 140
    local range = 1500
    local speed = 1500
    if IsValidEntity(attacker) then
        local newStacks = caster:GetModifierStackCount("modifier_tomahawk_tectonic_pressure", caster) - 1
        local fv = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
        local info =
        {
            Ability = ability,
            EffectName = "particles/roshpit/warlord/fire_ulti_linear.vpcf",
            vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,60),
            fDistance = range,
            fStartRadius = start_radius,
            fEndRadius = end_radius,
            Source = caster,
            StartPosition = "attach_hitloc",
            bHasFrontalCone = true,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 5.0,
            bDeleteOnHit = true,
            vVelocity = fv*Vector(1,1,0) * speed,
            bProvidesVision = false,
        }
        local projectile = ProjectileManager:CreateLinearProjectile(info)

        local endPos = caster:GetAbsOrigin()+fv*1500
        Timers:CreateTimer(1, function()
            local position = endPos
            local radius = 260
            EmitSoundOnLocationWithCaster(endPos, "Warlord.Ult.FireImpact", caster)

            local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
            local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
            ParticleManager:SetParticleControl( particle2, 0, position )
            ParticleManager:SetParticleControl( particle2, 0, Vector(radius,radius,radius) )
            Timers:CreateTimer(1.5,
                function()
                    ParticleManager:DestroyParticle( particle2, false )
                end)
            local damage = math.min(event.damage, 20 * caster:GetHealth());
            print("incoming damage = " .. event.damage)
            damage = damage * caster.a_d_level*R1_DAMAGE
            if caster:HasModifier("modifier_axe_glyph_5_a") then
                damage = damage * (1 + T5A_AMPLIFY_PERCENT/100)
            end

            print("damage from r1 = " .. damage)
            Filters:TakeArgumentsAndApplyDamage(attacker, caster, damage, DAMAGE_TYPE_PHYSICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

        end)
    end
end


local module = {}
module.cast = cast
return module