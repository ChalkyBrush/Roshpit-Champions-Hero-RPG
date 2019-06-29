modifier_conjuror_attack_sound_translate = class({})

function modifier_conjuror_attack_sound_translate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_conjuror_attack_sound_translate:GetAttackSound(params)
	return "Conjuror.FireDeity.AttackR2"
end
