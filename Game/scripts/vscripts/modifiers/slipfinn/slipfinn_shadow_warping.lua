slipfinn_shadow_warping = class({})

function slipfinn_shadow_warping:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function slipfinn_shadow_warping:GetModifierModelScale( params )
    return -95
end