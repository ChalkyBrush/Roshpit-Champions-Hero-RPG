local function applyDebuff(caster, target, ability)
    local runesCount = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
    if runesCount <= 0 then
        return
    end
    local duration = Filters:GetAdjustedBuffDuration(caster, ARCANA1_R3_DURATION, false)

    ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_c_d_arcana1_visible", {duration = duration})
    target:SetModifierStackCount("modifier_axe_rune_c_d_arcana1_visible", caster, runesCount)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_c_d_arcana1_invisible", {duration = duration})
    target:SetModifierStackCount("modifier_axe_rune_c_d_arcana1_invisible", caster, runesCount)
end

local module = {}
module.applyDebuff = applyDebuff
return module