modifier_draghor_shapeshift_hawk_lua = class({})

function modifier_draghor_shapeshift_hawk_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function modifier_draghor_shapeshift_hawk_lua:GetModifierModelScale( params )
    return 45
end