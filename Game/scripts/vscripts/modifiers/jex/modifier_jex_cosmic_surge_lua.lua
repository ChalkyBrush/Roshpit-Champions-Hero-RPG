modifier_jex_cosmic_surge_lua = class({})

function modifier_jex_cosmic_surge_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }
    return funcs
end

function modifier_jex_cosmic_surge_lua:GetModifierIgnoreMovespeedLimit(params)
    return 1
end

function modifier_jex_cosmic_surge_lua:GetModifierMoveSpeed_AbsoluteMin(params)
    local ability = self:GetAbility()
    if ability.tech_level then
        return ability.tech_level * JEX_LIGHTNING_COSMIC_E_MIN_MS_PER_TECH + JEX_LIGHTNING_COSMIC_E_BASE_MIN_MS
    else
        return JEX_LIGHTNING_COSMIC_E_BASE_MIN_MS
    end
end

function modifier_jex_cosmic_surge_lua:IsHidden()
    return true
end
