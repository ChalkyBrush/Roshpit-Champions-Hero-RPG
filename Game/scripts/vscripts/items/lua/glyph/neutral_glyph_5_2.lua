require('items/lua/glyph/base')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_5_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_5_2
local itemClassName = 'item_rpc_neutral_glyph_5_2'

modifier_neutral_glyph_5_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_5_2
local modifierName = 'modifier_neutral_glyph_5_2'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_5_2", LUA_MODIFIER_MOTION_NONE)

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
        DAMAGE_TYPE_MAGICAL
    })
end

function modifierClass:GetDamageReduction()
    return ITEM_RPC_NEUTRAL_GLYPH_5_1_MAG_RES
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