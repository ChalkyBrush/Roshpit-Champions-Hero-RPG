require('items/lua/glyph/base')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_1_3 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_1_3
local itemClassName = 'item_rpc_neutral_glyph_1_3'

modifier_neutral_glyph_1_3 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_1_3
local modifierName = 'modifier_neutral_glyph_1_3'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_1_3", LUA_MODIFIER_MOTION_NONE)

modifier_neutral_glyph_1_3_heal = class(npc_base_modifier, nil, npc_base_modifier)
local healModifierClass = modifier_neutral_glyph_1_3_heal
local healModifierName = 'modifier_neutral_glyph_1_3_heal'
LinkLuaModifier(healModifierName, "items/lua/glyph/neutral_glyph_1_3", LUA_MODIFIER_MOTION_NONE)

modifier_neutral_glyph_1_3_mana = class(npc_base_modifier, nil, npc_base_modifier)
local manaModifierClass = modifier_neutral_glyph_1_3_mana
local manaModifierName = 'modifier_neutral_glyph_1_3_mana'
LinkLuaModifier(manaModifierName, "items/lua/glyph/neutral_glyph_1_3", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end

------------
--MODIFIER--
------------

function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end

-----------------
--HEAL MODIFIER--
-----------------

function healModifierClass:OnCreated(table)
    self.healAmount = table.healAmount
    self:StartIntervalThink(ITEM_RPC_NEUTRAL_GLYPH_1_3_TICK_RATE)
end
function healModifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    local regen = self.healAmount * ITEM_RPC_NEUTRAL_GLYPH_1_3_HEAL_PER_HEAL / ITEM_RPC_NEUTRAL_GLYPH_1_3_DURATION * ITEM_RPC_NEUTRAL_GLYPH_1_3_TICK_RATE
	target:Heal(regen, target)
	PopupHealing(target, regen)
end

-----------------
--MANA MODIFIER--
-----------------

function manaModifierClass:OnCreated(table)
    self.manaAmount = table.manaAmount
    self:StartIntervalThink(ITEM_RPC_NEUTRAL_GLYPH_1_3_TICK_RATE)
end

function manaModifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end
    local target = self:GetParent()
    local regen = self.manaAmount * ITEM_RPC_NEUTRAL_GLYPH_1_3_HEAL_PER_HEAL / ITEM_RPC_NEUTRAL_GLYPH_1_3_DURATION * ITEM_RPC_NEUTRAL_GLYPH_1_3_TICK_RATE
	target:GiveMana(regen)
	PopupMana(target, regen)
end