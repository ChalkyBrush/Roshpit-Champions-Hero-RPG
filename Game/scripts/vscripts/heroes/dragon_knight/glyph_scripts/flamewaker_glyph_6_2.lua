require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_6_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_6_2
local itemClassName = 'item_rpc_flamewaker_glyph_6_2'

modifier_flamewaker_glyph_6_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_6_2
local modifierName = 'modifier_flamewaker_glyph_6_2'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_6_2", LUA_MODIFIER_MOTION_NONE)

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
	local r_ability = hero:GetAbilityByIndex(DOTA_R_SLOT)
	local position = r_ability:GetCursorPosition()
	if position:Length2D() == 0 then
		position = hero:GetAbsOrigin()
	end
	local q_ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)

	for i = 1, 4, 1 do
		local cast_position = position + WallPhysics:rotateVector(hero:GetForwardVector(), 2*math.pi*i/4)*q_ability:GetAOERadius()
		print(cast_position)
		q_ability.cast_position_override = cast_position
		print("CASTING?")
		q_ability:OnSpellStart()
	end
end