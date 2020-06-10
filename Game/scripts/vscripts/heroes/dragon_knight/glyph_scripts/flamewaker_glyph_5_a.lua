require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_5_a = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_5_a
local itemClassName = 'item_rpc_flamewaker_glyph_5_a'

modifier_flamewaker_glyph_5_a = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_5_a
local modifierName = 'modifier_flamewaker_glyph_5_a'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_5_a", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_DMG_PCT_HP_THRESHOLD
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

function modifierClass:RoshpitDmgPctHPThreshold(event)
	local hero = self:GetParent()
	if (hero:GetHealth()/hero:GetMaxHealth()) > (FLAMEWAKER_GLYPH_5_A_LOW_HP_THRESH/100) then
		return FLAMEWAKER_GLYPH_5_A_DAMAGE_CAP
	else
		return FLAMEWAKER_GLYPH_5_A_DAMAGE_CAP_LOW_HP
	end
end