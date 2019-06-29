modifier_conjuror_grand_earth_guardian_target_lua = class({})

function modifier_conjuror_grand_earth_guardian_target_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_DISABLE_TURNING
    }

    return funcs
end

function modifier_conjuror_grand_earth_guardian_target_lua:GetModifierIgnoreCastAngle(params)
    return 100
end

function modifier_conjuror_grand_earth_guardian_target_lua:GetModifierModelScale(params)
    local target = self:GetParent()
    if target:GetUnitName() == "earth_deity" then
        return 290
    else
        return - 100
    end
end

function modifier_conjuror_grand_earth_guardian_target_lua:GetModifierCastRangeBonus(params)
    return 1500
end

function modifier_conjuror_grand_earth_guardian_target_lua:GetModifierDisableTurning(params)
    return 100
end
