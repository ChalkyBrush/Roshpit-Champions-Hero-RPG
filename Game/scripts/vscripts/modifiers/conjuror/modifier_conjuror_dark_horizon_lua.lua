modifier_conjuror_dark_horizon_lua = class({})

function modifier_conjuror_dark_horizon_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}

	return funcs
end

function modifier_conjuror_dark_horizon_lua:GetModifierModelChange(params)
	return "models/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ico.vmdl"
end
