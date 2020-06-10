require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_5_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_5_2
local itemClassName = 'item_rpc_flamewaker_glyph_5_2'

modifier_flamewaker_glyph_5_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_5_2
local modifierName = 'modifier_flamewaker_glyph_5_2'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_5_2", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_glyph_5_2_volcano_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_glyph_5_2_volcano_shield", "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_5_2", LUA_MODIFIER_MOTION_NONE)

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
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY
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

function modifierClass:OnCastRAbility()
	local hero = self:GetParent()
	local duration = Filters:GetAdjustedBuffDuration(hero, FLAMEWAKER_GLYPH_5_2_SHIELD_DURATION, false)
	hero:AddNewModifier(hero, self:GetAbility(), "modifier_flamewaker_glyph_5_2_volcano_shield", {duration = duration})
	hero:SetModifierStackCount("modifier_flamewaker_glyph_5_2_volcano_shield", hero, FLAMEWAKER_GLYPH_5_2_SHIELD_STACKS)
end

-- VOLCANO SHIELD MOFIIER

function modifier_flamewaker_glyph_5_2_volcano_shield:IsHidden()
	return false
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetTexture()
	return "phoenix_supernova"
end

function modifier_flamewaker_glyph_5_2_volcano_shield:IsBuff()
	return true
end

function modifier_flamewaker_glyph_5_2_volcano_shield:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
    	MODIFIER_ROSHPIT_EVENT_FINAL_TAKE_DAMAGE
    })
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetEffectName()
	return "particles/roshpit/red_general/cyclone_shield.vpcf"
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetPhysicalDamageReduction()
	return FLAMEWAKER_GLYPH_5_2_SHIELD_DMG_REDUCE/100
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetMagicalDamageReduction()
	return FLAMEWAKER_GLYPH_5_2_SHIELD_DMG_REDUCE/100
end

function modifier_flamewaker_glyph_5_2_volcano_shield:GetPureDamageReduction()
	return FLAMEWAKER_GLYPH_5_2_SHIELD_DMG_REDUCE/100
end

function modifier_flamewaker_glyph_5_2_volcano_shield:RoshpitEventFinalTakeDamage(event)
	local hero = self:GetParent()
	local attacker = event.attacker
	CustomAbilities:HitShieldGeneric(hero, attacker, hero, "modifier_flamewaker_glyph_5_2_volcano_shield")
end