require('items/lua/gloves/base_glove')
require('npc_abilities/base_modifier')

item_rpc_power_ranger_gloves = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_power_ranger_gloves
local itemClassName = 'item_rpc_power_ranger_gloves'

modifier_power_ranger_gloves = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_power_ranger_gloves
local modifierName = 'modifier_power_ranger_gloves'
LinkLuaModifier(modifierName, "items/lua/gloves/power_ranger_gloves", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Power Ranger Gloves'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_power_ranger_gloves"
    self:SetSpecialValue("power_ranger_gloves", "#999999")
end

function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.25)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "armor_pierce", 1.5)
	else
	    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "spell_pierce", 1.5)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end

------------
--MODIFIER--
------------
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
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG,
		MODIFIER_ROSHPIT_STRENGTH_BONUS,
		MODIFIER_ROSHPIT_AGILITY_BONUS,
		MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
		MODIFIER_ROSHPIT_SPIRIT_BONUS,
		MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS		
    })

end

function modifierClass:GetRoshpitMasterBaseDMG()
	local hero = self:GetParent()
	local pierce = hero:GetRoshpitArmorPierce() + hero:GetRoshpitSpellPierce()
	local cap = ITEM_RPC_POWER_RANGER_DMG_CAP + hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_POWER_RANGER_GLOVES_GEM_EMERALD)
	local scale = ITEM_RPC_POWER_RANGER_DMG_PCT + hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_POWER_RANGER_GLOVES_GEM_RUBY)
	local bonus = math.min(scale * pierce, cap)
	return bonus
end

function modifierClass:GetRoshpitStrengthBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_POWER_RANGER_GLOVES_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitAgilityBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_POWER_RANGER_GLOVES_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitIntelligenceBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_POWER_RANGER_GLOVES_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitSpiritBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_POWER_RANGER_GLOVES_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_POWER_RANGER_GLOVES_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_POWER_RANGER_GLOVES_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_POWER_RANGER_GLOVES_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_POWER_RANGER_GLOVES_GEM_AMETHYST) / 100
end
