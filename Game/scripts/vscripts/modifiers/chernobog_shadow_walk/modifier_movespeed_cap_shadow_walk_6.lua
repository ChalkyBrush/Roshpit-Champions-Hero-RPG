modifier_movespeed_cap_shadow_walk_6 = class({})

function modifier_movespeed_cap_shadow_walk_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_6:GetModifierMoveSpeed_Max( params )
    return 675
end

function modifier_movespeed_cap_shadow_walk_6:GetModifierMoveSpeed_Limit( params )
    return 675
end

function modifier_movespeed_cap_shadow_walk_6:IsHidden()
    return true
end