require('heroes/axe/init')
local EarthShatter = require('heroes/axe/abilities/arcana1_r/r1_earth_shatter')
local BlisteringRage = require('heroes/axe/abilities/arcana1_r/r2_blistering_rage')
local BurningFury = require('heroes/axe/abilities/arcana1_r/r3_burning_fury')
local SeismicAftershock = require('heroes/axe/abilities/arcana1_r/r4_seismic_aftershock')
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')
local ImmortalWeapon3 = require('heroes/axe/weapons/immortal_weapon_3')

function startChannel(event)
    local caster = event.caster
    local ability = event.ability
    ability.isInterrupted = false
    Helper.initializeAbilityRunes(caster, 'axe', 'd')
    ImmortalWeapon3.amplifyShieldsCount(caster)


    local stun_duration = event.stun_duration
    local amp = event.amp
    local forks = event.forks


    local point = event.target_points[1]
    local direction = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    ability.attack_power_mult_percent = event.attack_power_mult_percent


    Timers:CreateTimer(0.1, function()
        local startPoint = caster:GetAbsOrigin()+direction*200
        local max = 0
        local min = 0

        local divisor = 9
        local tremorsCount = SeismicAftershock.getTremorsCount(caster)
        local additionalRadius = SeismicAftershock.getAdditionalRadius(caster)
        if forks == 1 then
            tremorsCount = math.ceil(tremorsCount/2)
            additionalRadius = math.ceil(additionalRadius/2)
        end
        local damageRadius = ARCANA1_R_RADIUS + additionalRadius
        min = -math.ceil((tremorsCount - 1) / 2)
        max = tremorsCount + min - 1

        ability.pfx = {}

        local damage = 0

        StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_prevent_turning_invisible", {duration = 0.15})
        Timers:CreateTimer(0.15, function()
            local direction = caster:GetForwardVector()
            local startPoint = caster:GetAbsOrigin()+direction*200
            local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_fire_base.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(pfx2, 0, startPoint)
            Timers:CreateTimer(1.5, function()
                ParticleManager:DestroyParticle(pfx2, false)
                ParticleManager:ReleaseParticleIndex(pfx2)
            end)
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), startPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
            if #enemies > 0 then
                for _,enemy in pairs(enemies) do
                    BurningFury.applyDebuff(caster, enemy, ability)
                    BlisteringRage.applyBuff(caster, ability)
                    damage = caster:GetAverageTrueAttackDamage(caster)*event.attack_power_mult_percent/100
                    damage = damage*amp

                    if caster:HasModifier("modifier_axe_glyph_5_a") then
                        damage = damage * (1 + T5A_AMPLIFY_PERCENT/100)
                    end
                    Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
                    Filters:ApplyStun(caster, stun_duration, enemy)
                end
            end
            EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Start", caster)

            local procs = 1
            if caster:HasModifier("modifier_axe_glyph_6_1") then
                procs = T61_DUNKS_COUNT
            end
            -- if forks == 1 then
            --     Timers:CreateTimer(1.8 , function()
            --         EarthShatter.applyBuff(caster)
            --     end)
            -- end

            for procNumber = 0, procs - 1, 1 do
                for i = min, max, 1 do
                    local forkDirection = WallPhysics:rotateVector(direction, math.pi*i/divisor)
                    local endPoint = startPoint+forkDirection*damageRadius
                    local visualEndPoint = startPoint+1.69*forkDirection*damageRadius
                    Timers:CreateTimer(procNumber*0.5 + 0.15, function()
                        if ability.isInterrupted then
                            return
                        end

                        if procNumber == 0 then
                            StartSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
                        end
                        local particleName = "particles/roshpit/axe/arcana_sunder.vpcf"
                        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControl(pfx, 0, startPoint-direction*50+forkDirection*50)
                        ParticleManager:SetParticleControl(pfx, 1, visualEndPoint)
                        ParticleManager:SetParticleControl(pfx, 3, Vector(100,2,100)) -- y COMPONENT = duration
                        -- ParticleManager:SetParticleControl(pfx, 1, point)

                        if forks ~= 1 then
                            table.insert(ability.pfx,
                                {
                                    particle = pfx,
                                    startPoint = startPoint,
                                    endPoint = endPoint,
                                    procNumber = procNumber
                                }
                            )
                        else
                            Timers:CreateTimer(1.9, function()
                                dealDamage(caster, ability, damage, stun_duration, startPoint, endPoint)
                            end)
                        end
                    end)
                end
            end

            -- if forks == 1 then
            --     Timers:CreateTimer(procs*0.5 + 2.2 , function()
            --         EarthShatter.removeBuff(caster)
            --     end)
            -- end
        end)
    end)
end

function successfullCast(event)
    local caster = event.caster
    local ability = event.ability
    local damage = ability.damage
    local stun_duration = event.stun_duration

    -- EarthShatter.applyBuff(caster)
    Filters:CastSkillArguments(4, caster)
    WAmplify.applyBuff(caster)

    local lastProcNumber = 0
    local pfx = ability.pfx
    while #pfx > 0 do
        local currentParticle = pfx[1]
        lastProcNumber = currentParticle.procNumber
        Timers:CreateTimer(currentParticle.procNumber*0.5 + 0.15, function()
            dealDamage(caster, ability, 0, stun_duration, currentParticle.startPoint, currentParticle.endPoint)
            ParticleManager:DestroyParticle(currentParticle.particle, false)
            ParticleManager:ReleaseParticleIndex(currentParticle.particle)
        end)
        table.remove(pfx, 1)
    end

    Timers:CreateTimer(lastProcNumber*0.5 + 0.4, function()
        StartSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
        -- EarthShatter.removeBuff(caster)
    end)
end

function interruptCast(event)
    local caster = event.caster
    Timers:CreateTimer(0.2, function()
        StopSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
        local ability = event.ability
        ability.isInterrupted = true
        local pfx = ability.pfx

        while #pfx > 0 do
            ParticleManager:DestroyParticle(pfx[1].particle, true)
            ParticleManager:ReleaseParticleIndex(pfx[1].particle)
            table.remove(pfx, 1)
        end
    end)
end

function dealDamage(caster, ability, damage, stun_duration, startPoint, endPoint)
    ability.particle = nil
    for i = 1, 3, 1 do
        EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Explode"..i, caster)
    end

    local enemies = FindUnitsInLine(caster:GetTeamNumber(), startPoint, endPoint, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
    for _,enemy in pairs(enemies) do
        BlisteringRage.applyBuff(caster, ability)
        BurningFury.applyDebuff(caster, enemy, ability)
        damage = caster:GetAverageTrueAttackDamage(caster)*ability.attack_power_mult_percent/100
        damage = damage*ability.amp

        if caster:HasModifier("modifier_axe_glyph_5_a") then
             damage = damage * (1 + T5A_AMPLIFY_PERCENT/100)
        end
        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        Filters:ApplyStun(caster, stun_duration, enemy)
        --ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
    end
end


local module = {}
module.castWithoutCastTime = startChannel
return module