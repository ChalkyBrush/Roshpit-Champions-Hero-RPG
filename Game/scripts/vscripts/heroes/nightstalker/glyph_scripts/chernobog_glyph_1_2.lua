require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_glyph_1_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_1_2
local itemClassName = 'item_rpc_chernobog_glyph_1_2'

modifier_chernobog_glyph_1_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_1_2
local modifierName = 'modifier_chernobog_glyph_1_2'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyph_scripts/chernobog_glyph_1_2", LUA_MODIFIER_MOTION_NONE)

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
	self:SetSpecialTypes({MODIFIER_ROSHPIT_INTELLIGENCE_BONUS})
	self:StartIntervalThink(0.5)
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

function modifierClass:GetRoshpitIntelligenceBonus()
	local t_4_value = self:GetCaster():GetRuneValue("q", 4) + self:GetCaster():GetRuneValue("w", 4) + self:GetCaster():GetRuneValue("e", 4) + self:GetCaster():GetRuneValue("r", 4)
	return t_4_value * CHERNOBOG_GLYPH_1_2_INT
end
