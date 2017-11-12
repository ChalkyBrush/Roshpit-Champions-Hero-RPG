require('heroes/crystal_maiden/init')
require('heroes/crystal_maiden/firestorm_q')
function begin_fireball(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Sorceress.SunLance.Cast", caster)


	launchFireBall(caster, ability, fv, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
    if caster:HasModifier("modifier_sorceress_glyph_2_1") then
        local rotatedFV = WallPhysics:rotateVector(fv, math.pi/10)
        launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
        rotatedFV = WallPhysics:rotateVector(fv, -math.pi/10)
        launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
    end
    local a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
    ability.damage = a_a_level*12000 + 5000 + caster:GetAverageTrueAttackDamage(caster)*0.15*a_a_level
	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
	    if caster.origCaster:HasModifier("modifier_sorceress_glyph_2_1") then
	        local rotatedFV = WallPhysics:rotateVector(fv, math.pi/10)
	        launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
	        rotatedFV = WallPhysics:rotateVector(fv, -math.pi/10)
	        launchFireBall(caster, ability, rotatedFV, "particles/roshpit/sorceress/sun_lance.vpcf", 110)
	    end
	    caster = caster.origCaster
	end
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
	        	vSpawnOrigin = casterOrigin+Vector(0,0,100),
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
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()-ability.projectileFV*50)
	ParticleManager:SetParticleControl(pfx, 2, target:GetAbsOrigin()+ability.projectileFV*200)
	ParticleManager:SetParticleControl(pfx, 3, target:GetAbsOrigin())
	EmitSoundOn("Sorceress.SunLance.Impact", target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	local luck = RandomInt(1, 100)
	if luck <= chance then
		local eventTable = {}
		local caster = caster
		local target = target
		local fireAbility = caster:FindAbilityByName("sorceress_fire_arcana_q")
		local damage = fireAbility:GetLevelSpecialValueFor("damage", fireAbility:GetLevel())
		sorceress_firestorm_impact(caster, target, fireAbility, damage, true, 0.2*caster.c_a_level)
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

function ring_of_fire_burn(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = target.ringOfFireBurn
	print("RING OF FIRE BURN?")
	if damage > 0 then
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	end
end