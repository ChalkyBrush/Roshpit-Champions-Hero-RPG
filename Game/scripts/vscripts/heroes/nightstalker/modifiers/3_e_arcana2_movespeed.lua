require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_arcana2_movespeed = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_arcana2_movespeed

function class:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end
function class:OnCreated()
    if not IsServer() then
        return
    end
    self.movespeed_bonus = self:GetAbility():GetSpecialValueFor('movespeed_bonus')
end
function class:GetBonusMoveSpeed()
    return self.movespeed_bonus
end
function class:GetModifierMoveSpeed_Max(params)
    if not IsServer() then
        return
    end
    return 550 + self.movespeed_bonus
end

function class:GetModifierMoveSpeed_Limit(params)
    return self:GetModifierMoveSpeed_Max(params)
end
function class:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    return self.movespeed_bonus
end

function class:IsHidden()
    return true
end
