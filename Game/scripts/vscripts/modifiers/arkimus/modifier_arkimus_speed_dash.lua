modifier_arkimus_speed_dash = class({})

function modifier_arkimus_speed_dash:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_arkimus_speed_dash:GetModifierMoveSpeed_AbsoluteMax( params )
	local cap = 1300
    return cap
end

function modifier_arkimus_speed_dash:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_arkimus_speed_dash:GetModifierMoveSpeed_Limit( params )
	local cap = 1300
    return cap
end

function modifier_arkimus_speed_dash:IsHidden()
    return true
end