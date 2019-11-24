require('items/lua/glyph/base')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_3_3 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_3_3
local itemClassName = 'item_rpc_neutral_glyph_3_3'

modifier_neutral_glyph_3_3 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_3_3
local modifierName = 'modifier_neutral_glyph_3_3'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_3_3", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_E_FLAT_CD_RED
    })
end

function modifierClass:GetRoshpitFlatCdRed()
    return ITEM_RPC_NEUTRAL_GLYPH_3_3_E_CD_RED
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