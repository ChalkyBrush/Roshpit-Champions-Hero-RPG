modifier_draghor_shapeshift_shrink = class({})

function modifier_draghor_shapeshift_shrink:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
	}

	return funcs
end

function modifier_draghor_shapeshift_shrink:GetModifierModelScale(params)
	return - 60
end
