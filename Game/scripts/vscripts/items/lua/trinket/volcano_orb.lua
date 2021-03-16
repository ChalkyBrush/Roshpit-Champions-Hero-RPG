require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_volcano_orb = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_volcano_orb
local itemClassName = 'item_rpc_volcano_orb'

modifier_volcano_orb = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_volcano_orb
local modifierName = 'modifier_volcano_orb'
LinkLuaModifier(modifierName, "/items/lua/trinket/volcano_orb", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Volcano Orb'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_volcano_orb"
    self:SetSpecialValue("volcano_orb", "#995050")
end

function itemClass:RollProperty2(item_level) 
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, attr_roll, 2)
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

function modifierClass:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
		MODIFIER_ROSHPIT_STRENGTH_BONUS,
		MODIFIER_ROSHPIT_AGILITY_BONUS,
		MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
		MODIFIER_ROSHPIT_SPIRIT_BONUS,
		MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_ITEM_DMG_BONUS,
		RPC_ELEMENT_FIRE,
    })
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetRoshpitSpellPierceBonus()
    local hero = self:GetParent()
	local attr = hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit()
	local scale = ITEM_RPC_VOLCANO_ORB_SPELL_PIERCE_PER_ATTR + hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_VOLCANO_ORB_GEM_RUBY)
	return attr * scale
end

function modifierClass:GetRoshpitStrengthBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOLCANO_ORB_GEM_EMERALD)
end

function modifierClass:GetRoshpitAgilityBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOLCANO_ORB_GEM_EMERALD)
end

function modifierClass:GetRoshpitIntelligenceBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOLCANO_ORB_GEM_EMERALD)
end

function modifierClass:GetRoshpitSpiritBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VOLCANO_ORB_GEM_EMERALD)
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VOLCANO_ORB_GEM_SAPPHIRE) / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VOLCANO_ORB_GEM_SAPPHIRE) / 100
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VOLCANO_ORB_GEM_SAPPHIRE) / 100
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VOLCANO_ORB_GEM_SAPPHIRE) / 100
end

function modifierClass:GetRoshpitElementalDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOLCANO_ORB_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitItemDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOLCANO_ORB_GEM_AMETHYST) / 100
end






