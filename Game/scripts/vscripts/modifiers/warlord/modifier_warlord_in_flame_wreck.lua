modifier_warlord_in_flame_wreck = class({})

function modifier_warlord_in_flame_wreck:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_warlord_in_flame_wreck:GetModifierMoveSpeed_Max(params)
	local modifier = self
    local cap = modifier:GetAbility():GetSpecialValueFor("ms_cap")
    return cap
end

function modifier_warlord_in_flame_wreck:IsHidden()
    return true
end

function modifier_warlord_in_flame_wreck:GetModifierMoveSpeedBonus_Constant(params)
    local modifier = self
    local msBonus = modifier:GetAbility():GetSpecialValueFor("ms_bonus")
    return msBonus
end
