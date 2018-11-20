modifier_disciple_bonus_movespeed = class({})
local class = modifier_disciple_bonus_movespeed

function class:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
	return funcs
end

function class:OnCreated( event )
	self.movespeed = event.movespeed
end

function class:GetModifierMoveSpeed_Limit()
	print(self.movespeed)
	return self.movespeed
end

function class:GetModifierMoveSpeed_AbsoluteMax()
	return self.movespeed
end

function class:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end

function class:IsDebuff()
	return false
end

function class:IsHidden()
	return true
end