require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_chernobog_immortal_weapon_4 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_chernobog_immortal_weapon_4
local itemClassName = 'item_rpc_chernobog_immortal_weapon_4'

modifier_chernobog_immortal_weapon_4 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_immortal_weapon_4
local modifierName = 'modifier_chernobog_immortal_weapon_4'
LinkLuaModifier(modifierName, "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_immortal_weapon_4_conditional_silence = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_immortal_weapon_4_conditional_silence", "heroes/nightstalker/weapon_scripts/chernobog_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "chernobog"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Chernobog Immortal Weapon 4'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_4"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon4", "#796DC6", 1, "#property_"..self:RequiredHero().."_immortal_weapon4_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "base_ability", 2.5)
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

---------------------
--- WEAPON EFFECT ---
---------------------
function modifier_chernobog_immortal_weapon_4_conditional_silence:IsDebuff()
	return true
end

function modifier_chernobog_immortal_weapon_4_conditional_silence:IsHidden()
	return false
end

function modifier_chernobog_immortal_weapon_4_conditional_silence:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_immortal_weapon_4_conditional_silence:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
end
