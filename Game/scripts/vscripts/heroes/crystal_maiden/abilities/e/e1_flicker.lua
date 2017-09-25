local function cast(caster, ability)
    local runesCount = caster.a_c_level
    if runesCount == nil or runesCount <= 0 then
        return
    end
    local current_stack = caster:GetModifierStackCount( "modifier_flicker_charges", ability )
    local stacksSpend = E1_STACKS_SPEND

    if caster:HasModifier('modifier_sorceress_glyph_4_2') then
        stacksSpend = T42_STACKS_SPEND
    end

    if current_stack >= stacksSpend then
        ability:EndCooldown()
        EmitSoundOn("DOTA_Item.DiffusalBlade.Activate", caster)
        EmitSoundOn("DOTA_Item.DiffusalBlade.Activate", caster)
        caster:SetModifierStackCount( "modifier_flicker_charges", ability, current_stack - stacksSpend )
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_flicker_charges", {})
        caster:SetModifierStackCount( "modifier_flicker_charges", ability, current_stack + runesCount )
    end
end
local module = {}
module.cast = cast
return module