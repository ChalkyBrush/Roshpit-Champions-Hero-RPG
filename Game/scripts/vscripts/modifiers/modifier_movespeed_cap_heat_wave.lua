modifier_movespeed_cap_heat_wave = class({})

function modifier_movespeed_cap_heat_wave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap_heat_wave:GetModifierMoveSpeed_Max(params)
	local cap = 640
	return cap
end

function modifier_movespeed_cap_heat_wave:IsHidden()
	return true
end
