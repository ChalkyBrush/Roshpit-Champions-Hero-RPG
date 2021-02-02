require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_chernobog_immortal_weapon_1 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_chernobog_immortal_weapon_1
local itemClassName = 'item_rpc_chernobog_immortal_weapon_1'

modifier_chernobog_immortal_weapon_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_immortal_weapon_1
local modifierName = 'modifier_chernobog_immortal_weapon_1'
LinkLuaModifier(modifierName, "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "chernobog"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'chernobog Immortal Weapon 1'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_1"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon", "#796DC6", 1, "#property_"..self:RequiredHero().."_immortal_weapon_description")
end

function itemClass:RollProperty2(item_level)
	Weapons:SetLegendWeaponProperty2(self, "base_ability", 3)
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
