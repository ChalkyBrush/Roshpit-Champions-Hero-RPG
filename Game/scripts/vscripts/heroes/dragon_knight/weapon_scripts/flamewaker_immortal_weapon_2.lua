require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_flamewaker_immortal_weapon_2 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_flamewaker_immortal_weapon_2
local itemClassName = 'item_rpc_flamewaker_immortal_weapon_2'

modifier_flamewaker_immortal_weapon_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_immortal_weapon_2
local modifierName = 'modifier_flamewaker_immortal_weapon_2'
LinkLuaModifier(modifierName, "heroes/dragon_knight/weapon_scripts/flamewaker_immortal_weapon_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "flamewaker"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Flamewaker Immortal Weapon 2'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_2"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon2", "#E06647", 1, "#property_"..self:RequiredHero().."_immortal_weapon2_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "agility", 2)
end

-- WEAPON MODIFIER

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
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

function modifierClass:GetRoshpitMasterBaseDMG()
	local hero = self:GetParent()
	return hero:GetAgility()*FLAMEWAKER_IMMORTAL_WEAPON_2_ATTACK_DAMAGE_PER_AGILITY 
end