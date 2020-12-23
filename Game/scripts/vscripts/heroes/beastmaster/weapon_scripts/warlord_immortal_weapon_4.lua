require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require("/heroes/beastmaster/warlord_constants")

item_rpc_warlord_immortal_weapon_4 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_warlord_immortal_weapon_4
local itemClassName = 'item_rpc_warlord_immortal_weapon_4'

modifier_warlord_immortal_weapon_4 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_warlord_immortal_weapon_4
local modifierName = 'modifier_warlord_immortal_weapon_4'
LinkLuaModifier(modifierName, "heroes/beastmaster/weapon_scripts/warlord_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "warlord"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Warlord Immortal Weapon 4'
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
    Weapons:SetLegendWeaponProperty2(self, "movespeed", 2)
end
-- WEAPON MODIFIER

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_E_FLAT_CD_MOD
    })
end

function modifierClass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return funcs
end

function modifierClass:GetModifierTurnRate_Percentage()
	return 5000
end

function modifierClass:GetRoshpitEFlatCdModifier()
    return - WARLORD_IMMORTAL_WEAPON_4_E_CD_REDUCTION
end


function modifierClass:IsHidden()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end
function modifierClass:IsBuff()
    return true
end