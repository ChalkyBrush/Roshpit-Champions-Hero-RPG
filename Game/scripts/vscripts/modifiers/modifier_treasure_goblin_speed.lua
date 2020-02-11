modifier_treasure_goblin_speed = class({})

function modifier_treasure_goblin_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }
    return funcs
end

function modifier_treasure_goblin_speed:GetModifierMoveSpeed_Absolute(params)
    local target = self:GetParent()
    return target.run_speed
end

function modifier_treasure_goblin_speed:IsHidden()
    return true
end
