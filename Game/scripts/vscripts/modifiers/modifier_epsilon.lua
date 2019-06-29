modifier_epsilon = class({})

function modifier_epsilon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}

	return funcs
end

function modifier_epsilon:GetModifierProjectileSpeedBonus(params)
	return 700
end

function modifier_epsilon:GetAttackSound(params)
	return "RPC.Epsilon.AttackSound"
end

function modifier_epsilon:IsHidden()
	return true
end
