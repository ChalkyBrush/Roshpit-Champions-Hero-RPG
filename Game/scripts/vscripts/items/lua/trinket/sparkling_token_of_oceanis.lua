require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_sparkling_token_of_oceanis = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_sparkling_token_of_oceanis
local itemClassName = 'item_rpc_sparkling_token_of_oceanis'

modifier_sparkling_token_of_oceanis = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_sparkling_token_of_oceanis
local modifierName = 'modifier_sparkling_token_of_oceanis'
LinkLuaModifier(modifierName, "/items/lua/trinket/sparkling_token_of_oceanis", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Sparkling Token of Ocreanis'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_sparkling_token_of_oceanis"
    self:SetSpecialValue("sparkling_token_of_oceanis", "#FFE884")
end

function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_elements", 2)
end

function itemClass:RollProperty3(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.5) 
end

function itemClass:RollProperty4(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.5) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.5)
end

-- BASE MODIIFER 

function modifierClass:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
		MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
		MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
		MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS,
		MODIFIER_ROSHPIT_FLAT_MANA_BONUS
    })
	self:OnIntervalThink()
	self:StartIntervalThink(ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_INTERVAL)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	   return
	end
	local hero = self:GetParent()
	local hp_regen = self:GetParent():GetMaxHealth() * ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_HEALTH_RESTORE / 100
	local mp_regen = self:GetParent():GetMaxMana() * ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_MANA_RESTORE/ 100
	Filters:ApplyHeal(hero, hero, hp_regen, true, true)
	hero:GiveMana(mp_regen)
	PopupMana(hero, mp_regen)
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetFlatHealthBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_RUBY1)
end

function modifierClass:GetFlatManaBonus()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_RUBY2)
end

function modifierClass:GetRoshpitSpellPierceBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitArmorPierceBonus()
	return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_SAPPHIRE)
end

function modifierClass:GetPhysicalDamageReduction()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_EMERALD) / 100
end

function modifierClass:GetMagicalDamageReduction()
    return self:GetParent().equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_AMETHYST) / 100
end


