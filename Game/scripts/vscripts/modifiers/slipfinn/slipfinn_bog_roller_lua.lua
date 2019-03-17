slipfinn_bog_roller_lua = class({})

function slipfinn_bog_roller_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end

function slipfinn_bog_roller_lua:GetModifierModelChange( params )
	return "models/heroes/pangolier/pangolier_gyroshell2_rubick.vmdl"
end

function slipfinn_bog_roller_lua:GetModifierTurnRate_Percentage( params )
	return -300
end

function slipfinn_bog_roller_lua:GetModifierModelScale( params )
	return 0.73
end

function slipfinn_bog_roller_lua:IsHidden()
    return true
end
