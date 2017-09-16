modifier_movespeed_cap_shadow_walk_a = class({})

function modifier_movespeed_cap_shadow_walk_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_1:GetModifierMoveSpeed_Max( params )
    return 640
end

function modifier_movespeed_cap_shadow_walk_1:GetModifierMoveSpeed_Limit( params )
    return 640
end

function modifier_movespeed_cap_shadow_walk_1:IsHidden()
    return true
end