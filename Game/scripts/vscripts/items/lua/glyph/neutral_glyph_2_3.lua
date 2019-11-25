require('items/lua/glyph/base')
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

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_BASE_ABILITY_DMG_BONUS
    })
end

function modifierClass:GetRoshpitBaseAbilityDmgBonus()
    return ITEM_RPC_NEUTRAL_GLYPH_2_3_BASE_ABILITY_DMG
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