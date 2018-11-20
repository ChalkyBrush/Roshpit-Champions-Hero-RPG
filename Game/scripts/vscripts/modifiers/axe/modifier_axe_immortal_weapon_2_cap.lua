modifier_axe_immortal_weapon_2_cap = class({})

function modifier_axe_immortal_weapon_2_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_axe_immortal_weapon_2_cap:GetModifierMoveSpeed_AbsoluteMax( params )
    --    end
    return 820
end

function modifier_axe_immortal_weapon_2_cap:GetModifierMoveSpeed_Limit( params )
    return 820
end

function modifier_axe_immortal_weapon_2_cap:IsHidden()
    return true
end