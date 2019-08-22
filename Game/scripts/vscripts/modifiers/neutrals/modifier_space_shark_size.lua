modifier_space_shark_size = class({})

function modifier_space_shark_size:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
	}

	return funcs
end

function modifier_space_shark_size:GetModifierModelScale(params)
	return 35
end
