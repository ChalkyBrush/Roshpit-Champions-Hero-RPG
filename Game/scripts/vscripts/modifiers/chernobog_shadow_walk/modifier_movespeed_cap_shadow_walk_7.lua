modifier_movespeed_cap_shadow_walk_7 = class({})

function modifier_movespeed_cap_shadow_walk_7:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_7:GetModifierMoveSpeed_Max( params )
    return 700
end

function modifier_movespeed_cap_shadow_walk_7:GetModifierMoveSpeed_Limit( params )
    return 700
end

function modifier_movespeed_cap_shadow_walk_7:IsHidden()
    return true
end