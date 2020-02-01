require('/heroes/grimstroke/rubilash_constants')

modifier_rubilash_q1 = class({})

function modifier_rubilash_q1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }

    return funcs
end

function modifier_rubilash_q1:GetModifierCastRangeBonus(params)
    local hero = self:GetParent()
    local range = 0
    print("rubilash_modifier")
    if IsServer() then
        range = range + self:GetAbility().cast_range
    end
    return range
end

function modifier_rubilash_q1:IsHidden()
    return true
end

function modifier_rubilash_q1:RemoveOnDeath()
    return false
end