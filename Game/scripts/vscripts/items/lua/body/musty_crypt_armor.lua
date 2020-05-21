require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_musty_crypt_armor = class(BaseBody, nil, BaseBody)
local itemClass = item_rpc_musty_crypt_armor
local itemClassName = 'item_rpc_musty_crypt_armor'

modifier_musty_crypt_armor = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_musty_crypt_armor
local modifierName = 'modifier_musty_crypt_armor'
LinkLuaModifier(modifierName, "items/lua/body/musty_crypt_armor", LUA_MODIFIER_MOTION_NONE)

modifier_musty_crypt_skeleton_transform = class(npc_base_modifier, nil, npc_base_modifier)
local crypt_armor_skeleton_modifier = modifier_musty_crypt_skeleton_transform
LinkLuaModifier('modifier_musty_crypt_skeleton_transform', "items/lua/body/musty_crypt_armor", LUA_MODIFIER_MOTION_NONE)

modifier_musty_crypt_amethyst_debuff = class(npc_base_modifier, nil, npc_base_modifier)
local musty_crypt_amethyst_debuff = modifier_musty_crypt_amethyst_debuff
LinkLuaModifier('modifier_musty_crypt_amethyst_debuff', "items/lua/body/musty_crypt_armor", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Musty Crypt Armor'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_musty_crypt_armor"
    self:SetSpecialValue("musty_crypt_armor", "#74FCE1")
end
function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 6)
    if luck < 5 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_undead", 2)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end

function modifierClass:DeclareFunctions()
    local funcs = {
    }
    return funcs
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY
    })
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

function modifierClass:OnCastQAbility()
    self:TransformIntoSkeleton()
end

function modifierClass:OnDestroy(args)
	local hero = self:GetCaster().hero
	if hero then
    	hero:RemoveModifierByName("modifier_musty_crypt_skeleton_transform")
    end
end

function modifierClass:TransformIntoSkeleton()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local hero = self:GetParent()
	if hero:HasModifier("modifier_musty_crypt_skeleton_transform") then
		hero:RemoveModifierByName("modifier_musty_crypt_skeleton_transform")
	else
		hero:AddNewModifier(caster, ability, "modifier_musty_crypt_skeleton_transform", {duration = ITEM_RPC_MUSTY_CRYPT_ARMOR_DURATION})
	end
end

function crypt_armor_skeleton_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MAX_ATTACK_RANGE,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function crypt_armor_skeleton_modifier:OnCreated()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    local healthPercentFreeze = hero:GetHealth() / hero:GetMaxHealth()
    CustomAttributes:ApplyStatBonusesToHero(hero)
    CustomAbilities:QuickAttachParticle("particles/roshpit/items/musty_crypt_transform.vpcf", hero, 3)
	Timers:CreateTimer(0.03, function()
		if hero:IsAlive() then
			hero:SetHealth(math.max(hero:GetMaxHealth() * healthPercentFreeze, 1))
		end
	end)
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_AS,
        MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG,
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
    if self:GetAbility():GetGemValue("emerald") > 0 then
    	self:StartIntervalThink(ITEM_RPC_MUSTY_CRYPT_ARMOR_EMERALD_INTERVAL)
    end
end

function crypt_armor_skeleton_modifier:OnIntervalThink()
	local heal = self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_EMERALD1)
	local hero = self:GetParent()
	hero:SetHealth(math.min(hero:GetMaxHealth(), hero:GetHealth() + heal))
end

function crypt_armor_skeleton_modifier:OnDestroy()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    local healthPercentFreeze = hero:GetHealth() / hero:GetMaxHealth()
    CustomAttributes:ApplyStatBonusesToHero(hero)
    CustomAbilities:QuickAttachParticle("particles/roshpit/items/musty_crypt_transform.vpcf", self:GetParent(), 3)
	Timers:CreateTimer(0.03, function()
		if hero:IsAlive() then
			hero:SetHealth(math.max(hero:GetMaxHealth() * healthPercentFreeze, 1))
		end
	end)
end

function crypt_armor_skeleton_modifier:GetModifierModelChange()
    return "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl"
end

function crypt_armor_skeleton_modifier:GetModifierModelScale()
	if self:GetRemainingTime() > 1 then
    	return 100
    else
    	return 0
    end
end

function crypt_armor_skeleton_modifier:RemoveOnDeath()
    return true
end

function crypt_armor_skeleton_modifier:GetAttackSound()
	return "RPCItems.CryptArmor.BasicAttack"
end

function crypt_armor_skeleton_modifier:GetModifierMaxAttackRange(params)
    return 200
end

function crypt_armor_skeleton_modifier:GetModifierAttackRangeBonus()
    return -99999999999999
end

function crypt_armor_skeleton_modifier:GetDisableHealing()
	return 1
end

function crypt_armor_skeleton_modifier:GetModifierProjectileSpeedBonus()
	return 3000
end

function crypt_armor_skeleton_modifier:GetModifierMoveSpeedBonus_Constant()
    if not IsServer() then
        return
    end
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_RUBY2)
end

function crypt_armor_skeleton_modifier:GetRoshpitMasterAS()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_RUBY1)
end

function crypt_armor_skeleton_modifier:GetRoshpitMasterBaseDMG()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_EMERALD2)*self:GetParent():GetHealth()
end

function crypt_armor_skeleton_modifier:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_SAPPHIRE1)
end

function crypt_armor_skeleton_modifier:OnAttackLanded(event)
    local hero = event.attacker
    local target = event.target
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    if not self:CheckOnAttackLanded(event) then
        return
    end
    if ability:GetGemValue("amethyst") > 0 then
    	target:AddNewModifier(caster, ability, 'modifier_musty_crypt_amethyst_debuff', {duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_AMETHYST1)})
    	local heal = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MUSTY_CRYPT_ARMOR_GEM_AMETHYST2)
    	hero:SetHealth(math.min(hero:GetMaxHealth(), hero:GetHealth() + heal))
    	local limitKey = "musty_armor_lifesteal_"..hero:GetEntityIndex()
	    Util.Common:LimitPerTime(2, 1, limitKey, function()      
	        local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, hero)
	        ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	        ParticleManager:SetParticleControlEnt(pfx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin() + Vector(0,0,70), true)
	        Timers:CreateTimer(1, function()
	            ParticleManager:DestroyParticle(pfx, false)
	        end)
	    end)
    end
end

-- AMETHYST DEBUFF: 

function musty_crypt_amethyst_debuff:RemoveOnDeath()
	return true
end

function musty_crypt_amethyst_debuff:IsDebuff()
	return true
end

function musty_crypt_amethyst_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
    return funcs
end

function musty_crypt_amethyst_debuff:GetDisableHealing()
	return 1
end

function musty_crypt_amethyst_debuff:GetEffectName()
    return "particles/roshpit/items/musty_crypt_amethyst_debuff.vpcf"
end

function musty_crypt_amethyst_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end