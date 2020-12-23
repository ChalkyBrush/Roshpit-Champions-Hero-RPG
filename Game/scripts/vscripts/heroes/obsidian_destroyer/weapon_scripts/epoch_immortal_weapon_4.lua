require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require('heroes/obsidian_destroyer/epoch_constants')

item_rpc_epoch_immortal_weapon_4 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_epoch_immortal_weapon_4
local itemClassName = 'item_rpc_epoch_immortal_weapon_4'

modifier_epoch_immortal_weapon_4 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_immortal_weapon_4
local modifierName = 'modifier_epoch_immortal_weapon_4'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/weapon_scripts/epoch_immortal_weapon_4", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "epoch"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Epoch Immortal Weapon 4'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_4"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon4", "#6EB788", 1, "#property_"..self:RequiredHero().."_immortal_weapon4_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "max_mana", 3)
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
	
    })
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
        MODIFIER_PROPERTY_MAX_ATTACK_RANGE
    }
    return funcs
end

function modifierClass:IsPassive()
    return true
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

function modifierClass:GetModifierCastRangeBonusStacking()
    local castrange = -EPOCH_IMMORTAL_WEAPON_4_RANGE_REDUCTION
    return castrange
end


function modifierClass:GetModifierAttackRangeBonus()
    local range = -EPOCH_IMMORTAL_WEAPON_4_RANGE_REDUCTION	
	return range
end