require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_7_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_7_2
local itemClassName = 'item_rpc_solunia_glyph_7_2'

modifier_solunia_glyph_7_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_7_2
local modifierName = 'modifier_solunia_glyph_7_2'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_7_2", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY 
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

function modifierClass:OnCastRAbility()
    local hero = self:GetParent()
    hero:GetAbilityByIndex(DOTA_W_SLOT):Glyph7_2()
end
