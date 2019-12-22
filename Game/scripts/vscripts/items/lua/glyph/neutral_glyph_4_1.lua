require('items/lua/glyph/base')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_4_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_4_1
local itemClassName = 'item_rpc_neutral_glyph_4_1'

modifier_neutral_glyph_4_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_4_1
local modifierName = 'modifier_neutral_glyph_4_1'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_4_1", LUA_MODIFIER_MOTION_NONE)

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
        RPC_ELEMENT_FIRE,
        RPC_ELEMENT_EARTH,
        RPC_ELEMENT_LIGHTNING,
        RPC_ELEMENT_POISON,
        RPC_ELEMENT_TIME,
        RPC_ELEMENT_HOLY,
        RPC_ELEMENT_COSMOS,
        RPC_ELEMENT_ICE,
        RPC_ELEMENT_ARCANE,
        RPC_ELEMENT_SHADOW,
        RPC_ELEMENT_WIND,
        RPC_ELEMENT_GHOST,
        RPC_ELEMENT_WATER,
        RPC_ELEMENT_DEMON,
        RPC_ELEMENT_NATURE,
        RPC_ELEMENT_UNDEAD,
        RPC_ELEMENT_DRAGON
    })
end

function modifierClass:GetRoshpitElementalDmgBonus()
    return ITEM_RPC_NEUTRAL_GLYPH_4_1_ELE_DMG
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