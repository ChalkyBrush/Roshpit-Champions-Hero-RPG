modifier_movespeed_cap_shadow_walk_5 = class({})

function modifier_movespeed_cap_shadow_walk_5:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_5:GetModifierMoveSpeed_Max( params )
    return 650
end

function modifier_movespeed_cap_shadow_walk_5:GetModifierMoveSpeed_Limit( params )
    return 650
end

function modifier_movespeed_cap_shadow_walk_5:IsHidden()
    return true
end