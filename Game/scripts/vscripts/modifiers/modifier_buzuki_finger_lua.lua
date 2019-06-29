modifier_buzuki_finger_lua = class({})

function modifier_buzuki_finger_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
	}

	return funcs
end

function modifier_buzuki_finger_lua:GetModifierModelScale(params)
	return 30
end
