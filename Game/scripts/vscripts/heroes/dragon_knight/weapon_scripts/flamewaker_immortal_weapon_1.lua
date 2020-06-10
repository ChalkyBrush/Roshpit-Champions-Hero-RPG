require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_flamewaker_immortal_weapon_1 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_flamewaker_immortal_weapon_1
local itemClassName = 'item_rpc_flamewaker_immortal_weapon_1'

modifier_flamewaker_immortal_weapon_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_immortal_weapon_1
local modifierName = 'modifier_flamewaker_immortal_weapon_1'
LinkLuaModifier(modifierName, "heroes/dragon_knight/weapon_scripts/flamewaker_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Flamewaker Immortal Weapon 1'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(maxFactor)
	Weapons:SetLegendWeaponProperty1(self, self:GetClassname(), "immortal_weapon_1", "#E06647", nil)	
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "strength", 2)
end

-- WEAPON MODIFIER

function modifierClass:IsHidden()
    return true
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCreated()
    print("LUA WEAPON EQUIPPED")
end