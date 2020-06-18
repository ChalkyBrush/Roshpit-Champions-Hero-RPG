require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/obsidian_destroyer/epoch_constants')

item_rpc_epoch_glyph_5_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_epoch_glyph_5_1
local itemClassName = 'item_rpc_epoch_glyph_5_1'

modifier_epoch_glyph_5_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_glyph_5_1
local modifierName = 'modifier_epoch_glyph_5_1'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/glyph_scripts/epoch_glyph_5_1", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS
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

function modifierClass:GetFlatHealthBonus()
    local caster = self:GetParent()
    return caster:GetIntellect()*EPOCH_GLYPH_5_1_MAX_HEALTH_PER_INT
end
