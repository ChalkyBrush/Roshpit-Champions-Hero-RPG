modifier_movespeed_cap_shadow_walk_a = class({})

function modifier_movespeed_cap_shadow_walk_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap_shadow_walk_1:GetModifierMoveSpeed_Max(params)
	local cap = 640
	return cap
end

function modifier_movespeed_cap_shadow_walk_1:IsHidden()
	return true
end
