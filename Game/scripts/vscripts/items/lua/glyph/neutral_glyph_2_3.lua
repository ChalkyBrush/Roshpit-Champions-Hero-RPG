require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_2_3 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_2_3
local itemClassName = 'item_rpc_neutral_glyph_2_3'

modifier_neutral_glyph_2_3 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_2_3
local modifierName = 'modifier_neutral_glyph_2_3'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_2_3", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end

function modifierClass:GetModifierBaseAttack_BonusDamage()
    local hero = self:GetParent()
    return hero:GetLevel() * ITEM_RPC_NEUTRAL_GLYPH_2_3_BASE_ATTACK_DMG_PER_LVL
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