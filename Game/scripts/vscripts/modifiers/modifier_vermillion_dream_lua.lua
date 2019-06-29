modifier_vermillion_dream_lua = class({})

function modifier_vermillion_dream_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }

    return funcs
end

function modifier_vermillion_dream_lua:GetModifierCastRangeBonus(params)
    local hero = self:GetParent()
    local range = 420
    if hero:HasModifier("modifier_hood_of_lords_lua") then
        range = range + 140
    end
    return range
end

function modifier_vermillion_dream_lua:IsHidden()
    return true
end
