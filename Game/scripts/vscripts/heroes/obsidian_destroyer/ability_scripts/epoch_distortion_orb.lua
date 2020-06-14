require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_distortion_orb = class(base_ability)

modifier_epoch_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_e_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_distortion_orb.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_distortion_orb:GetManaCostBase(level)
    return 0
end

function epoch_distortion_orb:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function epoch_distortion_orb:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_distortion_orb:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function epoch_distortion_orb:GetCastPoint()
    return 0.3
end

function epoch_distortion_orb:GetCastRange()
    return 2000
end

function epoch_distortion_orb:GetCooldownBase(level)
    return EPOCH_Q_COOLDOWN
end

function epoch_distortion_orb:GetIntrinsicModifierName()
	return "modifier_epoch_e_passive"
end

function epoch_distortion_orb:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function epoch_distortion_orb:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	local target_position = self:GetCastPosition()
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.94})

	return true
end

function epoch_distortion_orb:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()

    
	local start_radius = 110
	local end_radius = 110
	local range = self:GetSpecialValueFor("range")
	local speed = self:GetSpecialValueFor("speed")
	speed = speed * (1 + (EPOCH_Q4_PROJECTILE_SPEED/100)*caster:GetRuneValue("q", 4))
	local projectileParticle = "particles/roshpit/epoch/time_binder_projectile_hellfire_linear.vpcf"

	local perpFV = WallPhysics:rotateVector(caster:GetForwardVector()*Vector(1,1,0), 2*math.pi/4)
	local projectileOrigin = caster:GetAbsOrigin() + Vector(0,0,160) + (perpFV*40) + (caster:GetForwardVector()*40)

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
		iVisionRadius = 100,
		iMoveSpeed = speed,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	Filters:LinearProjectile(info)
	EmitSoundOn("Epoch.TimeBinder.Launch", caster)
    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
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

