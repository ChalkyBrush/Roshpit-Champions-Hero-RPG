modifier_zonik_speedball_cap = class({})

function modifier_zonik_speedball_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_zonik_speedball_cap:GetModifierMoveSpeed_Max( params )
	local cap = 550 + self:GetAbility():GetSpecialValueFor("movespeed_cap")
    if self:GetCaster():HasModifier("modifier_zonik_lightspeed") then
        cap = cap + self:GetCaster():FindAbilityByName("zonik_lightspeed"):GetSpecialValueFor("movespeed_cap")-550
    end
    if self:GetCaster():FindAbilityByName("zonik_lightspeed") and self:GetCaster():FindAbilityByName("zonik_lightspeed").e_4_level and self:GetCaster():HasModifier("modifier_zonik_lightspeed") then
        cap = cap + 10*self:GetCaster():FindAbilityByName("zonik_lightspeed").e_4_level
    end
    if self:GetCaster():HasModifier("modifier_zonik_lightspeed") and self:GetCaster():HasModifier("modifier_zonik_glyph_5_1") then
        cap = cap + 200
    end
    return cap
end

function modifier_zonik_speedball_cap:GetModifierMoveSpeed_Limit( params )
	local cap = 550 + self:GetAbility():GetSpecialValueFor("movespeed_cap")
    if self:GetCaster():HasModifier("modifier_zonik_lightspeed") then
        cap = cap + self:GetCaster():FindAbilityByName("zonik_lightspeed"):GetSpecialValueFor("movespeed_cap")-550
    end
    if self:GetCaster():FindAbilityByName("zonik_lightspeed") and self:GetCaster():FindAbilityByName("zonik_lightspeed").e_4_level and self:GetCaster():HasModifier("modifier_zonik_lightspeed") then
        cap = cap + 10*self:GetCaster():FindAbilityByName("zonik_lightspeed").e_4_level
    end
    if self:GetCaster():HasModifier("modifier_zonik_lightspeed") and self:GetCaster():HasModifier("modifier_zonik_glyph_5_1") then
        cap = cap + 200
    end
    return cap
end

function modifier_zonik_speedball_cap:IsHidden()
    return true
end