require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_firelock_pendant = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_firelock_pendant
local itemClassName = 'item_rpc_firelock_pendant'

modifier_firelock_pendant = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_firelock_pendant
local modifierName = 'modifier_firelock_pendant'
LinkLuaModifier(modifierName, "/items/lua/trinket/firelock_pendant", LUA_MODIFIER_MOTION_NONE)

modifier_firelock_pendant_sapphire = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_firelock_pendant_sapphire", "/items/lua/trinket/firelock_pendant", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Firelock Pendant'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_firelock_pendant"
    self:SetSpecialValue("firelock_pendant", "#DE5957")
end

function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "strength", 2)
end

function itemClass:RollProperty3(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.5) 
end

function itemClass:RollProperty4(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.5) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.25)
end

-- BASE MODIIFER 
function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
		MODIFIER_ROSHPIT_STRENGTH_BONUS,
		MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_MASTER_AS,
		RPC_ELEMENT_FIRE,
    })
	self:StartIntervalThink(0.1)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	    return
	end
	local hero = self:GetParent()
	local aspd = hero:GetAttackSpeed() * 100
	if aspd < 300 and (self:GetAbility():GetGemValue("sapphire") > 0)then
	   local bonus = 300 - aspd
	   hero:AddNewModifier(hero, self:GetAbility(), "modifier_firelock_pendant_sapphire", {duration = 5}):SetStackCount(bonus)
	end
end

function modifierClass:GetRoshpitArmorPierceBonus()
    local hero = self:GetParent()
	local base_bonus = hero:GetStrength() * ITEM_RPC_FIRELOCK_PENDANT_STR_TO_ARMOR_PIERCE
	local add_bonus = hero:GetAgility() * hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_FIRELOCK_PENDANT_GEM_RUBY)
	return base_bonus + add_bonus
end

function modifierClass:GetRoshpitElementalDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_FIRELOCK_PENDANT_GEM_EMERALD) / 100
end

function modifierClass:GetRoshpitMasterAS()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FIRELOCK_PENDANT_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitStrengthBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FIRELOCK_PENDANT_GEM_AMETHYST)
end

function modifierClass:GetRoshpitAgilityBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FIRELOCK_PENDANT_GEM_AMETHYST)
end

function modifier_firelock_pendant_sapphire:IsDebuff()
    return false
end

function modifier_firelock_pendant_sapphire:IsHidden()
    return true
end

function modifier_firelock_pendant_sapphire:OnCreated()
    if not IsServer() then
	    return
	end
	self:SetSpecialTypes({MODIFIER_ROSHPIT_MASTER_AS})
end

function modifier_firelock_pendant_sapphire:GetRoshpitMasterAS()
    return self:GetStackCount()
end
