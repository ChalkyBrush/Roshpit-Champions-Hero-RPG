require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_distortion_orb = class(base_ability)

modifier_epoch_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_e_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_distortion_orb.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_e_in_motion = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_e_in_motion", "heroes/obsidian_destroyer/ability_scripts/epoch_distortion_orb.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_distortion_orb:GetManaCostBase(level)
    return 0
end

function epoch_distortion_orb:GetBehaviorBase()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_epoch_e_in_motion") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else
    	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end
end

function epoch_distortion_orb:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_distortion_orb:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_epoch_e_in_motion") then
		return "epoch/epoch_w_4"
	else
		return "elder_titan_natural_order"
	end
end

function epoch_distortion_orb:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function epoch_distortion_orb:GetCastPoint()
    return 0
end

function epoch_distortion_orb:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function epoch_distortion_orb:GetCooldownBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return EPOCH_E_COOLDOWN[level + 1]
end

function epoch_distortion_orb:GetIntrinsicModifierName()
	return "modifier_epoch_e_passive"
end

function epoch_distortion_orb:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()
    if caster:HasModifier("modifier_epoch_e_in_motion") then
    	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", caster:GetAbsOrigin()+Vector(0,0,90), 3)
    	local newPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), ability.projectilePosition, caster)
    	FindClearSpaceForUnit(caster, newPos, false)
    	ProjectileManager:ProjectileDodge(caster)
    	EmitSoundOn("Epoch.DistortionOrb.Jaunt", caster)
    	caster:RemoveModifierByName("modifier_epoch_e_in_motion")
    	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", caster:GetAbsOrigin()+Vector(0,0,90), 3)
    	ProjectileManager:DestroyLinearProjectile(ability.projectile)
    else
	    StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.64})
		local start_radius = 110
		local end_radius = 110
		local range = self:GetSpecialValueFor("range")
		local speed = self:GetSpecialValueFor("speed")

		local projectileParticle = "particles/units/heroes/hero_puck/time_warp.vpcf"

		local projectileOrigin = caster:GetAbsOrigin()
		local fv = ((target_position - projectileOrigin)*Vector(1,1,0)):Normalized()
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = projectileOrigin,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = true,
			iVisionRadius = 600,
			iMoveSpeed = speed,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ability.projectile = Filters:LinearProjectile(info)
		EmitSoundOn("Epoch.DistortionOrb", caster)
		caster:AddNewModifier(caster, ability, "modifier_epoch_e_in_motion", {})
	    Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	    ability:EndCooldown()
	end
end

function epoch_distortion_orb:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local ability = self
	if not target then
		ability:StartCooldown(ability:GetCooldownBase(-1))
		caster:RemoveModifierByName("modifier_epoch_e_in_motion")
		return true
	else
		local damage = self:GetSpecialValueFor("damage")
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
end

function epoch_distortion_orb:OnProjectileThink(vLoc)
	local ability = self
	ability.projectilePosition = vLoc
	return true
end

-- PASSIVE

function modifier_epoch_e_passive:IsHidden()
    return true
end

function modifier_epoch_e_passive:RemoveOnDeath()
    return false
end

function modifier_epoch_e_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 

    })

end

-- E IN MOTION MODIFIER

function modifier_epoch_e_in_motion:IsHidden()
	return true
end

