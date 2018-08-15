local constants = require('heroes/hero_necrolyte/constants')

function start_channel(event)
    local caster = event.caster
    StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK_EVENT, rate=0.38})
end

function cast(event)
    local caster = event.caster
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

    local viper = CreateUnitByName("venomort_viper_summon", caster:GetAbsOrigin() + RandomVector(150), true, caster, caster, caster:GetTeamNumber())
    viper.creator = caster
    viper.dieTime = lifetime
    viper.owner = caster
    viper:SetOwner(caster)
    viper.creator = caster
    viper.owner = caster:GetPlayerOwnerID()
    local viperAbility = viper:FindAbilityByName("venomort_viper_ability")
    viperAbility:SetLevel(1)
    viperAbility:ApplyDataDrivenModifier(viper, viper, 'modifier_venomort_summon_attack_speed', nil)
    viper:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    viper:FindAbilityByName("hero_summon_ai"):SetLevel(1)
    viper:SetControllableByPlayer(caster:GetPlayerID(), true)

    local aiAbility = viper:FindAbilityByName("hero_summon_ai")
    if caster.bIsAIon == true or caster.bIsAIon == nil then
        aiAbility:ToggleAbility()
    end


    if caster:HasModifier("modifier_venomort_glyph_6_2") then
        viper:AddAbility("fire_temple_steadfast"):SetLevel(1)
    end


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
    local target = event.target
    local ability = event.ability
    local creator = caster.creator

    local r1_level = Runes:GetTotalRuneLevelGeneric(creator, 1, 3)
    if r1_level > 0 then
        local damage = caster:GetAverageTrueAttackDamage(caster) * r1_level * constants.R1_VIPER_DAMAGE_PERCENT/100

        if creator:HasModifier('modifier_venomort_immortal_weapon_1') then
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