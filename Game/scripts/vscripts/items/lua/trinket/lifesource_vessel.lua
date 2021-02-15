require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_lifesource_vessel = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_lifesource_vessel
local itemClassName = 'item_rpc_lifesource_vessel'

modifier_lifesource_vessel = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_lifesource_vessel
local modifierName = 'modifier_lifesource_vessel'
LinkLuaModifier(modifierName, "/items/lua/trinket/lifesource_vessel", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Lifesource Vessel'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_lifesource_vessel"
    self:SetSpecialValue("lifesource_vessel", "#FFE884")
end

function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "max_health", 2)
end

function itemClass:RollProperty3(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.5) 
end

function itemClass:RollProperty4(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.5) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end

-- BASE MODIIFER 

function modifierClass:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
	    MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS,
		MODIFIER_ROSHPIT_MASTER_HEALTH_REGEN,
        MODIFIER_ROSHPIT_STRENGTH_BONUS,
		MODIFIER_ROSHPIT_AGILITY_BONUS,
		MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
		MODIFIER_ROSHPIT_SPIRIT_BONUS,
		MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
	self:StartIntervalThink(ITEM_RPC_LIFESOURCE_VESSEL_RUBY_HEAL_INTERVAL)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	   return
	end
	local hero = self:GetParent()
	if self:GetAbility():GetGemValue("ruby") > 0 then
	    local heal = hero:GetMaxHealth() * hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_LIFESOURCE_VESSEL_GEM_RUBY) / 100
	    Filters:ApplyHeal(hero, hero, heal, true, true)
	end
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetFlatHealthBonus()
    local hero = self:GetParent()
	local attr = hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit()
	local bonus = attr * ITEM_RPC_LIFESOURCE_VESSEL_MAX_HEALTH_PER_ATTRIBUTE
	return bonus
end


function modifierClass:GetRoshpitMasterHealthRegen()
	local scale = self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_LIFESOURCE_VESSEL_GEM_EMERALD)
	local hero = self:GetParent()
	local attr = hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit()
	return scale * attr
end

function modifierClass:GetRoshpitStrengthBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LIFESOURCE_VESSEL_GEM_AMETHYST)
end

function modifierClass:GetRoshpitAgilityBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LIFESOURCE_VESSEL_GEM_AMETHYST)
end

function modifierClass:GetRoshpitIntelligenceBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LIFESOURCE_VESSEL_GEM_AMETHYST)
end

function modifierClass:GetRoshpitSpiritBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LIFESOURCE_VESSEL_GEM_AMETHYST)
end

function modifierClass:GetRoshpitMasterGreenDMG()
    local hero = self:GetParent()
    local scale = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_LIFESOURCE_VESSEL_GEM_SAPPHIRE)
	local hp_perc = hero:GetHealthPercent()
	local perc_covert = math.floor(hp_perc / 5)
    return perc_covert * scale
end
