modifier_zonik_lightspeed_cap = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zonik_lightspeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_zonik_lightspeed_cap:GetModifierMoveSpeed_Max(params)
    local cap = 550
    if IsServer() then
        cap = self:GetAbility():GetSpecialValueFor("movespeed_cap") + self:GetAbility().e_4_level * ZHONIK_E4_MS_CAP_INCREASE
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_speedball") then
            cap = cap + 600
        end
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
            cap = cap + 200
        end
    end
    return cap
end

function modifier_zonik_lightspeed_cap:IsHidden()
    return true
end
