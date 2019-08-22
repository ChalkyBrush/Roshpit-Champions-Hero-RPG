modifier_movespeed_cap_sonic = class({})

function modifier_movespeed_cap_sonic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap_sonic:GetModifierMoveSpeed_Max(params)
	local cap = 850
	return cap
end

function modifier_movespeed_cap_sonic:IsHidden()
	return true
end
