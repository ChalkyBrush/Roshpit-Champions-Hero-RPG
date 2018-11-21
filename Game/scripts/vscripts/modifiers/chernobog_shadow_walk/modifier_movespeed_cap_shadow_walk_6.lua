modifier_movespeed_cap_shadow_walk_6 = class({})

function modifier_movespeed_cap_shadow_walk_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_6:GetModifierMoveSpeed_AbsoluteMax( params )
    return 675
end

function modifier_movespeed_cap_shadow_walk_6:GetModifierMoveSpeed_Limit( params )
    return 675
end

function modifier_movespeed_cap_shadow_walk_6:IsHidden()
    return true
end

function modifier_movespeed_cap_shadow_walk_6:GetModifierIgnoreMovespeedLimit()
    return 1
end