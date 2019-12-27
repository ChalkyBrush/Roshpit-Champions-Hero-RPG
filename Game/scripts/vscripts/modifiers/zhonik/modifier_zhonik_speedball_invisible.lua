modifier_zhonik_speedball_invisible = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zhonik_speedball_invisible:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_zhonik_speedball_invisible:GetModifierMoveSpeed_Max_Increase(params)
    local cap = self:GetAbility():GetSpecialValueFor("movespeed_cap_bonus")
    return cap
end

function modifier_zhonik_speedball_invisible:GetModifierMoveSpeedBonus_Constant(params)
    local cap = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
    return cap
end

function modifier_zhonik_speedball_invisible:IsHidden()
    return true
end
