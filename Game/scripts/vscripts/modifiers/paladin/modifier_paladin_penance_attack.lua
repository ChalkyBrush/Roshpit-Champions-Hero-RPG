modifier_paladin_penance_attack_lua = class({})

function modifier_paladin_penance_attack_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_paladin_penance_attack_lua:GetAttackSound( params )
	return "Paladin.PenanceLaunch"
end

function modifier_paladin_penance_attack_lua:IsHidden()
    return true
end