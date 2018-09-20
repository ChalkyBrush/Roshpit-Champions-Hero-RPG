local constants = require('heroes/hero_necrolyte/constants')

function begin_channel(event)
    local caster = event.caster
    if caster:HasModifier("modifier_iron_treads_of_destruction") then
        StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.5})
    else
        StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.38})
    end
    EmitSoundOn("Venomort.Viper.PrecastVO", caster)
    StartSoundEvent("Venomort.ViperChannel", caster)
    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/venomort/viper_channel_flare.vpcf", caster:GetAbsOrigin()+Vector(0,0,100), 1)
    ParticleManager:SetParticleControl(pfx, 1, Vector(75,75,75))
    ParticleManager:SetParticleControl(pfx, 2, Vector(24,24,24))
end

function viper_channel_thinking(event)
    local caster = event.caster
    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/venomort/viper_channel_flare.vpcf", caster:GetAbsOrigin()+Vector(0,0,100), 1)
    ParticleManager:SetParticleControl(pfx, 1, Vector(75,75,75))
    ParticleManager:SetParticleControl(pfx, 2, Vector(24,24,24))
end

function channel_interrupt(event)
    local caster = event.caster
    EndAnimation(caster)
    StopSoundEvent("Venomort.ViperChannel", caster)
end

function cast(event)
    local caster = event.caster
    local ability = event.ability
    local health = event.health
    local damage = event.damage
    Filters:CastSkillArguments(4, caster)

    local r4_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)

    if r4_level > 0 then
        health = health + r4_level * constants.R4_ADD_HP
        damage = damage + r4_level * constants.R4_ADD_DAMAGE
    end

    local r2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
    local multiplier = 1;
    if r2_level > 0 then
        multiplier = multiplier + r2_level * constants.R2_VIPER_SCALE_PERCENT/100
    end

    local armor = caster:GetPhysicalArmorValue()
    local lifetime = constants.R_DURATION
    local attackspeed = 100

    if caster:HasModifier('modifier_venomort_glyph_7_1') then
        attackspeed = attackspeed + constants.T71_ADDITIONAL_ATTACK_SPEED
        lifetime = lifetime + constants.T71_ADDITIONAL_LIFETIME
    end
    EmitSoundOn("Venomort.Viper.CastVO", caster)
    local viper = CreateUnitByName("venomort_viper_summon", caster:GetAbsOrigin() + caster:GetForwardVector()*120, true, caster, caster, caster:GetTeamNumber())
    viper.creator = caster
    viper.dieTime = lifetime
    viper.owner = caster
    viper.summonAbility = ability
    viper:SetOwner(caster)
    viper:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
    viper.creator = caster
    viper.owner = caster:GetPlayerOwnerID()
    local viperAbility = viper:FindAbilityByName("venomort_viper_ability")
    viperAbility:SetLevel(1)
    viperAbility:ApplyDataDrivenModifier(viper, viper, 'modifier_venomort_summon_attack_speed', nil)
    ability:ApplyDataDrivenModifier(caster, viper, "modifier_venomort_viper", {duration = lifetime})
    viper:FindAbilityByName("hero_summon_ai"):SetLevel(1)
    viper:SetControllableByPlayer(caster:GetPlayerID(), true)
    StartAnimation(viper, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nevermore/venom_raze.vpcf", viper, 3)
    local aiAbility = viper:FindAbilityByName("hero_summon_ai")
    if caster.bIsAIon == true or caster.bIsAIon == nil then
        aiAbility:ToggleAbility()
    end
    EmitSoundOn("Venomort.Viper.Spawn", viper)
    EmitSoundOn("Venomort.Viper.SpawnVO", viper)
    if caster:HasModifier("modifier_venomort_glyph_6_2") then
        viper:AddAbility("fire_temple_steadfast"):SetLevel(1)
    end

    Events:smoothSizeChange(viper, 0, 0.65, 20)
    viper:SetModifierStackCount( "modifier_venomort_summon_attack_speed", viperAbility, attackspeed * multiplier - 100)
    viper:SetMaxHealth(health * multiplier)
    viper:SetBaseMaxHealth(health * multiplier)
    viper:SetHealth(health * multiplier)
    viper:Heal(health * multiplier, viper)
    viper:SetBaseDamageMin(damage * multiplier)
    viper:SetBaseDamageMax(damage * multiplier)
    viper:SetPhysicalArmorBaseValue(armor * multiplier)
end
function attack_land(event)
    local caster
    if (event.attacker ~= nil) then
        caster = event.attacker
    else
        caster = event.caster
    end
    if not IsValidEntity(event.attacker) then
        return false
    end
    local target = event.target
    local ability = event.ability
    local creator = caster.creator

    local r1_level = Runes:GetTotalRuneLevelGeneric(creator, 1, 3)
    if r1_level > 0 then
        local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * r1_level * constants.R1_VIPER_DAMAGE_PERCENT/100
        local summonAbility = caster.summonAbility
        if creator:HasModifier('modifier_venomort_immortal_weapon_1') then
            if not summonAbility.particleCount then
                summonAbility.particleCount = 0
            end
            if summonAbility.particleCount < 10 then
                summonAbility.particleCount = summonAbility.particleCount + 1
                local pfx2 = ParticleManager:CreateParticle("particles/roshpit/venomort/basic_viper_r1_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
                ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 255, 60))
                Timers:CreateTimer(3.5, function()
                    ParticleManager:DestroyParticle(pfx2, false)
                end)
                Timers:CreateTimer(2, function()
                    summonAbility.particleCount = summonAbility.particleCount - 1
                end)
            end
            local enemies = FindUnitsInRadius( creator:GetTeamNumber(), target:GetAbsOrigin(), nil, constants.WEAPON1_AOE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
            if #enemies > 0 then
                for _,enemy in pairs(enemies) do
                    Filters:ApplyDotDamage(creator, ability, enemy, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
                end
            end
        else
            Filters:TakeArgumentsAndApplyDamage(target, creator, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
        end

    end

    local r3_level = Runes:GetTotalRuneLevelGeneric(creator, 3, 3)
    if r3_level > 0 then
        local max_stacks = r3_level * constants.R3_STACKS
        local duration = constants.R3_DURATION
        ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_summon_damage_reduction", {duration = duration})
        local modifier = target:FindModifierByName("modifier_venomort_summon_damage_reduction")
        modifier:SetStackCount(min(modifier:GetStackCount() + 1, max_stacks))
    end
end

function viper_expire(event)
    local ability = event.ability
    local caster = event.caster
    local target = event.target
    if target:IsAlive() then
        target:RemoveModifierByName("modifier_die_after_time")
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nevermore/venom_raze.vpcf", target, 3)
        Events:smoothSizeChange(target, 0.65, 0, 20)
        EmitSoundOn("Venomort.Viper.Despawn", target)
        if IsValidEntity(ability) then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_viper_leaving", {})
        end
        Timers:CreateTimer(0.7, function()
            UTIL_Remove(target)
        end)
    end
end