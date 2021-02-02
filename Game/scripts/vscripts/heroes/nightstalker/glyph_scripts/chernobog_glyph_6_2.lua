require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_glyph_6_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_6_2
local itemClassName = 'item_rpc_chernobog_glyph_6_2'

modifier_chernobog_glyph_6_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_6_2
local modifierName = 'modifier_chernobog_glyph_6_2'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyph_scripts/chernobog_glyph_6_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end


modifier_chernobog_glyph_6_2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_glyph_6_2_effect", "heroes/nightstalker/glyph_scripts/chernobog_glyph_6_2", LUA_MODIFIER_MOTION_NONE)

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
