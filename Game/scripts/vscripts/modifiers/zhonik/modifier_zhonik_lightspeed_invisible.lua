modifier_zhonik_lightspeed_invisible = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zhonik_lightspeed_invisible:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_zhonik_lightspeed_invisible:GetModifierMoveSpeed_Max_Increase(params)
    local cap = 0
    if IsServer() then
        cap = self:GetAbility():GetSpecialValueFor("movespeed_cap_increase") + self:GetParent():GetRuneValue("e", 4) * ZHONIK_E4_MS_CAP_INCREASE
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
            cap = cap + ZHONIK_GLYPH_5_1_LIGHTSPEED_ADDITIONAL_MS
        end
    end
    return cap
end

function modifier_zhonik_lightspeed_invisible:GetModifierMoveSpeedBonus_Constant(params)
    local movespeed = 0
    if IsServer() then
        movespeed = self:GetAbility():GetSpecialValueFor("movespeed_bonus") + self:GetParent():GetRuneValue("e", 1) * ZHONIK_E1_MS
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
            movespeed = movespeed + ZHONIK_GLYPH_5_1_LIGHTSPEED_ADDITIONAL_MS
        end
    end
    return movespeed
end

function modifier_zhonik_lightspeed_invisible:IsHidden()
    return true
end
