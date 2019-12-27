modifier_zhonik_temporal_field_buff = class({})

require('/heroes/dark_seer/zhonik_constants')

function modifier_zhonik_temporal_field_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_zhonik_temporal_field_buff:GetModifierMoveSpeed_Max_Increase(params)
    local cap = self:GetAbility():GetSpecialValueFor("movespeed_cap_bonus")
    return cap
end
function modifier_zhonik_temporal_field_buff:GetModifierMoveSpeedBonus_Constant(params)
    local cap = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
    return cap
end
function modifier_zhonik_temporal_field_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.03)
end
function modifier_zhonik_temporal_field_buff:OnIntervalThink(event)
	local target = self:GetParent()
	local caster = self:GetParent()
	local ability = self:GetAbility()
    Filters:CleanseStuns(target)
    Filters:CleanseSilences(target)
    local e_3_level = caster:GetRuneValue("e", 3)
    if e_3_level > 0 then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_visible", {})
        local newStacks = math.min(target:GetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster) + 1, 1000)
        target:SetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster, newStacks)

        ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_invisible", {})
        target:SetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", caster, newStacks * e_3_level)
    end
end

function modifier_zhonik_temporal_field_buff:IsHidden()
    return false
end
function modifier_zhonik_temporal_field_buff:IsBuff()
    return true
end
