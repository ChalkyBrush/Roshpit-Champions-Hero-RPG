require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_conquest_stone_falcon = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_conquest_stone_falcon
local itemClassName = 'item_rpc_conquest_stone_falcon'

modifier_conquest_stone_falcon = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_conquest_stone_falcon
local modifierName = 'modifier_conquest_stone_falcon'
LinkLuaModifier(modifierName, "/items/lua/trinket/conquest_stone_falcon", LUA_MODIFIER_MOTION_NONE)

modifier_conquest_stone_falcon_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_conquest_stone_falcon_shield", "/items/lua/trinket/conquest_stone_falcon", LUA_MODIFIER_MOTION_NONE)

modifier_conquest_stone_falcon_amethyst_cd = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_conquest_stone_falcon_amethyst_cd", "/items/lua/trinket/conquest_stone_falcon", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Conquest Stone Falcon'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_conquest_stone_falcon"
    self:SetSpecialValue("conquest_stone_falcon", "#A5B5A9")
end

function itemClass:RollProperty2(item_level) 
    local attr_rolls = {"armor", "armor_pierce", "spell_pierce", "magic_armor"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, attr_roll, 2)
end

function itemClass:RollProperty3(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.25) 
end

function itemClass:RollProperty4(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.75) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
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
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
    })
	self:StartIntervalThink(3)
end

function modifierClass:OnIntervalThink()
    if not IsServer() then
	    return
	end
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("emerald") > 0 then
	   local modifier = hero:FindModifierByName("modifier_conquest_stone_falcon_shield")
	   local maxstacks = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_EMERALD)
	   if not modifier then
	       modifier = hero:AddNewModifier(hero, ability, "modifier_conquest_stone_falcon_shield", {})
	   end
	   modifier:SetStackCount(math.min(modifier:GetStackCount() + 1, maxstacks))
    end
end

function modifierClass:OnDestroy()
    if not IsServer() then
	    return
	end
	if self:GetParent():HasModifier("modifier_conquest_stone_falcon_shield") then
	    self:GetParent():RemoveModifierByName("modifier_conquest_stone_falcon_shield")
	end
end

function modifierClass:GetRoshpitSpellPierceBonus()
	local hero = self:GetParent()
	return hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitArmorPierceBonus()
	local hero = self:GetParent()
	return hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_SAPPHIRE)
end

function modifier_conquest_stone_falcon_amethyst_cd:IsHidden()
    return false
end

function modifier_conquest_stone_falcon_amethyst_cd:IsDebuff()
    return true
end

function modifier_conquest_stone_falcon_amethyst_cd:IsPurgable()
    return false
end

function modifier_conquest_stone_falcon_shield:IsHidden()
    return false
end

function modifier_conquest_stone_falcon_shield:IsDebuff()
    return false
end

function modifier_conquest_stone_falcon_shield:IsPurgable()
    return false
end

function modifier_conquest_stone_falcon_shield:OnCreated()
    if not IsServer() then
	    return
	end
	self.pfx = ParticleManager:CreateParticle("particles/roshpit/items/skyforge_flurry_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:StartIntervalThink(0.1)
end

function modifier_conquest_stone_falcon_shield:OnIntervalThink()
    if not IsServer() then
	    return
	end
	if not (self:GetStackCount() > 0) then
	    self:Destroy()
	end
end

function modifier_conquest_stone_falcon_shield:OnDestroy()
    if not IsServer() then
	    return 
	end
	if self.pfx then
	    ParticleManager:DestroyParticle(self.pfx, true)
	end
end
