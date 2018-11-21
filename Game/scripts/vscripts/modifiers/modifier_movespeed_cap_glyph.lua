modifier_movespeed_cap_glyph = class({})

function modifier_movespeed_cap_glyph:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_movespeed_cap_glyph:GetModifierMoveSpeed_AbsoluteMax( params )
    return 620
end

function modifier_movespeed_cap_glyph:GetModifierMoveSpeed_Limit( params )
    return 620
end

function modifier_movespeed_cap_glyph:IsHidden()
    return true
end

function modifier_movespeed_cap_glyph:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_movespeed_cap_glyph:GetModifierIgnoreMovespeedLimit()
    return 1
end