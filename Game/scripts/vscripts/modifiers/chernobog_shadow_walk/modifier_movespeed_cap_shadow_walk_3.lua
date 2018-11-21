modifier_movespeed_cap_shadow_walk_3 = class({})

function modifier_movespeed_cap_shadow_walk_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_3:GetModifierMoveSpeed_AbsoluteMax( params )
    return 600
end

function modifier_movespeed_cap_shadow_walk_3:GetModifierMoveSpeed_Limit( params )
    return 600
end

function modifier_movespeed_cap_shadow_walk_3:IsHidden()
    return true
end

function modifier_movespeed_cap_shadow_walk_3:GetModifierIgnoreMovespeedLimit()
    return 1
end