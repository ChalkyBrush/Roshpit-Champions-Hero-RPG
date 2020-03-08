require('items/lua/glyph/base')
require('npc_abilities/base_modifier')

item_rpc_chernobog_glyph_1_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_1_1
local itemClassName = 'item_rpc_chernobog_glyph_1_1'

modifier_chernobog_glyph_1_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_1_1
local modifierName = 'modifier_chernobog_glyph_1_1'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyphs/chernobog_glyph_1_1", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_EVENT_ON_DEATH,
    }

    return funcs
end

function modifierClass:OnDeath(event)
    local  hero = self:GetParent()
    if IsServer() and event.attacker == self:GetParent() then
        hero:GiveMana(hero:GetMaxMana() * CHERNOBOG_GLYPH_1_1_MAX_MANA_RESTORE_ON_KILL)
    end
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