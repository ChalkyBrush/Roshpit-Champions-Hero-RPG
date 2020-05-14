require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_baphomets_cursed_necklace = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_baphomets_cursed_necklace
local itemClassName = 'item_rpc_baphomets_cursed_necklace'

modifier_baphomets_cursed_necklace = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_baphomets_cursed_necklace
local modifierName = 'modifier_baphomets_cursed_necklace'
LinkLuaModifier(modifierName, "/items/lua/trinket/baphomets_cursed_necklace", LUA_MODIFIER_MOTION_NONE)

modifier_baphomets_cursed_necklace_ruin_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_baphomets_cursed_necklace_ruin_effect", "/items/lua/trinket/baphomets_cursed_necklace", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Neverlord Soul Ring'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_baphomets_cursed_necklace"
    self:SetSpecialValue("baphomets_cursed_necklace", "#A8273C")
end
function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "attack_damage", 1)  
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end
function modifierClass:OnCreated()
    self:SetSpecialTypes({
    	MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY,
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
    	MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCastRAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	hero:RemoveModifierByName("modifier_baphomets_cursed_necklace_ruin_effect")

	if ability:GetCooldownTimeRemaining() > 0 then
		return false
	end
    local cooldown = ITEM_RPC_BAPHOMETS_CURSED_NECKLACE_BASE_CD - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BAPHOMETS_CURSED_NECKLACE_GEM_EMERALD)
    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
    ability:StartCooldown(cooldown)

    hero:AddNewModifier(hero, ability, "modifier_baphomets_cursed_necklace_ruin_effect", {})
    hero:GetAbilityByIndex(DOTA_R_SLOT):EndCooldown()
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
	local hero = self:GetParent()
	hero:RemoveModifierByName("modifier_baphomets_cursed_necklace_ruin_effect")
end

function modifierClass:GetRoshpitMasterBaseDMG()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BAPHOMETS_CURSED_NECKLACE_GEM_RUBY)*hero:GetSumOfAllAttributes()
end

function modifierClass:OnAttackLanded()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local hero = self:GetParent()
	if ability:GetGemValue("sapphire") > 0 then
		local proc_chance = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BAPHOMETS_CURSED_NECKLACE_GEM_SAPPHIRE)
		local proc = Filters:GetProc(hero, proc_chance)
		if proc then
			hero:AddNewModifier(hero, ability, "modifier_baphomets_cursed_necklace_ruin_effect", {})
		end		
	end	
end

-- RUIN MODIFIER

function modifier_baphomets_cursed_necklace_ruin_effect:IsHidden()
	return false
end

function modifier_baphomets_cursed_necklace_ruin_effect:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({
    	MODIFIER_ROSHPIT_R_PCT_CHANNELTIME_MOD,
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
    local hero = self:GetParent()
    EmitSoundOn("RPCItems.BaphometsNecklace.Activate", hero)
end

function modifier_baphomets_cursed_necklace_ruin_effect:GetEffectName()
	return "particles/roshpit/items/baphomet_necklace_ruin_effect.vpcf"
end

function modifier_baphomets_cursed_necklace_ruin_effect:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_baphomets_cursed_necklace_ruin_effect:GetRoshpitRPctChanneltimeModifier()
    return - ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_PCT_CHANNELTIME_MOD
end

function modifier_baphomets_cursed_necklace_ruin_effect:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BAPHOMETS_CURSED_NECKLACE_GEM_AMETHYST)
end