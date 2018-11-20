modifier_movespeed_cap_sonic = class({})

function modifier_movespeed_cap_sonic:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_sonic:GetModifierMoveSpeed_AbsoluteMax( params )
    return 750
end

function modifier_movespeed_cap_sonic:GetModifierMoveSpeed_Limit( params )
    return 750
end

function modifier_movespeed_cap_sonic:IsHidden()
    return true
end