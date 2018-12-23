modifier_chernobog_d_c_arcana2 = class({})

function modifier_chernobog_d_c_arcana2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_chernobog_d_c_arcana2:GetModifierMoveSpeed_Max( params )
    local cap = 550
    if self:GetAbility().e_4_level then
    	cap = cap + self:GetAbility().e_4_level*6
    end
    return cap
end

function modifier_chernobog_d_c_arcana2:GetModifierMoveSpeed_Limit( params )
    local cap = 550
    if self:GetAbility().e_4_level then
    	cap = cap + self:GetAbility().e_4_level*6
    end
    return cap
end

function modifier_chernobog_d_c_arcana2:GetModifierMoveSpeedBonus_Constant( params )
    local bonus = 6
    return bonus
end

function modifier_chernobog_d_c_arcana2:IsHidden()
    return true
end