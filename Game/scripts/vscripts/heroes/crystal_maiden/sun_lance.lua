require('heroes/crystal_maiden/init')
require('heroes/crystal_maiden/firestorm_q')
function begin_fireball(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	EmitSoundOn("Sorceress.SunLance.Cast", caster)

	launchFireBall(caster, ability, fv, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
	if caster:HasModifier("modifier_sorceress_glyph_2_1") then
		local rotatedFV = WallPhysics:rotateVector(fv, math.pi / 10)
		launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
		rotatedFV = WallPhysics:rotateVector(fv, -math.pi / 10)
		launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
	end
	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
		if caster.origCaster:HasModifier("modifier_sorceress_glyph_2_1") then
			local rotatedFV = WallPhysics:rotateVector(fv, math.pi / 10)
			launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
			rotatedFV = WallPhysics:rotateVector(fv, -math.pi / 10)
			launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
		end
		caster = caster.origCaster
	end
	local q_1_level = caster:GetRuneValue("q", 1)
	ability.damage = q_1_level * 12000 + 5000 + OverflowProtectedGetAverageTrueAttackDamage(caster) * SORCERESS_ARCANA2_Q1_ATT_TO_DMG_PCT/100 * q_1_level
	Filters:CastSkillArguments(1, caster)
	ability.projectileFV = fv
end

function launchFireBall(caster, ability, fv, projectileParticle, impactRadius)


	local start_radius = impactRadius
	local end_radius = impactRadius
	local range = 2400
	local speed = 1400
	local casterOrigin = caster:GetAbsOrigin()
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin + Vector(0, 0, 100),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack2",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function fireball_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local minLuck = 1
	local damage = ability.damage
	local chance = Q3_CHANCE
	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
		caster = caster.origCaster
	end
	if caster:HasModifier("modifier_sorceress_glyph_2_2") then
		chance = T22_CHANCE
		damage = damage * T22_DAMAGE_AMPLIFY
	end
	if Filters:IsFireBurning(target) then
		local damageMult = 1
		if caster:HasModifier("modifier_sorceress_glyph_5_a") then
			damageMult = T5A_MULTIPLY
		end
		damage = damage * damageMult
	end
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/sun_lance_hit_bullet_endcap.vpcf", target, 3)
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() - ability.projectileFV * 50)
	ParticleManager:SetParticleControl(pfx, 2, target:GetAbsOrigin() + ability.projectileFV * 200)
	ParticleManager:SetParticleControl(pfx, 3, target:GetAbsOrigin())
	EmitSoundOn("Sorceress.SunLance.Impact", target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	local luck = RandomInt(1, 100)
	if luck <= chance then
		local eventTable = {}
		local caster = caster
		local target = target
		local fireAbility = caster:FindAbilityByName("sorceress_fire_arcana_q")
		local damage = fireAbility:GetLevelSpecialValueFor("damage", fireAbility:GetLevel() - 1) + fireAbility.q_4_level * ARCANA2_Q4_INT_TO_DAMAGE * caster:GetIntellect()
		sorceress_firestorm_impact(caster, target, fireAbility, damage, true, 0.2 * caster.q_3_level)
	end
end

function sunlance_think(event)
	local caster = event.caster
	local firestorm = caster:FindAbilityByName("sorceress_fire_arcana_q")
	if firestorm:GetCooldownTimeRemaining() <= 0 then
		if caster.sunlance then
			CustomAbilities:AddAndOrSwapSkill(caster, "sorceress_sun_lance", "sorceress_fire_arcana_q", 0)
			caster.sunlance = false
		end
	end
end