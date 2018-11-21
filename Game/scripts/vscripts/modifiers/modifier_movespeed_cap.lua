modifier_movespeed_cap = class({})

function modifier_movespeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap:GetModifierMoveSpeed_AbsoluteMax( params )
    return 1400
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Limit( params )
    return 1400
end

function modifier_movespeed_cap:IsHidden()
    return true
end

function modifier_movespeed_cap:GetModifierIgnoreMovespeedLimit()
    return 1
end