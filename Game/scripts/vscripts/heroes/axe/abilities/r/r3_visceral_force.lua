local function cast(caster, ability)
    local runesCount = caster.r_3_level
    if runesCount <= 0 then
        return
    end

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_3_visible", {duration = RED_GENERAL_R3_DURATION})
    caster:SetModifierStackCount("modifier_axe_rune_r_3_visible", caster, runesCount)
end

local module = {}
module.cast = cast
return module