require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_2_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_2_1
local itemClassName = 'item_rpc_solunia_glyph_2_1'

modifier_solunia_glyph_2_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_2_1
local modifierName = 'modifier_solunia_glyph_2_1'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_2_1", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY 
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

function modifierClass:OnCastEAbility()
    local hero = self:GetParent()
    local e_ability = hero:GetAbilityByIndex(DOTA_E_SLOT)
    local position = e_ability:GetCursorPosition()
    position = e_ability:GetActualCastPosition(position)
    local q_ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
    for i = 0, SOLUNIA_GLYPH_2_1_BOMB_COUNT - 1, 1 do
        Timers:CreateTimer(i*0.15, function()
            q_ability:Glyph2_1(position)
        end)
    end
end

