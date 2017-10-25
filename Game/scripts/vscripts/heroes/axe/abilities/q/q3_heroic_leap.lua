require('heroes/axe/arcana_ability')
local Sunder = require('heroes/axe/abilities/r/r_sunder')
local TectonicSunder = require('heroes/axe/abilities/arcana1_r/r_tectonic_sunder')
local function cast(caster, ability)

    if caster.c_a_level <= 0 then
        return false
    end

    local damageAmp = caster.c_a_level*Q3_AMPLIFY_PERCENT/100
    if caster:HasAbility("sunder") then
        local sunderAbility = caster:FindAbilityByName("sunder")
        local damage = sunderAbility:GetSpecialValueFor("main_damage")/100 * caster:GetHealth() * damageAmp
        Sunder.createDunk(caster, damage)
    elseif caster:HasAbility("axe_arcana_smash") then
        local eventTable = {}
        eventTable.caster = caster
        eventTable.ability = caster:FindAbilityByName("axe_arcana_smash")
        eventTable.target_points = {}
        eventTable.forks = 1
        eventTable.amp = damageAmp
        eventTable.attack_power_mult_percent = eventTable.ability:GetLevelSpecialValueFor("attack_power_mult_percent", eventTable.ability:GetLevel())
        eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel())
        eventTable.target_points[1] = caster:GetAbsOrigin() + ability.jumpFV * 200

        Timers:CreateTimer(0.1, function()
            caster:SetForwardVector(ability.jumpFV)
        end)
        TectonicSunder.castWithoutCastTime(eventTable)
    end
    return true
end

local module = {}
module.cast = cast
return module