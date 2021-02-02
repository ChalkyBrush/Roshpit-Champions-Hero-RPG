require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_immortal_weapon_2 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_chernobog_immortal_weapon_2
local itemClassName = 'item_rpc_chernobog_immortal_weapon_2'

modifier_chernobog_immortal_weapon_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_immortal_weapon_2
local modifierName = 'modifier_chernobog_immortal_weapon_2'
LinkLuaModifier(modifierName, "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_immortal_weapon_2_phys_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_immortal_weapon_2_phys_buff", "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_immortal_weapon_2_magic_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_immortal_weapon_2_magic_buff", "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "chernobog"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Chernobog Immortal Weapon 2'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_2"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon2", "#796DC6", 1, "#property_"..self:RequiredHero().."_immortal_weapon2_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "element_demon", 2)
end

-- WEAPON MODIFIER

function modifierClass:IsHidden()
	return true
end

function modifierClass:IsDebuff()
	return false
end

function modifierClass:RemoveOnDeath()
	return false
end

function modifier_chernobog_immortal_weapon_2_phys_buff:IsHidden()
	return false
end

function modifier_chernobog_immortal_weapon_2_phys_buff:IsDebuff()
	return false
end

function modifier_chernobog_immortal_weapon_2_phys_buff:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_immortal_weapon_2_magic_buff:IsHidden()
	return false
end

function modifier_chernobog_immortal_weapon_2_magic_buff:IsDebuff()
	return false
end

function modifier_chernobog_immortal_weapon_2_magic_buff:OnCreated()
	if not IsServer() then
		return
	end
end
