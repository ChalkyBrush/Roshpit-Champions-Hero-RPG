require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_5_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_5_1
local itemClassName = 'item_rpc_solunia_glyph_5_1'

modifier_solunia_glyph_5_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_5_1
local modifierName = 'modifier_solunia_glyph_5_1'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_5_1", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_Q_BASE_DMG_FLAT
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

function modifierClass:GetRoshpitQBaseDmgFlat()
    local hero = self:GetParent()
    return OverflowProtectedGetAverageTrueAttackDamage(hero)*(SOLUNIA_GLYPH_5_1_ATK_PWR_TO_Q/100)
end