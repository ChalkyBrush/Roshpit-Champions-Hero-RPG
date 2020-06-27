require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_legion_vestments = class(BaseBody, nil, BaseBody)
modifier_legion_vestments = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_legion_vestments
local itemClassName = 'item_rpc_legion_vestments'

local modifierClass = modifier_legion_vestments
local modifierName = 'modifier_legion_vestments'
LinkLuaModifier(modifierName, "items/lua/body/legion_vestments", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Gold Plate of Leon'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_legion_vestments"
    self:SetSpecialValue("legion_vestments", "#D45757")
end
function itemClass:RollProperty2(item_level)
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, item_slot, 2, item_level, attr_roll, 1.5)
end

function itemClass:RollProperty3(item_level)
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, item_slot, 3, item_level, attr_roll, 1.75)
end

function itemClass:RollProperty4(item_level)
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, item_slot, 4, item_level, attr_roll, 2)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end


------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_STRENGTH_PCT_BONUS,
        MODIFIER_ROSHPIT_AGILITY_PCT_BONUS,
        MODIFIER_ROSHPIT_INTELLIGENCE_PCT_BONUS,
        MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS
    })
end

function modifierClass:IsHidden()
    return false
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetRoshpitStrengthPctBonus()
	local hero = self:GetParent()
	local bonus = ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE
	local ability = self:GetAbility()
	if ability:GetGemValue("ruby") > 0 then
		bonus = bonus + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LEGION_VESTMENTS_GEM_RUBY)
	end
	return bonus
end

function modifierClass:GetRoshpitAgilityPctBonus()
	local hero = self:GetParent()
	local bonus = ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE
	local ability = self:GetAbility()
	if ability:GetGemValue("emerald") > 0 then
		bonus = bonus + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_LEGION_VESTMENTS_GEM_EMERALD)
	end
	return bonus
end

function modifierClass:GetRoshpitIntelligencePctBonus()
	local hero = self:GetParent()
	local bonus = ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		bonus = bonus + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_LEGION_VESTMENTS_GEM_SAPPHIRE)
	end
	return bonus
end

function modifierClass:GetRoshpitSpiritPctBonus()
	local hero = self:GetParent()
	local bonus = ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE
	local ability = self:GetAbility()
	if ability:GetGemValue("amethyst") > 0 then
		bonus = bonus + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LEGION_VESTMENTS_GEM_AMETHYST)
	end
	return bonus
end