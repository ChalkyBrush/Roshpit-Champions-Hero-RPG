slipfinn_shadow_rush_lua = class({})

function slipfinn_shadow_rush_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
    }

    return funcs
end

function slipfinn_shadow_rush_lua:GetModifierTurnRate_Percentage( params )
	local modifier = self
	local decay = modifier:GetRemainingTime()/self:GetParent().baseShadowRushDuration
    local cap = math.min(-400*decay, -50)
    return cap
end

function slipfinn_shadow_rush_lua:GetModifierMoveSpeed_AbsoluteMax( params )
	local modifier = self
	local decay = modifier:GetRemainingTime()/self:GetParent().baseShadowRushDuration
	local msBonus = modifier:GetParent():FindAbilityByName("slipfinn_shadow_rush"):GetLevelSpecialValueFor("ms_bonus_and_max", modifier:GetAbility():GetLevel())
    local cap = math.max(msBonus*decay, 550)
    return cap
end

function slipfinn_shadow_rush_lua:GetModifierMoveSpeed_Limit( params )
	local modifier = self
	local msBonus =  modifier:GetParent():FindAbilityByName("slipfinn_shadow_rush"):GetLevelSpecialValueFor("ms_bonus_and_max", modifier:GetAbility():GetLevel())
	local decay = modifier:GetRemainingTime()/self:GetParent().baseShadowRushDuration
    local cap = math.max(msBonus*decay, 550)
    return cap
end

function slipfinn_shadow_rush_lua:IsHidden()
    return true
end

function slipfinn_shadow_rush_lua:GetModifierMoveSpeedBonus_Constant( params )
	local modifier = self
	local msBonus =  modifier:GetParent():FindAbilityByName("slipfinn_shadow_rush"):GetLevelSpecialValueFor("ms_bonus_and_max", modifier:GetAbility():GetLevel())
	local decay = modifier:GetRemainingTime()/self:GetParent().baseShadowRushDuration
    local bonus = math.max(msBonus*decay, 0)
	return bonus
end