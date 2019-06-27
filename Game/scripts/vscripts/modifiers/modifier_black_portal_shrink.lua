modifier_black_portal_shrink = class({})

function modifier_black_portal_shrink:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
	}

	return funcs
end

function modifier_black_portal_shrink:GetModifierModelScale(params)
	return - 85
end
