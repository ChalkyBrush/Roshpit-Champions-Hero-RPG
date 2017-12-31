slipfinn_possessed_lua = class({})

function slipfinn_possessed_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function slipfinn_possessed_lua:GetModifierModelScale( params )
    return -50
end