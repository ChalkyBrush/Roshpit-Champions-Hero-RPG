modifier_movespeed_cap_shadow_walk_5 = class({})

function modifier_movespeed_cap_shadow_walk_5:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap_shadow_walk_5:GetModifierMoveSpeed_AbsoluteMax( params )
    return 650
end

function modifier_movespeed_cap_shadow_walk_5:GetModifierMoveSpeed_Limit( params )
    return 650
end

function modifier_movespeed_cap_shadow_walk_5:IsHidden()
    return true
end

function modifier_movespeed_cap_shadow_walk_5:GetModifierIgnoreMovespeedLimit()
    return 1
end