modifier_zonik_speedball_cap = class({})

function modifier_zonik_speedball_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_zonik_speedball_cap:GetModifierMoveSpeed_Max( params )
	local cap = 550 + 600
    return cap
end

function modifier_zonik_speedball_cap:GetModifierMoveSpeed_Limit( params )
	local cap = 550 + 600
    return cap
end

function modifier_zonik_speedball_cap:IsHidden()
    return true
end