require('heroes/phantom_assassin/voltex_constants')

function Voltex_Overcharge_OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    Filters:CastSkillArguments(1, caster)
    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
    local buffDuration = ability:GetSpecialValueFor("duration")
    if caster:HasModifier("modifier_voltex_glyph_5_a") then
        buffDuration = buffDuration*((100+VOLTEX_5_A_DURATION_INCREASE_PCT)/100)
    end
    buffDuration = Filters:GetAdjustedBuffDuration(caster, buffDuration, false)
    caster:RemoveModifierByName("modifier_gods_strength_datadriven")
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_gods_strength_datadriven", {duration = buffDuration})
    if caster:HasModifier("modifier_voltex_glyph_1_1") then
        local ability = event.ability
        caster:RemoveModifierByName("modifier_voltex_glyph_1_1_effect")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_1_1_effect", {duration = buffDuration})
    end
    if caster:HasModifier("modifier_voltex_glyph_2_1") then
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_visible", {duration = buffDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_invisible", {duration = buffDuration})
        Timers:CreateTimer(0.03, function()
            local agility = caster:GetBaseAgility()
            caster:SetModifierStackCount( "modifier_voltex_glyph_2_1_effect_invisible", ability, agility)
        end)
    end
end