modifier_rpc_attributes = class({})

function modifier_rpc_attributes:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE
    }

    return funcs
end

function modifier_rpc_attributes:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_rpc_attributes:GetModifierHealthRegenPercentageUnique(params)
    local hero = self:GetParent()
    return 0
end

function modifier_rpc_attributes:GetModifierHealthBonus(params)
    -- local hero = self:GetParent()
    -- local healthDiff = -10
    return 0
end

function modifier_rpc_attributes:GetModifierStatusResistance(params)
    return - 5000
end

function modifier_rpc_attributes:IsHidden()
    return true
end
