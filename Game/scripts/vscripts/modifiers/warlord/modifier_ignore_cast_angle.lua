modifier_ingore_cast_angle = class({})

function modifier_ingore_cast_angle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

function modifier_ingore_cast_angle:GetModifierIgnoreCastAngle(params)
	return 1000
end

function modifier_ingore_cast_angle:IsHidden()
	return true
end
