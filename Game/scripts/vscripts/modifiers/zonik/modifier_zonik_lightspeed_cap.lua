modifier_zonik_lightspeed_cap = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zonik_lightspeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_zonik_lightspeed_cap:GetModifierMoveSpeed_Max( params )
    cap = 600
    if self:GetAbility().e_4_level then
    	cap = self:GetAbility():GetSpecialValueFor("movespeed_cap") + self:GetAbility().e_4_level*ZHONIK_E4_MS_CAP_INCREASE
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_speedball") then
            cap = cap + 600
        end
        if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
            cap = cap + 200
        end
    end
    return cap
end

function modifier_zonik_lightspeed_cap:GetModifierMoveSpeed_Limit( params )
	local cap = self:GetAbility():GetSpecialValueFor("movespeed_cap") + self:GetAbility().e_4_level*ZHONIK_E4_MS_CAP_INCREASE
    if self:GetAbility():GetOwner():HasModifier("modifier_zonik_speedball") then
        cap = cap + 600
    end
    if self:GetAbility():GetOwner():HasModifier("modifier_zonik_glyph_5_1") then
        cap = cap + 200
    end
   --print("CAP:"..cap)
    return cap
end

function modifier_zonik_lightspeed_cap:IsHidden()
    return true
end