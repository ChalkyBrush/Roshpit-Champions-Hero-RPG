jex_fire_fire_e = class({})
require('heroes/arc_warden/abilities/onibi')

function jex_fire_fire_e:OnSpellStart()
    local caster = self:GetCaster()

    local ability = self

    local tech_level = onibi_get_total_tech_level(caster, "fire", "fire", "E")
    ability.tech_level = tech_level
	if not ability.fv then
		ability.fv = caster:GetForwardVector()
	end

	if not ability.movespeed then
		ability.movespeed = 0
		ability.lastPos = caster:GetAbsOrigin()
	end

	ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi/30)
	local fv = caster:GetForwardVector()
	-- ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi*ability.interval/90)

	ability.movespeed = WallPhysics:GetDistance2d(ability.lastPos, caster:GetAbsOrigin())/0.5 + 120
	local distance = ability:GetSpecialValueFor("fire_range")
	local projectileOrigin = ability:GetPointOfCast()
	ability.lastPos = caster:GetAbsOrigin()

	StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=0.9})

	local speed = ability:GetSpecialValueFor("fire_speed_base") + ability:GetSpecialValueFor("fire_speed_per_tech")*tech_level
	local fv = ability:GetDirectionVector()
	fire_fire_e_projectile(caster, ability, distance, fv, 0, projectileOrigin, speed)

	EmitSoundOnLocationWithCaster(projectileOrigin, "Jex.FireSurf.FlameStart", caster)
	local luck = RandomInt(1, 2)
	if luck == 1 then
		EmitSoundOn("Jex.Grunt", caster)
	end
	ability.w_4_level = caster:GetRuneValue("w", 4)
	Filters:CastSkillArguments(3, caster)    
end

function jex_fire_fire_e:OnProjectileHit(target, vLocation)
	local caster = self:GetCaster()
	if target then
		local w_3_level = caster:GetRuneValue("w", 3)
		CustomAbilities:QuickAttachParticle("particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_flash.vpcf", target, 2)
		EmitSoundOn("Jex.FireSurf.FlameHit", target)
		if target == caster then
			local ability = target.onibi:FindAbilityByName("onibi_fire_1")
			StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_FLAIL, rate=0.8, translate="forcestaff_friendly"})
			ability.pushDirection = self.flameFV
			ability.pushSpeed = self.pushSpeed
			ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_e_fire_fire_push", {duration = 0.5})
			EmitSoundOn("Jex.FireSurf.FlameHitSelf", caster)
		elseif target:GetTeamNumber() ~= caster:GetTeamNumber() then
			local damage = ability:GetSpecialValueFor("base_damage") + ability:GetSpecialValueFor("attack_damage_added_per_tech")*ability.tech_level*(OverflowProtectedGetAverageTrueAttackDamage(caster)/100)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			if ability.w_4_level > 0 then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_e_fire_fire_burn", {duration = 4})
			end
		end
	end
end

function fire_fire_e_projectile(caster, ability, range, fv, pullback, projectileOrigin, speed)
	local projectileParticle = "particles/roshpit/flamewaker/dragonfire.vpcf"
	local start_radius = 240
	local end_radius = 240
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = projectileOrigin+Vector(0,0,20)+fv*pullback,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_attack1",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	ability.flameFV = fv
	ability.pushSpeed = speed*0.04
end