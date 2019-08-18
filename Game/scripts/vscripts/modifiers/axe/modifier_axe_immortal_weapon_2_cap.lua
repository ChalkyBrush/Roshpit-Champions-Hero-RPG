modifier_axe_immortal_weapon_2_cap = class({})

function modifier_axe_immortal_weapon_2_cap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_axe_immortal_weapon_2_cap:GetModifierMoveSpeed_Max(params)
	local cap = 820
	return cap
end

function modifier_axe_immortal_weapon_2_cap:IsHidden()
	return true
end
