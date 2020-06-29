require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_immortal_weapon_1 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_solunia_immortal_weapon_1
local itemClassName = 'item_rpc_solunia_immortal_weapon_1'

modifier_solunia_immortal_weapon_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_immortal_weapon_1
local modifierName = 'modifier_solunia_immortal_weapon_1'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/weapon_scripts/solunia_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_immortal_weapon_1_thales_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_immortal_weapon_1_thales_shield", "heroes/vengeful_spirit/weapon_scripts/solunia_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "solunia"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Solunia Immortal Weapon 1'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_1"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon", "#4286F4", 1, "#property_"..self:RequiredHero().."_immortal_weapon_description")
end

function itemClass:RollProperty2(item_level)
	local luck = RandomInt(1, 2)
	if luck == 1 then
		Weapons:SetLegendWeaponProperty2(self, "intelligence", 2)
	else
		Weapons:SetLegendWeaponProperty2(self, "agility", 2)
	end
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
  	self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end

function modifierClass:DeclareFunctions()
    local funcs = {

    }
    return funcs
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

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_STOP] = true,
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    if hero:IsStunned() then
        return false
    end
    self:ActivateShield()

    local cooldown = SOLUNIA_IMMORTAL_WEAPON_1_COOLDOWN
    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
    ability:StartCooldown(cooldown)
end

function modifierClass:ActivateShield()
    local ability = self:GetAbility()
    local hero = self:GetParent()
    hero:AddNewModifier(hero, ability, "modifier_solunia_immortal_weapon_1_thales_shield", {duration = SOLUNIA_IMMORTAL_WEAPON_1_DURATION})
    EmitSoundOn("Solunia.ImmortalWeapon1.Shield", hero)
    StartAnimation(hero, {duration = 0.25, activity = ACT_DOTA_VERSUS, rate = 5})
end

-- SHIELD MODIFIER

function modifier_solunia_immortal_weapon_1_thales_shield:IsHidden()
	return false
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetEffectName()
	return "particles/roshpit/solunia/immortal_weapon_1_shield.vpcf"
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetEffectAttachType()
	return "attach_origin"
end

function modifier_solunia_immortal_weapon_1_thales_shield:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION
    })
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetDamageReduction()
    return 1
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetPhysicalDamageReduction()
    return self:GetDamageReduction()
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetMagicalDamageReduction()
    return self:GetDamageReduction()  
end

function modifier_solunia_immortal_weapon_1_thales_shield:GetPureDamageReduction()
    return self:GetDamageReduction() 
end