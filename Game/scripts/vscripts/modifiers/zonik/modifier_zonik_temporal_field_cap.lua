modifier_zonik_temporal_field_cap = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zonik_temporal_field_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_zonik_temporal_field_cap:GetModifierMoveSpeed_Max(params)
    -- local cap = self:GetAbility():GetSpecialValueFor("movespeed_cap") + self:GetAbility().e_4_level*10
    --    if self:GetAbility():GetOwner():HasModifier("modifier_zonik_speedball") then
    --        cap = cap + 600
    --    end
    --    if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
    --        cap = cap + 120
    --    end
    --   --print("CAP:"..cap)
    local cap = self:GetAbility():GetSpecialValueFor("movespeed_cap")
    return cap
end

function modifier_zonik_temporal_field_cap:IsHidden()
    return true
end
