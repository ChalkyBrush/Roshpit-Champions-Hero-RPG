modifier_movespeed_cap_shadow_walk_3 = class({})

function modifier_movespeed_cap_shadow_walk_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_movespeed_cap_shadow_walk_3:GetModifierMoveSpeed_Max(params)
	return 600
end

function modifier_movespeed_cap_shadow_walk_3:GetModifierMoveSpeed_Limit(params)
	return 600
end

function modifier_movespeed_cap_shadow_walk_3:IsHidden()
	return true
end
