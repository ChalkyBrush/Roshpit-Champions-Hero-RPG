require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_genesis_orb = class(base_ability)

modifier_epoch_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_w_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_genesis_orb.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_genesis_orb:GetManaCostBase(level)
    return 0
end

function epoch_genesis_orb:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function epoch_genesis_orb:GetAbilityTargetTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function epoch_genesis_orb:GetAbilityTargetType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function epoch_genesis_orb:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_genesis_orb:GetAbilitySlot()
    return DOTA_W_SLOT
end

function epoch_genesis_orb:GetCastPoint()
    return 0.2
end

function epoch_genesis_orb:GetCastRange()
    return 1000
end

function epoch_genesis_orb:GetCooldownBase(level)
    return 0
end

function epoch_genesis_orb:GetIntrinsicModifierName()
	return "modifier_epoch_w_passive"
end

function epoch_genesis_orb:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.7})
	EmitSoundOn("Epoch.GenesisOrb", caster)
	return true
end

function epoch_genesis_orb:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target = self:GetCastTarget()
    
    self:MainProjectile(caster, target, nil)
    
    Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function epoch_genesis_orb:MainProjectile(source, target, extraData)
	local caster = self:GetCaster()
	local travel_speed = 1800
	if not extraData then
		local bounces = self:GetSpecialValueFor("max_bounces")
		extraData = {bounces = bounces}
	end
	local info =
	{
		Target = target,
		Source = source,
		Ability = self,
		EffectName = "particles/roshpit/epoch/v2_genesis_orb.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 7,
		bProvidesVision = true,
		iVisionRadius = 100,
		iMoveSpeed = travel_speed,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = extraData
	}
	projectile = Filters:TrackingProjectile(info)    
end

function epoch_genesis_orb:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local damage = self:CalculateImpactDamage()
	if target:HasModifier("modifier_epoch_time_bind") then
		DeepPrintTable(extraData)
		extraData.bounces = extraData.bounces - 1
		extraData[target:GetEntityIndex()] = true
		local next_target = nil
		local q_ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
		next_target = q_ability:FindNextTargetForW(target, extraData)
		if next_target and extraData.bounces >= 0 then
			self:MainProjectile(target, next_target, extraData)
		end
	end
	EmitSoundOn("Epoch.GenesisOrb.Impact", target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
end

function epoch_genesis_orb:CalculateImpactDamage()
	local damage = self:GetSpecialValueFor("damage")
	return damage
end