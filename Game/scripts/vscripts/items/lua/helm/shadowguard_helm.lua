require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_shadowguard_helm = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_shadowguard_helm
local itemClassName = 'item_rpc_shadowguard_helm'

modifier_shadowguard_helm = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_shadowguard_helm
local modifierName = 'modifier_shadowguard_helm'
LinkLuaModifier(modifierName, "items/lua/helm/shadowguard_helm", LUA_MODIFIER_MOTION_NONE)

modifier_shadowguard_helm_in_aura_range = class(npc_base_modifier, nil, npc_base_modifier)
local aura_debuff_class = modifier_shadowguard_helm_in_aura_range
LinkLuaModifier("modifier_shadowguard_helm_in_aura_range", "items/lua/helm/shadowguard_helm", LUA_MODIFIER_MOTION_NONE)

modifier_shadowguard_helm_disarmed = class(npc_base_modifier, nil, npc_base_modifier)
local disarm_modifier_class = modifier_shadowguard_helm_disarmed
LinkLuaModifier("modifier_shadowguard_helm_disarmed", "items/lua/helm/shadowguard_helm", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Mask of the Phantom Sorcerer'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_shadowguard_helm"
    self:SetSpecialValue("shadowguard_helm", "#6E487D")
end
function itemClass:RollProperty2(item_level) 
    local luck = RandomInt(1, 7)
    if luck < 6 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    elseif luck == 6 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "armor", 3)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t3_rune", 1)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end

------------
--MODIFIER--
------------

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
    return "modifier_shadowguard_helm_in_aura_range"
end

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

function aura_debuff_class:OnAttackStart(event)
	local hero = self:GetCaster().hero
	local ability = self:GetAbility()
	local attacker = event.attacker
	local target = event.target
	local parent = self:GetParent()
    if not self:CheckOnAttackLanded(event) then
        return
    end
	local limitKey = hero:GetEntityIndex().."_shadowguard"
	local max_procs_per_second = ITEM_RPC_SHADOWGUARD_HELM_MAX_PROCS_PER_SECOND + ability:GetFinalGemPropertyValue("ruby", GEM_RPC_SHADOWGUARD_HELM_RUBY2)
    Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()      
		local travel_speed = ITEM_RPC_SHADOWGUARD_HELM_PROJECTILE_SPEED + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SHADOWGUARD_HELM_EMERALD)
		local info =
		{
			Target = attacker,
			Source = hero,
			Ability = ability,
			EffectName = "particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance.vpcf",
			StartPosition = "attach_attack1",
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = true,
			iVisionRadius = 100,
			iMoveSpeed = travel_speed,
			iVisionTeamNumber = hero:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)

		EmitSoundOn("RPCItems.ShadowguardHelm.Shoot", hero)
    end)

end

function itemClass:OnProjectileHit(target, location)
	local hero = self:GetCaster()
	local ability = self
	local caster = self:GetCaster()
	EmitSoundOn("RPCItems.ShadowguardHelm.Impact", hero)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ((ITEM_RPC_SHADOWGUARD_HELM_DMG_PCT_ATK_POWER + ability:GetFinalGemPropertyValue("ruby", GEM_RPC_SHADOWGUARD_HELM_RUBY1))/100)
	local disarm_duration = ITEM_RPC_SHADOWGUARD_HELM_DISARM_DURATION + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SHADOWGUARD_HELM_SAPPHIRE)
	target:AddNewModifier(caster, ability, "modifier_shadowguard_helm_disarmed", {duration = ITEM_RPC_SHADOWGUARD_HELM_DISARM_DURATION})
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_GHOST)
end

function disarm_modifier_class:IsHidden()
	return false
end

function disarm_modifier_class:IsDebuff()
	return true
end

function disarm_modifier_class:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function disarm_modifier_class:GetEffectName()
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end

function disarm_modifier_class:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function disarm_modifier_class:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS, MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS})
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function disarm_modifier_class:OnDestroy()
    if not IsServer() then return end
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function disarm_modifier_class:GetRoshpitMagicArmorBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SHADOWGUARD_HELM_AMETHYST)
end

function disarm_modifier_class:GetRoshpitSpellPierceBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SHADOWGUARD_HELM_AMETHYST)
end