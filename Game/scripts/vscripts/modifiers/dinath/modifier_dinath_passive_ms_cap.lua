modifier_dinath_passive_ms_cap = class({})

function modifier_dinath_passive_ms_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_dinath_passive_ms_cap:GetModifierMoveSpeed_AbsoluteMax( params )
    local cap = 600
    if self:GetAbility().w_3_level then
    	cap = 600 + self:GetAbility().w_3_level*5
    end
    return cap
end

function modifier_dinath_passive_ms_cap:GetModifierMoveSpeed_Limit( params )
    local cap = 600
    if self:GetAbility().w_3_level then
    	cap = 600 + self:GetAbility().w_3_level*5
    end
    return cap
end

function modifier_dinath_passive_ms_cap:IsHidden()
    return true
end

function modifier_dinath_passive_ms_cap:GetModifierIgnoreMovespeedLimit()
    return 1
end