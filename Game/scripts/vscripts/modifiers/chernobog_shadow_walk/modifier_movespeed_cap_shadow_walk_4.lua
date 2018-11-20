modifier_movespeed_cap_shadow_walk_4 = class({})

function modifier_movespeed_cap_shadow_walk_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_4:GetModifierMoveSpeed_AbsoluteMax( params )
    return 625
end

function modifier_movespeed_cap_shadow_walk_4:GetModifierMoveSpeed_Limit( params )
    return 625
end

function modifier_movespeed_cap_shadow_walk_4:IsHidden()
    return true
end