require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_arbor_dragonfly = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_arbor_dragonfly
local itemClassName = 'item_rpc_arbor_dragonfly'

modifier_arbor_dragonfly = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_arbor_dragonfly
local modifierName = 'modifier_arbor_dragonfly'
LinkLuaModifier(modifierName, "/items/lua/trinket/arbor_dragonfly", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Arbor Dragonfly'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_arbor_dragonfly"
    self:SetSpecialValue("arbor_dragonfly", "#995050")
end

function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 2)
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
function modifierClass:IsHidden()
    if self:GetStackCount() > 0 then
        return false
	end
	return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetTexture()
    return "rpc/arbor_dragonfly"
end

function modifierClass:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
		MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
		MODIFIER_ROSHPIT_ITEM_DMG_BONUS,
    })
	self:OnIntervalThink()
	self:StartIntervalThink(0.2)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	    return
	end
	local hero = self:GetParent()
	local modifiers = hero:FindAllModifiers()
	local count = 0
	if #modifiers > 0 then
	   for i = 1, #modifiers, 1 do
	       local modifier = modifiers[i]
		   if modifier:GetDuration() > 0 then
		      if (not (modifier.IsDebuff and modifier:IsDebuff() == true)) and (modifier.IsHidden and modifier:IsHidden() == false)then
		         count = count + 1
			  end
		   end
	   end
	end
	self:SetStackCount(math.min(5, count))
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetStackCount() * ITEM_RPC_ARBOR_DRAGONFLY_BAD_PER_STACK / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetStackCount() * ITEM_RPC_ARBOR_DRAGONFLY_BAD_PER_STACK / 100
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetStackCount() * ITEM_RPC_ARBOR_DRAGONFLY_BAD_PER_STACK / 100
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetStackCount() * ITEM_RPC_ARBOR_DRAGONFLY_BAD_PER_STACK / 100
end

function modifierClass:GetRoshpitItemDmgBonus()
    return self:GetStackCount() * ITEM_RPC_ARBOR_DRAGONFLY_BAD_PER_STACK / 100
end

function modifierClass:GetRoshpitSpellPierceBonus()
    local hero = self:GetParent()
	local bonus_per_stack = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ARBOR_DRAGONFLY_GEM_AMETHYST)
    return self:GetStackCount() * bonus_per_stack
end

function modifierClass:GetRoshpitArmorPierceBonus()
    local hero = self:GetParent()
	local bonus_per_stack = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ARBOR_DRAGONFLY_GEM_AMETHYST)
    return self:GetStackCount() * bonus_per_stack
end
