modifier_ignore_ms_cap = class({})

function modifier_ignore_ms_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }
    return funcs
end

function modifier_ignore_ms_cap:GetModifierIgnoreMovespeedLimit(params)
    return 1
end

function modifier_ignore_ms_cap:IsHidden()
    return true
end
