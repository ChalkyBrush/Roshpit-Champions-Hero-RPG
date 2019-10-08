modifier_trapper_immo3_effect = class({})

function modifier_trapper_immo3_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }

    return funcs
end

function modifier_trapper_immo3_effect:GetModifierCastRangeBonus(params)
    local hero = self:GetParent()
    local range = TRAPPER_IMMORTAL_WEAPON_3_RANGE
    if hero:HasModifier("modifier_hood_of_lords_lua") then
        range = range + 140
    end
    if hero:HasModifier("modifier_vermillion_dream_lua") then
        range = range + 420
    end
    return range
end

function modifier_trapper_immo3_effect:IsHidden()
    return true
end
