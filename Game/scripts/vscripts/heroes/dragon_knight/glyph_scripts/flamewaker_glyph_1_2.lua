require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_1_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_1_2
local itemClassName = 'item_rpc_flamewaker_glyph_1_2'

modifier_flamewaker_glyph_1_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_1_2
local modifierName = 'modifier_flamewaker_glyph_1_2'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_1_2", LUA_MODIFIER_MOTION_NONE)

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
        MODIFIER_ROSHPIT_EVENT_ATTACK_LAND 
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

function modifierClass:RoshpitAttackLand(event)
	local hero = event.attacker
	local w_ability = hero:GetAbilityByIndex(DOTA_W_SLOT)
	if w_ability:GetAbilityName() == "flamewaker_dragon_breath" then
        w_ability.w_2_level = hero:GetRuneValue("w", 2)
		w_ability:FireProjectile(hero:GetForwardVector())
	elseif w_ability:GetAbilityName() == "flamewaker_fireborne" then
		w_ability:FireborneProjectile(hero, w_ability, 1200, hero:GetForwardVector(), 100)
	end
end
