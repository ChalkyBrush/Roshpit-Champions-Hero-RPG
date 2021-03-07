require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_glyph_4_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_4_1
local itemClassName = 'item_rpc_chernobog_glyph_4_1'

modifier_chernobog_glyph_4_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_4_1
local modifierName = 'modifier_chernobog_glyph_4_1'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyph_scripts/chernobog_glyph_4_1", LUA_MODIFIER_MOTION_NONE)

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

function modifierClass:OnCreated()
    if not IsServer() then
	    return 
	end
	self:SetSpecialTypes({
	    MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
	    MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
	})
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - 500)
    return ms_over_threshold * CHERNOBOG_GLYPH_4_1_BAD_OVER_THRES / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - 500)
    return ms_over_threshold * CHERNOBOG_GLYPH_4_1_BAD_OVER_THRES / 100
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - 500)
    return ms_over_threshold * CHERNOBOG_GLYPH_4_1_BAD_OVER_THRES / 100
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    local ms = self:GetCaster():GetActualMovespeed()
	local ms_over_threshold = math.max(0, ms - 500)
    return ms_over_threshold * CHERNOBOG_GLYPH_4_1_BAD_OVER_THRES / 100
end
