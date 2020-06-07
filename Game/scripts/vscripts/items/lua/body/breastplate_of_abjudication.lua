require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_breastplate_of_abjudication = class(BaseBody, nil, BaseBody)
modifier_breastplate_of_abjudication = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_breastplate_of_abjudication
local itemClassName = 'item_rpc_breastplate_of_abjudication'

local modifierClass = modifier_breastplate_of_abjudication
local modifierName = 'modifier_breastplate_of_abjudication'
LinkLuaModifier(modifierName, "items/lua/body/breastplate_of_abjudication", LUA_MODIFIER_MOTION_NONE)

modifier_abjudication_in_aura_range = class(npc_base_modifier, nil, npc_base_modifier)
local aura_debuff_class = modifier_abjudication_in_aura_range
LinkLuaModifier("modifier_abjudication_in_aura_range", "items/lua/body/breastplate_of_abjudication", LUA_MODIFIER_MOTION_NONE)

modifier_abjudication_base_effect_armor = class(npc_base_modifier, nil, npc_base_modifier)
local base_modifier_class = modifier_abjudication_base_effect_armor
LinkLuaModifier("modifier_abjudication_base_effect_armor", "items/lua/body/breastplate_of_abjudication", LUA_MODIFIER_MOTION_NONE)

modifier_abjudication_ruby_armor_pierce = class(npc_base_modifier, nil, npc_base_modifier)
local base_modifier_class = modifier_abjudication_ruby_armor_pierce
LinkLuaModifier("modifier_abjudication_ruby_armor_pierce", "items/lua/body/breastplate_of_abjudication", LUA_MODIFIER_MOTION_NONE)

modifier_abjudication_amethyst_magic_armor = class(npc_base_modifier, nil, npc_base_modifier)
local base_modifier_class = modifier_abjudication_amethyst_magic_armor
LinkLuaModifier("modifier_abjudication_amethyst_magic_armor", "items/lua/body/breastplate_of_abjudication", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Cloak of Isolation'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_breastplate_of_abjudication"
    self:SetSpecialValue("breastplate_of_abjudication", "#a26aa3")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 1.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0.5)
end

------------
--MODIFIER--
------------

function modifierClass:IsHidden()
	return true
end

function modifierClass:IsAura()
    return true
end

function modifierClass:IsAuraActiveOnDeath()
    return false
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetAuraRadius()
    return 2000
end

function modifierClass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifierClass:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function modifierClass:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifierClass:GetModifierAura()
    return "modifier_abjudication_in_aura_range"
end

function modifierClass:OnCreated()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	ability.armor_bonus = 0
	ability.armor_pierce_bonus = 0
	ability.magic_armor_bonus = 0
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_STRENGTH_PCT_BONUS,
        MODIFIER_ROSHPIT_AGILITY_PCT_BONUS,
        MODIFIER_ROSHPIT_INTELLIGENCE_PCT_BONUS,
        MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS,
        MODIFIER_ROSHPIT_EVENT_FINAL_TAKE_DAMAGE
    })
    self:GetParent():SetStatsForLevel()
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetParent():SetStatsForLevel()
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START
    }
    return funcs
end

function modifierClass:OnAttackStart(event)
	local hero = self:GetCaster().hero
	local ability = self:GetAbility()
	local attacker = event.attacker
	local target = event.target
	local parent = self:GetParent()
    if not self:ParentIsAttacker(event) then
        return
    end
    if ability:GetGemValue("ruby") > 0 then
	    local heroArmorPierce = hero:GetRoshpitArmorPierce()
	    if hero:HasModifier("modifier_abjudication_ruby_armor_pierce") then
	    	heroArmorPierce = heroArmorPierce - ability.armor_pierce_bonus
	    end
	    if target:GetRoshpitArmor() > heroArmorPierce then
	    	local armor_pierce_bonus = (target:GetRoshpitArmor() - heroArmorPierce)*(ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_STAT_PCT/100)
	    	if armor_pierce_bonus > ability.armor_pierce_bonus then
	    		ability.armor_pierce_bonus = armor_pierce_bonus
	    		local duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_RUBY)
	    		hero:AddNewModifier(hero, ability, "modifier_abjudication_ruby_armor_pierce", {duration = duration})
	    	end
	    end
    end
