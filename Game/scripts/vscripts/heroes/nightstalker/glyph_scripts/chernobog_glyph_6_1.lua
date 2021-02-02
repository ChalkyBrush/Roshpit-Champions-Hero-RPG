require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_glyph_6_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_6_1
local itemClassName = 'item_rpc_chernobog_glyph_6_1'

modifier_chernobog_glyph_6_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_6_1
local modifierName = 'modifier_chernobog_glyph_6_1'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyph_scripts/chernobog_glyph_6_1", LUA_MODIFIER_MOTION_NONE)

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
