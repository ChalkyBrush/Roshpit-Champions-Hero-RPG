modifier_draghor_feral_sprint = class({})

function modifier_draghor_feral_sprint:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }

    return funcs
end

function modifier_draghor_feral_sprint:GetModifierMoveSpeed_Max(params)
    cap = self:GetAbility():GetSpecialValueFor("movespeed_cap")
    return cap
end

function modifier_draghor_feral_sprint:IsHidden()
    return true
end
