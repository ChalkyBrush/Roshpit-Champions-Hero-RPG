require('/items/constants/trinket')
modifier_epsilon = class({})

function modifier_epsilon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}

	return funcs
end

function modifier_epsilon:GetModifierProjectileSpeedBonus(params)
	local ability = self:GetAbility()
	return ITEM_RPC_EPSILONS_EYEGLASS_PROJECTILE_SPEED + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EPSILONS_EYEGLASS_GEM_EMERALD)
end

function modifier_epsilon:GetAttackSound(params)
	return "RPC.Epsilon.AttackSound"
end

function modifier_epsilon:IsHidden()
	return true
end
