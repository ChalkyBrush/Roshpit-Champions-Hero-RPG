require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_flamewaker_immortal_weapon_4 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_flamewaker_immortal_weapon_4
local itemClassName = 'item_rpc_flamewaker_immortal_weapon_4'

modifier_flamewaker_immortal_weapon_4 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_immortal_weapon_4
local modifierName = 'modifier_flamewaker_immortal_weapon_4'
LinkLuaModifier(modifierName, "heroes/dragon_knight/weapon_scripts/flamewaker_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "flamewaker"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Flamewaker Immortal Weapon 4'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_4"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon4", "#E06647", 1, "#property_"..self:RequiredHero().."_immortal_weapon4_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "intelligence", 2)
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
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
