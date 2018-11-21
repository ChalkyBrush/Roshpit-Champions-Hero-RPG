modifier_movespeed_cap_heat_wave = class({})

function modifier_movespeed_cap_heat_wave:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap_heat_wave:GetModifierMoveSpeed_AbsoluteMax( params )
    return 640
end

function modifier_movespeed_cap_heat_wave:GetModifierMoveSpeed_Limit( params )
    return 640
end

function modifier_movespeed_cap_heat_wave:IsHidden()
    return true
end

function modifier_movespeed_cap_heat_wave:GetModifierIgnoreMovespeedLimit()
    return 1
end