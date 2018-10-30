modifier_q_slow = class({})
local class = modifier_q_slow

function class:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
	return funcs
end

function class:IsDebuff()
	return true
end

function class:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function class:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function class:IsHidden()
	return false
end