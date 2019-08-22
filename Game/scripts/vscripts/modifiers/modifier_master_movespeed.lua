modifier_master_movespeed = class({})

function modifier_master_movespeed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX
    }
    return funcs
end

function modifier_master_movespeed:GetModifierMoveSpeed_AbsoluteMax(params)
    local target = self:GetParent()
    if target.master_move_speed then
        return target.master_move_speed
    else
        return 550
    end
end

function modifier_master_movespeed:IsHidden()
    return true
end
