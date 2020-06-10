require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_4_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_4_2
local itemClassName = 'item_rpc_flamewaker_glyph_4_2'

modifier_flamewaker_glyph_4_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_4_2
local modifierName = 'modifier_flamewaker_glyph_4_2'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_4_2", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_W_BASE_DMG_FLAT,
        MODIFIER_ROSHPIT_W_PCT_MANA_COST
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

function modifierClass:GetRoshpitWBaseDmgFlat()
	local hero = self:GetParent()
	return hero:GetSumOfAllAttributes()*FLAMEWAKER_GLYPH_4_2_W_BASE_DMG_STATS_MULT
end

function modifierClass:GetRoshpitWPctManaCostModifier()
	return FLAMEWAKER_GLYPH_4_2_W_MANA_COST_INCREASE_PCT/100
end