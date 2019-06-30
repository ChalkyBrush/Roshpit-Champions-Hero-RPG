modifier_movespeed_cap_super = class({})

function modifier_movespeed_cap_super:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_movespeed_cap_super:GetModifierMoveSpeed_Max(params)
	return 5200
end

function modifier_movespeed_cap_super:GetModifierMoveSpeed_Limit(params)
	return 5200
end

function modifier_movespeed_cap_super:IsHidden()
	return true
end
