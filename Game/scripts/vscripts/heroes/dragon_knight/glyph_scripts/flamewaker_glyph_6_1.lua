require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_6_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_6_1
local itemClassName = 'item_rpc_flamewaker_glyph_6_1'

modifier_flamewaker_glyph_6_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_6_1
local modifierName = 'modifier_flamewaker_glyph_6_1'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_6_1", LUA_MODIFIER_MOTION_NONE)

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
