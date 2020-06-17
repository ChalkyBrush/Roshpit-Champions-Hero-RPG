require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_epoch_immortal_weapon_3 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_epoch_immortal_weapon_3
local itemClassName = 'item_rpc_epoch_immortal_weapon_3'

modifier_epoch_immortal_weapon_3 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_immortal_weapon_3
local modifierName = 'modifier_epoch_immortal_weapon_3'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/weapon_scripts/epoch_immortal_weapon_3", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "epoch"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Epoch Immortal Weapon 3'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_3"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon3", "#6EB788", 1, "#property_"..self:RequiredHero().."_immortal_weapon3_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "intelligence", 3)
end

-- WEAPON MODIFIER
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