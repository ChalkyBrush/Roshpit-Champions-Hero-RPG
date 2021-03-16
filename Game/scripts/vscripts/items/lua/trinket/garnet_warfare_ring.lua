require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_garnet_warfare_ring = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_garnet_warfare_ring
local itemClassName = 'item_rpc_garnet_warfare_ring'

modifier_garnet_warfare_ring = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_garnet_warfare_ring
local modifierName = 'modifier_garnet_warfare_ring'
LinkLuaModifier(modifierName, "/items/lua/trinket/garnet_warfare_ring", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Garnet Warfare Ring'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_garnet_warfare_ring"
    self:SetSpecialValue("garnet_warfare_ring", "#D62D2D")
end

function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "strength", 2)
end

function itemClass:RollProperty3(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.25) 
end

function itemClass:RollProperty4(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.25) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
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
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
		MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
		MODIFIER_ROSHPIT_STRENGTH_BONUS,
		MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })
	self:OnIntervalThink()
	self:StartIntervalThink(0.1)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	   return
	end
	local hero = self:GetParent()
	local bonus = hero:GetStrength() * ITEM_RPC_GARNET_WARFARE_RING_STR_TO_BAD 
	self:SetStackCount(bonus)
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetStackCount() / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetStackCount() / 100
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetStackCount() / 100
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetStackCount() / 100
end

function modifierClass:GetRoshpitStrengthBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_GARNET_WARFARE_RING_GEM_RUBY)
end

function modifierClass:GetRoshpitSpellPierceBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GARNET_WARFARE_RING_GEM_EMERALD)
end

function modifierClass:GetRoshpitArmorPierceBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GARNET_WARFARE_RING_GEM_EMERALD)
end

function modifierClass:GetRoshpitMasterGreenDMG()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GARNET_WARFARE_RING_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitMasterBaseDMG()
    local hero = self:GetParent()
	local attr = hero:GetStrength() + hero:GetSpirit()
	local scale = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GARNET_WARFARE_RING_GEM_AMETHYST)
	return scale * attr
end
