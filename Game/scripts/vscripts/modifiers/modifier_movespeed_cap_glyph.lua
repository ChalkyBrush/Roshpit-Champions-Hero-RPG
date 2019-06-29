modifier_movespeed_cap_glyph = class({})

function modifier_movespeed_cap_glyph:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_movespeed_cap_glyph:GetModifierMoveSpeed_Max(params)
	return 620
end

function modifier_movespeed_cap_glyph:GetModifierMoveSpeed_Limit(params)
	return 620
end

function modifier_movespeed_cap_glyph:IsHidden()
	return true
end

function modifier_movespeed_cap_glyph:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
