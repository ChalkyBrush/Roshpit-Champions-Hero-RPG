require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/obsidian_destroyer/epoch_constants')

item_rpc_epoch_glyph_5_a = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_epoch_glyph_5_a
local itemClassName = 'item_rpc_epoch_glyph_5_a'

modifier_epoch_glyph_5_a = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_glyph_5_a
local modifierName = 'modifier_epoch_glyph_5_a'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/glyph_scripts/epoch_glyph_5_a", LUA_MODIFIER_MOTION_NONE)

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

    })
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