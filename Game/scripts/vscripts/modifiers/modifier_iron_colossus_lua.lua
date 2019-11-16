require('/items/constants/helm')
require('global_constants')

modifier_iron_colossus_lua = class({})

function modifier_iron_colossus_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MAX_ATTACK_RANGE,
        MODIFIER_PROPERTY_BASE_ROSHPIT_ARMOR
    }

    return funcs
end

function modifier_iron_colossus_lua:GetModifierBaseAttack_BonusDamage(params)
	local hero = self:GetParent()
	local str_mult = IRON_COLOSSUS_ATT_PER_STR + self:GetAbility():GetFinalGemPropertyValue("amethyst", IRON_COLOSSUS_AMETHYST)
	return hero:GetStrength()*str_mult
end

function modifier_iron_colossus_lua:GetModifierModelScale(params)
    return IRON_COLOSSUS_MODEL_SCALE
end

function modifier_iron_colossus_lua:GetModifierMaxAttackRange(params)
	local target_range = IRON_COLOSSUS_ATT_RNG
    return target_range
end

-- function modifier_iron_colossus_lua:GetBaseRoshpitArmorBonus()
-- 	local armor_per_str = IRON_COLOSSUS_AMR_PER_STR + self:GetAbility():GetFinalGemPropertyValue("emerald", IRON_COLOSSUS_EMERALD)
-- 	print(armor_per_str)
-- 	return hero:GetStrength()*armor_per_str
-- end


function modifier_iron_colossus_lua:GetAttackSound(params)
    return "RPCItems.IronColossus.Attack"
end

function modifier_iron_colossus_lua:IsHidden()
    return true
end

function modifier_iron_colossus_lua:RemoveOnDeath()
    return false
end