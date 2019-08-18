modifier_arkimus_speed_dash = class({})

function modifier_arkimus_speed_dash:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
    }

    return funcs
end

function modifier_arkimus_speed_dash:GetModifierMoveSpeed_Max(params)
    local cap = 1300
    return cap
end

function modifier_arkimus_speed_dash:IsHidden()
    return true
end
