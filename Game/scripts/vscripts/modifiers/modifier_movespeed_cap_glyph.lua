modifier_movespeed_cap_glyph = class({})

function modifier_movespeed_cap_glyph:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap_glyph:GetModifierMoveSpeed_Max(params)
	local cap = 620
	return cap
end

function modifier_movespeed_cap_glyph:IsHidden()
	return true
end

function modifier_movespeed_cap_glyph:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
