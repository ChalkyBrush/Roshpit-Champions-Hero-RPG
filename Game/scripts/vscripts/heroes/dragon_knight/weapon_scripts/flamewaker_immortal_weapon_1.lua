require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_flamewaker_immortal_weapon_1 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_flamewaker_immortal_weapon_1
local itemClassName = 'item_rpc_flamewaker_immortal_weapon_1'

modifier_flamewaker_immortal_weapon_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_immortal_weapon_1
local modifierName = 'modifier_flamewaker_immortal_weapon_1'
LinkLuaModifier(modifierName, "heroes/dragon_knight/weapon_scripts/flamewaker_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "flamewaker"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Flamewaker Immortal Weapon 1'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_1"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon", "#E06647", 1, "#property_"..self:RequiredHero().."_immortal_weapon_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "strength", 2)
end

-- WEAPON MODIFIER
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
	local target = event.victim
	local hero = self:GetParent()
	local proc = Filters:GetProc(hero, FLAMEWAKER_IMMORTAL_WEAPON_1_PROC_CHANCE)
	if proc then
		local q_ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
		local cast_position = target:GetAbsOrigin()
		q_ability.cast_position_override = cast_position
		q_ability:OnSpellStart()
	end
end