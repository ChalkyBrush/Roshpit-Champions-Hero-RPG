require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_3_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_3_2
local itemClassName = 'item_rpc_neutral_glyph_3_2'

modifier_neutral_glyph_3_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_3_2
local modifierName = 'modifier_neutral_glyph_3_2'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_3_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end

------------
--MODIFIER--
------------

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifierClass:GetModifierEvasion_Constant()
    return ITEM_RPC_NEUTRAL_GLYPH_3_2_EVASION
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