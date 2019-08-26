modifier_dinath_passive_ms_cap = class({})

require("/heroes/winter_wyvern/dinath_constants")

function modifier_dinath_passive_ms_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_dinath_passive_ms_cap:GetModifierMoveSpeed_Max(params)
    local cap = 600
    if self:GetAbility().w_3_level then
        cap = 600 + self:GetAbility().w_3_level * DINATH_ARCANA_W3_MOVESPEED_CAP_BONUS
    end
    return cap
end

function modifier_dinath_passive_ms_cap:IsHidden()
    return true
end
