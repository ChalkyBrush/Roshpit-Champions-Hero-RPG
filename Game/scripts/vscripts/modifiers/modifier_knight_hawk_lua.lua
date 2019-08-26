modifier_knight_hawk_lua = class({})

function modifier_knight_hawk_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_knight_hawk_lua:GetModifierMoveSpeed_Max(params)
	local base_ms_cap = 550
	local cap_increase = 350
	return base_ms_cap + cap_increase
end

function modifier_knight_hawk_lua:IsHidden()
	return true
end
