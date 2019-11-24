require('heroes/dragon_knight/flamewaker_constants')
modifier_movespeed_cap_heat_wave = class({})

function modifier_movespeed_cap_heat_wave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_movespeed_cap_heat_wave:GetModifierMoveSpeed_Max_Increase(params)
	return FLAMEWAKER_E_MS_CAP_BONUS
end

function modifier_movespeed_cap_heat_wave:IsHidden()
	return true
end
