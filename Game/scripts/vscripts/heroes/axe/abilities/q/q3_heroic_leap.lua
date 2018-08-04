require('heroes/axe/arcana_ability')
local Sunder = require('heroes/axe/abilities/r/r_sunder')
local TectonicSunder = require('heroes/axe/abilities/arcana1_r/r_tectonic_sunder')
local function cast(caster, ability)

    if caster.c_a_level <= 0 then
        return false
    end

    local damageAmp = caster.c_a_level*RED_GENERAL_Q3_AMPLIFY_PERCENT/100
    if caster:HasAbility("sunder") then
        local sunderAbility = caster:FindAbilityByName("sunder")
        local damage = sunderAbility:GetSpecialValueFor("main_damage")/100 * caster:GetHealth() * damageAmp
        local procsCount = 1
        local delay = Filters:GetDelayWithCastSpeed(caster, 0.35)
        if caster:HasModifier("modifier_axe_glyph_6_1") then
            procsCount = T61_DUNKS_COUNT
        end
        for i = 0, procsCount - 1, 1 do
            Timers:CreateTimer(i*delay,
                function()
                    Sunder.createDunk(caster, damage)
                end)
        end
    elseif caster:HasAbility("axe_arcana_smash") then
        local eventTable = {}
        eventTable.caster = caster
        eventTable.ability = caster:FindAbilityByName("axe_arcana_smash")
        eventTable.target_points = {}
        eventTable.forks = 1
        eventTable.amp = damageAmp
        eventTable.attack_power_mult_percent = eventTable.ability:GetLevelSpecialValueFor("attack_power_mult_percent", eventTable.ability:GetLevel()-1)
        eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel()-1)
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