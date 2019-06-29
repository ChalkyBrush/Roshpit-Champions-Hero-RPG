modifier_super_ascendency_lua = class({})

function modifier_super_ascendency_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function modifier_super_ascendency_lua:GetModifierModelScale(params)
    return 20
end

function modifier_super_ascendency_lua:GetModifierAttackRangeBonus(params)
    return 0
end

function modifier_super_ascendency_lua:GetModifierProjectileSpeedBonus(params)
    return 500
end

-- function modifier_super_ascendency_lua:GetModifierBaseAttackTimeConstant( params )
--     return 0.9
-- end

-- function modifier_chernobog_demonform_lua:GetModifierAttackPointConstant( params )
-- return -0.1
-- end

function modifier_super_ascendency_lua:GetAttackSound(params)
    return "RPCItem.Ascendancy.Attack"
end

function modifier_super_ascendency_lua:IsHidden()
    return true
end
