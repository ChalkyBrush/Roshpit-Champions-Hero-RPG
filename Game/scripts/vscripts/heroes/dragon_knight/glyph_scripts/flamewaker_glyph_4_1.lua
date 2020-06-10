require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_4_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_4_1
local itemClassName = 'item_rpc_flamewaker_glyph_4_1'

modifier_flamewaker_glyph_4_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_4_1
local modifierName = 'modifier_flamewaker_glyph_4_1'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_4_1", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_glyph_4_1_slow_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_glyph_4_1_slow_effect", "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_4_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ON_HIT_W_ABILITY
    })
end

function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnHitWAbility(event)
	local hero = event.attacker
	local target = event.victim
	target:AddNewModifier(hero, self:GetAbility(), "modifier_flamewaker_glyph_4_1_slow_effect", {duration = FLAMEWAKER_GLYPH_4_1_SLOW_DURATION })
end

-- SLOW MODIFIER

function modifier_flamewaker_glyph_4_1_slow_effect:IsHidden()
	return false
end

function modifier_flamewaker_glyph_4_1_slow_effect:IsDebuff()
	return true
end

function modifier_flamewaker_glyph_4_1_slow_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_flamewaker_glyph_4_1_slow_effect:GetModifierAttackSpeedBonus_Constant()
	return FLAMEWAKER_GLYPH_4_1_AS_SLOW
end

function modifier_flamewaker_glyph_4_1_slow_effect:GetModifierMoveSpeedBonus_Constant()
	return FLAMEWAKER_GLYPH_4_1_MS_SLOW
end

function modifier_flamewaker_glyph_4_1_slow_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_flamewaker_glyph_4_1_slow_effect:StatusEffectPriority()
	return 10
end

function modifier_flamewaker_glyph_4_1_slow_effect:GetTexture()
	return "flamewaker/blue_flame"
end