require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_gold_plate_of_leon = class(BaseBody, nil, BaseBody)
modifier_gold_plate_of_leon = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_gold_plate_of_leon
local itemClassName = 'item_rpc_gold_plate_of_leon'

local modifierClass = modifier_gold_plate_of_leon
local modifierName = 'modifier_gold_plate_of_leon'
LinkLuaModifier(modifierName, "items/lua/body/gold_plate_of_leon", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_gold_plate_of_leon"
    self:SetSpecialValue("gold_plate_of_leon", "#E6E617")
end
function itemClass:RollProperty2(item_level)
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, item_slot, 2, item_level, attr_roll, 2)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0)
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
        MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS,
        MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })
    self:StartIntervalThink(0.5)
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

function modifierClass:GetRoshpitStrengthPctBonus()
	local hero = self:GetParent()
	if hero:GetRoshpitPrimaryAttribute() == ROSHPIT_ATTRIBUTE_STRENGTH then
		return ITEM_RPC_GOLD_PLATE_OF_LEON_PRIMARY_ATTRIBUTE_INCREASE
	else
		return 0
	end
end

function modifierClass:GetRoshpitAgilityPctBonus()
	local hero = self:GetParent()
	if hero:GetRoshpitPrimaryAttribute() == ROSHPIT_ATTRIBUTE_AGILITY then
		return ITEM_RPC_GOLD_PLATE_OF_LEON_PRIMARY_ATTRIBUTE_INCREASE
	else
		return 0
	end
end

function modifierClass:GetRoshpitIntelligencePctBonus()
	local hero = self:GetParent()
	if hero:GetRoshpitPrimaryAttribute() == ROSHPIT_ATTRIBUTE_INTELLIGENCE then
		return ITEM_RPC_GOLD_PLATE_OF_LEON_PRIMARY_ATTRIBUTE_INCREASE
	else
		return 0
	end
end

function modifierClass:GetRoshpitSpiritPctBonus()
	local hero = self:GetParent()
	local total_spirit = 0
	if hero:GetRoshpitPrimaryAttribute() == ROSHPIT_ATTRIBUTE_SPIRIT then
		total_spirit = total_spirit + ITEM_RPC_GOLD_PLATE_OF_LEON_PRIMARY_ATTRIBUTE_INCREASE
	end
	if self:GetAbility():GetGemValue("amethyst") > 0 then
		total_spirit = total_spirit + self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_AMETHYST)
	end
	return total_spirit
end

function modifierClass:GetRoshpitMasterBaseDMG()
	local hero = self:GetParent()
	if self:GetAbility():GetGemValue("sapphire") > 0 then
		return Filters:GetPrimaryAttributeMultiple(hero, self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_SAPPHIRE))
	else
		return 0
	end
end

function modifierClass:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetParent():SetStatsForLevel()
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetParent():SetStatsForLevel()
end
