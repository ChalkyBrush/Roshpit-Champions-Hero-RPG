require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_immortal_weapon_4 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_solunia_immortal_weapon_4
local itemClassName = 'item_rpc_solunia_immortal_weapon_4'

modifier_solunia_immortal_weapon_4 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_immortal_weapon_4
local modifierName = 'modifier_solunia_immortal_weapon_4'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/weapon_scripts/solunia_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "solunia"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Solunia Immortal Weapon 4'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_4"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon4", "#D64FD3", 1, "#property_"..self:RequiredHero().."_immortal_weapon4_description")
end

function itemClass:RollProperty2(item_level)
	Weapons:SetLegendWeaponProperty2(self, "attack_damage", 5)
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
end

function modifierClass:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:GetEffectName()
	return "particles/roshpit/solunia/solunia_weapon_4_loop.vpcf"
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end
