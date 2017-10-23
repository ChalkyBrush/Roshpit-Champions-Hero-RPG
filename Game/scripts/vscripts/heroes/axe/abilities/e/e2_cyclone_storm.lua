local function applyBuff(caster, ability)
    if caster.b_c_level > 0 then
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_b_c_tornado", {duration = b_c_duration})
        caster:SetModifierStackCount("modifier_axe_rune_b_c_tornado", caster, caster.b_c_level)
    end
end
local function refreshBuff(caster)
    if caster:HasModifier("modifier_axe_rune_b_c_tornado") then
        local whirlwindAbility = caster:FindAbilityByName("whirlwind")
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
        whirlwindAbility:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_b_c_tornado", {duration = b_c_duration})
    end
end

local module = {}
module.applyBuff = applyBuff
module.refreshBuff = refreshBuff
return module