require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_4_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_4_2
local itemClassName = 'item_rpc_solunia_glyph_4_2'

modifier_solunia_glyph_4_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_4_2
local modifierName = 'modifier_solunia_glyph_4_2'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_4_2", LUA_MODIFIER_MOTION_NONE)

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

function modifierClass:MeteorShower()
    local hero = self:GetParent()

    local q_ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
    local position = hero:GetAbsOrigin() + RandomVector(RandomInt(0, SOLUNIA_GLYPH_4_2_RANGE))

    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, SOLUNIA_GLYPH_4_2_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        position = enemies[1]:GetAbsOrigin()
    end
    q_ability:Glyph2_1(position)
end