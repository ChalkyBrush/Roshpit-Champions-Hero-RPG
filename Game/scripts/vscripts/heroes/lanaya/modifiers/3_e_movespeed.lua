require('/npc_abilities/base_modifier')
require('heroes/lanaya/constants')
modifier_trapper_3_e_movespeed = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_trapper_3_e_movespeed

function class:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end
function class:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    if not self.movespeed_max then
        self.movespeed_max = self:GetAbility():GetSpecialValueFor('movespeed_cap')
    end
    return self.movespeed_max
end

function class:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    if not self.movespeed_increase then
        self.movespeed_increase = self:GetAbility():GetSpecialValueFor('movespeed_cap')
    end
    return self.movespeed_increase
end

function class:IsHidden()
    return true
end

function class:RemoveOnDeath()
    return false
end