require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_1_e_movespeed = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_e_movespeed

function class:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end
function class:GetBonusMoveSpeed()
    return CHERNOBOG_E1_MOVESPEED * self:GetAbility().e1_level
end
function class:GetModifierMoveSpeed_Max(params)
    if not self.movespeed_max then
        self.movespeed_max = self:GetAbility():GetSpecialValueFor('movespeed_cap')
    end
    return self.movespeed_max + self:GetBonusMoveSpeed()
end

function class:GetModifierMoveSpeed_Limit(params)
    return self:GetModifierMoveSpeed_Max(params)
end
function class:GetModifierMoveSpeedBonus_Constant(params)
    if not self.movespeed_increase then
        self.movespeed_increase = self:GetAbility():GetSpecialValueFor('movespeed_bonus')
    end
    return self.movespeed_increase + self:GetBonusMoveSpeed()
end

function class:IsHidden()
    return true
end
