modifier_movespeed_cap = class({})

function modifier_movespeed_cap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Max(params)
	local cap = 1400
	return cap
end

function modifier_movespeed_cap:IsHidden()
	return true
end
