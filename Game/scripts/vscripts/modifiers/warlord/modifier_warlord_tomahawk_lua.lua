modifier_warlord_tomahawk_lua = class({})

function modifier_warlord_tomahawk_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
    }

    return funcs
end

function modifier_warlord_tomahawk_lua:GetAttackSound( params )
	return "Warlord.TomahawkAttackSound"
end

function modifier_warlord_tomahawk_lua:GetModifierTurnRate_Percentage( params )
	return 1000
end

function modifier_warlord_tomahawk_lua:IsHidden()
    return true
end