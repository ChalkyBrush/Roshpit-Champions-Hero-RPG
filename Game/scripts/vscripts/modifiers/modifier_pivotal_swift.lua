modifier_pivotal_swift = class({})

function modifier_pivotal_swift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_pivotal_swift:GetModifierMoveSpeed_Max(params)
	local cap = 850
	return cap
end