end

function modifierClass:GetRoshpitStrengthPctBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitAgilityPctBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitIntelligencePctBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitSpiritPctBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_SAPPHIRE)
end

function modifierClass:RoshpitEventFinalTakeDamage(event)
	local ability = self:GetAbility()
	if event.damageType == DAMAGE_TYPE_MAGICAL or event.damageType == DAMAGE_TYPE_PURE then
		local attacker = event.attacker
		local hero = event.victim
		if ability:GetGemValue("amethyst") > 0 then
		    local heroMagicArmor = hero:GetRoshpitMagicArmor()
		    if hero:HasModifier("modifier_abjudication_amethyst_magic_armor") then
		    	heroMagicArmor = heroMagicArmor - ability.magic_armor_bonus
		    end
		    if attacker:GetRoshpitSpellPierce() > heroMagicArmor then
		    	local magic_armor_bonus = (attacker:GetRoshpitSpellPierce() - heroMagicArmor)*(ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_STAT_PCT/100)
		    	if magic_armor_bonus > ability.magic_armor_bonus then
		    		ability.magic_armor_bonus = magic_armor_bonus
		    		local duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_AMETHYST)
		    		hero:AddNewModifier(hero, ability, "modifier_abjudication_amethyst_magic_armor", {duration = duration})
		    	end
		    end
		end
	end
	return event.damage
end

-- AURA DEBUFF

function aura_debuff_class:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START
    }
    return funcs
end

function aura_debuff_class:IsHidden()
	return true
end

function aura_debuff_class:RemoveOnDeath()
	return true
end

function aura_debuff_class:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function aura_debuff_class:OnAttackStart(event)
	local hero = self:GetCaster().hero
	local ability = self:GetAbility()
	local attacker = event.attacker
	local target = event.target
	local parent = self:GetParent()
    if not self:ParentIsAttacker(event) then
        return
    end
    if target ~= hero then
    	return false
    end
    local heroArmor = hero:GetRoshpitArmor()
    if hero:HasModifier("modifier_abjudication_base_effect_armor") then
    	heroArmor = heroArmor - ability.armor_bonus
    end
    if attacker:GetRoshpitArmorPierce() > heroArmor then
    	local armor_bonus = (attacker:GetRoshpitArmorPierce() - heroArmor)*(ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_STAT_PCT/100)
    	if armor_bonus > ability.armor_bonus then
    		ability.armor_bonus = armor_bonus
    		local duration = ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BREASTPLATE_OF_ABJUDICATION_GEM_EMERALD)
    		hero:AddNewModifier(hero, ability, "modifier_abjudication_base_effect_armor", {duration = duration})
    	end
    end
end

-- BASE EFFECT MODIFIER

function modifier_abjudication_base_effect_armor:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ MODIFIER_ROSHPIT_ARMOR_BONUS })
end

function modifier_abjudication_base_effect_armor:OnDestroy()
	local ability = self:GetAbility()
	ability.armor_bonus = 0
end

function modifier_abjudication_base_effect_armor:GetRoshpitArmorBonus()
	local ability = self:GetAbility()
	return ability.armor_bonus
end

-- RUBY EFFECT

function modifier_abjudication_ruby_armor_pierce:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS })
end

function modifier_abjudication_ruby_armor_pierce:OnDestroy()
	local ability = self:GetAbility()
	ability.armor_pierce_bonus = 0
end

function modifier_abjudication_ruby_armor_pierce:GetRoshpitArmorPierceBonus()
	local ability = self:GetAbility()
	return ability.armor_pierce_bonus
end

-- AMETHYST EFFECT

function modifier_abjudication_amethyst_magic_armor:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS })
end

function modifier_abjudication_amethyst_magic_armor:OnDestroy()
	local ability = self:GetAbility()
	ability.magic_armor_bonus = 0
end

function modifier_abjudication_amethyst_magic_armor:GetRoshpitMagicArmorBonus()
	local ability = self:GetAbility()
	return ability.magic_armor_bonus
end
