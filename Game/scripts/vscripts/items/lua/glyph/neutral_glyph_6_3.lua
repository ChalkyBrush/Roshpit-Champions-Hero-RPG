require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_6_3 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_6_3
local itemClassName = 'item_rpc_neutral_glyph_6_3'

modifier_neutral_glyph_6_3 = {}
local modifierClass = modifier_neutral_glyph_6_3
local modifierName = 'modifier_neutral_glyph_6_3'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_6_3", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end

function itemClass:GetStackCount()
    return ITEM_RPC_NEUTRAL_GLYPH_6_3_BASE_ATTACK_DMG_BONUS_PCT
end

------------
--MODIFIER--
------------

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifierClass:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount() * 1
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