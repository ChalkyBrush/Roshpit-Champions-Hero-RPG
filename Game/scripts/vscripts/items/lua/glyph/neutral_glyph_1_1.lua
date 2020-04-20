require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

item_rpc_neutral_glyph_1_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_neutral_glyph_1_1
local itemClassName = 'item_rpc_neutral_glyph_1_1'

modifier_neutral_glyph_1_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neutral_glyph_1_1
local modifierName = 'modifier_neutral_glyph_1_1'
LinkLuaModifier(modifierName, "items/lua/glyph/neutral_glyph_1_1", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_BASE_ARMOR_BONUS
    })
end

function modifierClass:GetRoshpitBaseArmorBonus()
    local hero = self:GetParent()
    return hero:GetLevel() * ITEM_RPC_NEUTRAL_GLYPH_1_1_ARM_PER_LVL
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